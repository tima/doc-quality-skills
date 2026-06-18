# doc-accuracy-audit Quick Reference

## When to Use

Docs might not match source code, schema, or API spec.

## Usage
```
/doc-accuracy-audit <path> [flags]
```

## Flags
```
--output <filename>     Override default report filename
--dry-run               Show report without saving
--since <git-ref>       Audit only files changed since ref
--type <cli|terraform|api>  Project type (skip type prompt)
--source <path-or-url>  Source of truth (skip source prompt)
--upstream <path-or-url>  Upstream docs (skip prompt)
--downstream <path-or-url> Downstream docs (skip prompt)
```

## Examples

**CLI tool audit:**
```
/doc-accuracy-audit docs/cli/
```

**Terraform provider audit:**
```
/doc-accuracy-audit docs/terraform/
```

**API documentation audit:**
```
/doc-accuracy-audit docs/api/
```

**Custom output:**
```
/doc-accuracy-audit docs/ --output my-audit-20260616.md
```

**Incremental (changed files only):**
```
/doc-accuracy-audit docs/ --since HEAD~3
```

## Common Issues

| Issue | Meaning | Fix |
|-------|---------|-----|
| Information not found | Can't access source/docs | Verify paths, check permissions |
| Conflicting evidence | Multiple sources disagree | Review sources manually |
| TEXT_NOT_FOUND | Can't locate documented item | Check source code/schema |

## Output

**Filename:** `{project}-accuracy-audit-YYYYMMDD-HHMM-UTC.md`

**Location:** Current directory

**Contains:**
- Ghost items (documented but don't exist)
- Hidden items (exist but not documented)
- Detail mismatches (defaults, types, names)

## See Also

- [SKILL.md](SKILL.md) - Full documentation
- [doc-quality-audit](../doc-quality-audit/) - Style/tone audit
- [doc-quality-revise](../doc-quality-revise/) - Apply fixes
