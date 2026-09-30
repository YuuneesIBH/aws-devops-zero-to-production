"""Small API showing EKS Pod Identity -> Secrets Manager -> private RDS."""

import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


def database_check():
    import boto3
    import psycopg

    secret_arn = os.environ["DB_SECRET_ARN"]
    secret = boto3.client("secretsmanager").get_secret_value(SecretId=secret_arn)
    credentials = json.loads(secret["SecretString"])
    with psycopg.connect(
        host=os.environ["DB_HOST"],
        dbname=os.environ.get("DB_NAME", "platform"),
        user=credentials["username"],
        password=credentials["password"],
        port=int(os.environ.get("DB_PORT", "5432")),
        sslmode="require",
        connect_timeout=3,
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            return cursor.fetchone()[0] == 1


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            status, body = 200, {"status": "alive"}
        elif self.path == "/ready":
            try:
                ready = database_check()
            except Exception as error:
                print(f"Database readiness failed: {type(error).__name__}", flush=True)
                ready = False
            status, body = (200 if ready else 503), {"ready": ready}
        elif self.path == "/":
            status, body = 200, {"service": "platform-api", "message": "AWS DevOps platform"}
        else:
            status, body = 404, {"error": "not found"}
        payload = json.dumps(body).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)


if __name__ == "__main__":
    ThreadingHTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
