from pathlib import Path
p=Path('lib/features/auth/splash_screen.dart').read_text()
stack=[]
pairs={'(':')','[':']','{':'}'}
for idx,ch in enumerate(p,1):
    if ch in pairs:
        stack.append((ch,idx))
    elif ch in pairs.values():
        if not stack:
            print('Unmatched closing',ch,'at',idx)
            break
        op,pos=stack.pop()
        if pairs[op]!=ch:
            print('Mismatch: opened',op,'at',pos,'but closed',ch,'at',idx)
            break
else:
    if stack:
        print('Unclosed openings:')
        for op,pos in stack[-20:]:
            print(op,'at',pos)
    else:
        print('All balanced')
