"""
Ajoute l'import de `trace.dart` dans les fichiers Dart qui utilisent `traceCallback` mais ne l'importent pas.
Crée des backups `*.bak` avant écriture.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / 'lib'
IMPORT_LINE = "import 'package:ecotrack/core/utils/trace.dart';\n"

count = 0
files_changed = []
for path in LIB.rglob('*.dart'):
    text = path.read_text(encoding='utf-8')
    if 'traceCallback(' in text and "core/utils/trace.dart" not in text:
        # find end of import block
        m = re.search(r'(?:^\s*import\s+["\'][^;]+;\s*\n)+', text, flags=re.M)
        if m:
            insert_pos = m.end()
            new_text = text[:insert_pos] + IMPORT_LINE + text[insert_pos:]
        else:
            # insert after any library declaration or at top
            m2 = re.search(r'^\s*library\s+[^;]+;\s*\n', text, flags=re.M)
            if m2:
                insert_pos = m2.end()
                new_text = text[:insert_pos] + IMPORT_LINE + text[insert_pos:]
            else:
                new_text = IMPORT_LINE + text
        bak = str(path) + '.bak_import'
        Path(bak).write_text(text, encoding='utf-8')
        path.write_text(new_text, encoding='utf-8')
        files_changed.append(str(path))
        count += 1

print(f"Added import to {count} files")
for f in files_changed:
    print(' -', f)
print('Backups saved with .bak_import extension')
