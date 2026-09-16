#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
lean --version
lake build --wfail
lake env lean -DwarningAsError=true LeanSyc/JSP000998.lean
lake env lean -DwarningAsError=true LeanSyc/JSP000307.lean
python3 - <<'PY'
from pathlib import Path
import re
paths = [Path('LeanSyc.lean'), *Path('LeanSyc').glob('*.lean')]
for path in paths:
    found = re.search(r'\b(sorry|admit|axiom|unsafe|extern|native_decide|partial)\b', path.read_text())
    if found:
        raise SystemExit(f'Prohibited token in {path}: {found.group()}')
print('Project Lean source scan passed.')
PY
lake env leanchecker --verbose LeanSyc.JSP000998
lake env leanchecker --verbose LeanSyc.JSP000307
echo 'Bundled kernel replay passed (not an independent checker implementation).'
