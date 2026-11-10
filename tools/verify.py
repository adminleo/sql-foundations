"""Run every statement in sql/*.sql against the local SQLite copy.

The files are MySQL (that is what runs in Workbench); this translates the few
constructs SQLite spells differently and reports anything that fails.
"""
import os, re, sqlite3, sys

ROOT = os.path.dirname(os.path.abspath(__file__))
DB   = os.path.join(ROOT, "publications.db")

def to_sqlite(sql):
    sql = re.sub(r'^\s*USE\s+\w+\s*;?\s*$', '', sql, flags=re.I | re.M)
    while True:                                   # CONCAT(a,b,c) -> (a || b || c)
        i = sql.upper().find("CONCAT(")
        if i == -1: break
        j, depth = i + 7, 1
        while j < len(sql) and depth:
            if sql[j] == '(': depth += 1
            elif sql[j] == ')': depth -= 1
            j += 1
        inner, parts, d, cur = sql[i+7:j-1], [], 0, ''
        for ch in inner:
            if ch == '(': d += 1
            if ch == ')': d -= 1
            if ch == ',' and d == 0: parts.append(cur.strip()); cur = ''
            else: cur += ch
        parts.append(cur.strip())
        sql = sql[:i] + '(' + ' || '.join(parts) + ')' + sql[j:]
    return sql

def split_statements(text):
    """Split on semicolons that are real statement terminators — not the ones
    sitting inside -- comments, /* */ blocks or quoted strings."""
    out, cur, i, n = [], '', 0, len(text)
    while i < n:
        ch = text[i]
        if ch == '-' and text[i:i+2] == '--':
            j = text.find('\n', i); j = n if j == -1 else j
            cur += text[i:j]; i = j; continue
        if ch == '/' and text[i:i+2] == '/*':
            j = text.find('*/', i); j = n if j == -1 else j + 2
            cur += text[i:j]; i = j; continue
        if ch == "'":
            j = i + 1
            while j < n:
                if text[j] == "'" and text[j:j+2] != "''": break
                j += 2 if text[j:j+2] == "''" else 1
            cur += text[i:j+1]; i = j + 1; continue
        if ch == ';':
            out.append(cur); cur = ''; i += 1; continue
        cur += ch; i += 1
    out.append(cur)
    return out

db = sqlite3.connect(DB)
total = fails = 0
for fn in sorted(os.listdir(os.path.join(ROOT, "sql"))):
    if not fn.endswith(".sql"): continue
    text = open(os.path.join(ROOT, "sql", fn)).read()
    stmts = [s for s in split_statements(text)
             if re.sub(r'(--[^\n]*|\s|USE\s+\w+)', '', s)]
    ok = 0
    for i, st in enumerate(stmts, 1):
        total += 1
        try:
            rows = db.execute(to_sqlite(st)).fetchall(); ok += 1
        except Exception as e:
            fails += 1
            label = next((l.strip() for l in st.splitlines() if l.strip().startswith("--")), "?")
            print(f"  FAIL {fn} #{i}: {label[:60]}\n       {e}")
    print(f"{fn:36s} {ok}/{len(stmts)} ok")
print(f"\n{total - fails}/{total} Statements laufen. Fehler: {fails}")
sys.exit(1 if fails else 0)
