"""
Script d'instrumentation des callbacks simple dans `lib/`.
Remplace les occurrences simples:
  onPressed: () => expr
  onTap: () => expr
par:
  onPressed: traceCallback("file:line:onPressed", () => expr)

Le script crée une sauvegarde `*.bak` avant modification.
"""
import re
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / 'lib'
PATTERN = re.compile(r'(\b(onPressed|onTap)\s*:\s*)\(\s*\)\s*=>\s*([^,\n]+)')

count = 0
files_changed = []
for path in LIB.rglob('*.dart'):
    text = path.read_text(encoding='utf-8')
    lines = text.splitlines(keepends=True)
    new_lines = []
    changed = False
    for i, line in enumerate(lines):
        m = PATTERN.search(line)
        if m:
            before = m.group(1)
            kind = m.group(2)
            expr = m.group(3).rstrip()
            name = f"{path.name}:{i+1}:{kind}"
            new_line = line[:m.start()] + f"{before}traceCallback(\"{name}\", () => {expr})" + line[m.end():]
            new_lines.append(new_line)
            changed = True
            count += 1
        else:
            new_lines.append(line)
    if changed:
        bak = str(path) + '.bak'
        Path(bak).write_text(text, encoding='utf-8')
        path.write_text(''.join(new_lines), encoding='utf-8')
        files_changed.append(str(path))

print(f"Instrumented {count} callbacks in {len(files_changed)} files")
if files_changed:
    for f in files_changed:
        print(' -', f)
print('Backups saved with .bak extension next to modified files')
