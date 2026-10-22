"""Merges English strings into the ARB catalogue.

Usage: python3 tool/add_strings.py '{"key": "Text", ...}'
Then regenerate with: dart run intl_utils:generate
"""
import json
import sys
from collections import OrderedDict
from pathlib import Path

ARB = Path(__file__).resolve().parent.parent / "lib/core/translations/l10n/intl_en.arb"

data = json.loads(ARB.read_text(), object_pairs_hook=OrderedDict) if ARB.exists() else OrderedDict({"@@locale": "en"})
new = json.loads(sys.argv[1], object_pairs_hook=OrderedDict)
for key, value in new.items():
    if key in data and data[key] != value:
        print(f"changed: {key}")
    data[key] = value
ARB.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
print(f"{len([k for k in data if not k.startswith('@')])} strings")
