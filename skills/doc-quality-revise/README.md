# doc-quality-revise

Applies corrections from audit reports produced by `doc-accuracy-audit` and `doc-quality-audit`. It uses a semi-automated workflow: simple issues (word replacements, contraction changes, formatting fixes) are batched and previewed for approval; complex changes (rewrites, structural edits, missing content) go through an interactive one-by-one review with A/B/C/D options at each step.

## What it does

- Parses one or both audit report files and categorizes each finding as auto-revisable or manual review
- Shows a unified diff of all auto-revisions before applying anything
- Guides interactive review for complex changes, with options to apply as-is, modify, skip, or batch-approve remaining items
- Creates a git branch (`doc-quality-revisions-YYYY-MM-DD`) with separate commits per revision, or writes to a separate output directory/side-by-side files if the docs are not in a git repo

## Invocation

```
/doc-quality-revise
/doc-quality-revise --quality-report my-audit.md
/doc-quality-revise --accuracy-report acc.md --quality-report qual.md
/doc-quality-revise --auto-approve
/doc-quality-revise --interactive-only
/doc-quality-revise --dry-run
```

When no flags are given, the skill auto-discovers audit report files in the current directory.

## Input

- Audit report(s) from `doc-accuracy-audit` (`*-accuracy-audit*.md`) and/or `doc-quality-audit` (`*-quality-audit*.md`)
- Documentation root directory (prompted if not inferable)

## Output

- Revised documentation files (in-place on a git branch, or in a separate output directory)
- Git commits per revision (git workflow), or revised files in chosen output location (non-git workflow)
