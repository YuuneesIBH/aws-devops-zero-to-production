import importlib.util
import json
import pathlib
import threading
import unittest
from http.server import ThreadingHTTPServer
from urllib.request import urlopen


APP = pathlib.Path(__file__).resolve().parents[1] / "app.py"
spec = importlib.util.spec_from_file_location("demo_app", APP)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class ApiTest(unittest.TestCase):
    def test_health_and_root(self):
        server = ThreadingHTTPServer(("127.0.0.1", 0), module.Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        try:
            base = f"http://127.0.0.1:{server.server_port}"
            with urlopen(base + "/health") as response:
                self.assertEqual(response.status, 200)
                self.assertEqual(json.load(response), {"status": "ok"})
            with urlopen(base + "/") as response:
                self.assertEqual(response.status, 200)
                self.assertIn("message", json.load(response))
        finally:
            server.shutdown()
            server.server_close()
            thread.join()


if __name__ == "__main__":
    unittest.main()
