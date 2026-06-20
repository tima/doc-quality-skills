# Documentation Quality Skills

A family of four skills for comprehensive documentation auditing and improvement.

## Skills

- **[doc-accuracy-audit](skills/doc-accuracy-audit/SKILL.md)** — Cross-references docs against a source of truth (CLI code, Terraform schemas, OpenAPI specs). Finds ghost items (documented but missing), hidden items (exist but undocumented), and detail mismatches.

- **[doc-quality-audit](skills/doc-quality-audit/SKILL.md)** — Evaluates docs for tone, style, clarity, and plain language compliance. Reports issues with severity ratings and suggestions.

- **[doc-quality-revise](skills/doc-quality-revise/SKILL.md)** — Applies corrections from audit reports: auto-revises simple issues, guides interactive review for complex changes.

- **[doc-quality-check](skills/doc-quality-check/SKILL.md)** — Orchestrates the full pipeline in one command: accuracy audit → quality audit → apply revisions.

## Pipeline

```
/doc-accuracy-audit → accuracy-audit-report.md
/doc-quality-audit  → quality-audit-report.md
/doc-quality-revise → revised docs
/doc-quality-check  → runs all three in sequence
```

## Installation

```bash
# All skills, user scope — available in all sessions (recommended)
npx skills add tima/doc-quality-skills -g

# All skills, project scope — this project only
npx skills add tima/doc-quality-skills

# Specific skills only
npx skills add tima/doc-quality-skills --skill doc-accuracy-audit -g
```

Local development install:
```bash
git clone https://github.com/tima/doc-quality-skills.git ~/projects/doc-quality-skills
# Symlink each skill individually
ln -sf ~/projects/doc-quality-skills/skills/doc-accuracy-audit ~/.claude/skills/doc-accuracy-audit
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-audit ~/.claude/skills/doc-quality-audit
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-revise ~/.claude/skills/doc-quality-revise
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-check ~/.claude/skills/doc-quality-check
```

### Uninstall

```bash
npx skills remove doc-accuracy-audit           # project scope
npx skills remove doc-accuracy-audit --global  # user scope
# (repeat for each skill)
```

## License

MIT — see [LICENSE](LICENSE).
