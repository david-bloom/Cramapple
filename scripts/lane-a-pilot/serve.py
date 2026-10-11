"""Static server for the clipboard test. The async clipboard API needs a secure
context, so the page must be served over localhost rather than opened as a file."""
import functools, http.server, os, socketserver

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out")
os.chdir(ROOT)
Handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=ROOT)
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("127.0.0.1", 5191), Handler) as httpd:
    print("serving", ROOT, "on http://localhost:5191/clipboard-test.html", flush=True)
    httpd.serve_forever()
