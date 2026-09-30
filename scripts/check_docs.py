"""Check relative Markdown links and required safety text in hands-on labs."""

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
LINK = re.compile(r"(?<!!)\[[^]]+\]\(([^)]+)\)")
errors = []

for doc in ROOT.rglob("*.md"):
    if ".git" in doc.parts:
        continue
    text = doc.read_text(encoding="utf-8")
    for target in LINK.findall(text):
        if target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        path = (doc.parent / target.split("#", 1)[0]).resolve()
        if not path.exists():
            errors.append(f"{doc.relative_to(ROOT)}: missing {target}")
    if "labs" in doc.parts and doc.name == "README.md":
        for word in ("Cost", "Cleanup", "Knowledge check"):
            if word.lower() not in text.lower():
                errors.append(f"{doc.relative_to(ROOT)}: missing {word}")

for error in errors:
    print(error, file=sys.stderr)
print(f"Checked Markdown: {len(errors)} error(s)")
sys.exit(bool(errors))
