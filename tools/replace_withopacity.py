from pathlib import Path
import re

root = Path('lib')
for path in root.rglob('*.dart'):
    text = path.read_text(encoding='utf-8')
    new_text = re.sub(r'\.withOpacity\(', '.withValues(alpha: ', text)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        print(path)
