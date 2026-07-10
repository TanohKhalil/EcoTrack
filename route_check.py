import re
from pathlib import Path
root = Path(r'c:/Users/Msi/Desktop/ecotrack')
used=set(); decl=set();

for p in root.rglob('*.dart'):
    text = p.read_text(encoding='utf-8')
    used.update(re.findall(r"context\.push\(['\"](/[^'\"]+)['\"]\)", text))
    used.update(re.findall(r"context\.pop\(\)", text))
    decl.update(re.findall(r"GoRoute\(\s*path:\s*['\"](/[^'\"]+)['\"]", text))

print('MISSING:')
for r in sorted(used - decl): print(r)
print('EXTRA:')
for r in sorted(decl - used): print(r)

empty_callbacks=[]
for p in root.rglob('*.dart'):
    text = p.read_text(encoding='utf-8')
    for match in re.finditer(r"(onPressed|onTap)\s*:\s*(?:\(\)\s*=>\s*\{|\(\)\s*\{)([^}]*)\}", text, re.S):
        body = match.group(2).strip()
        if body == '' or re.fullmatch(r'//.*', body.strip()) or re.fullmatch(r'//.*\n', body.strip(), re.S):
            empty_callbacks.append((p.relative_to(root), match.group(1), body))

print('EMPTY_CALLBACKS:')
for p, cb, body in empty_callbacks:
    print(p, cb, repr(body[:100]))
