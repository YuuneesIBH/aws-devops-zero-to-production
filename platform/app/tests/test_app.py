import importlib.util
import json
import pathlib
import threading
import unittest
from http.server import ThreadingHTTPServer
from unittest.mock import patch
from urllib.error import HTTPError
from urllib.request import urlopen

path = pathlib.Path(__file__).resolve().parents[1] / "app.py"
spec = importlib.util.spec_from_file_location("platform_api", path)
app = importlib.util.module_from_spec(spec)
spec.loader.exec_module(app)


class HandlerTest(unittest.TestCase):
    def test_health_readiness_and_missing_route(self):
        server = ThreadingHTTPServer(("127.0.0.1", 0), app.Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        base = f"http://127.0.0.1:{server.server_port}"
        try:
            with urlopen(base + "/health") as response:
                self.assertEqual(json.load(response), {"status": "alive"})
            with patch.object(app, "database_check", return_value=True):
                with urlopen(base + "/ready") as response:
                    self.assertEqual(json.load(response), {"ready": True})
            with patch.object(app, "database_check", side_effect=RuntimeError("secret")):
                with self.assertRaises(HTTPError) as failure:
                    urlopen(base + "/ready")
                self.assertEqual(failure.exception.code, 503)
        finally:
            server.shutdown()
            server.server_close()
            thread.join()
