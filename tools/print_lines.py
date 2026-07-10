from pathlib import Path
s=Path('lib/features/auth/splash_screen.dart').read_text().splitlines()
for i,l in enumerate(s,1):
    print(f"{i:04} {l}")
