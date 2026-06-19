# doc-accuracy-audit

Cross-references documentation against a source of truth to find discrepancies. Given a CLI codebase, Terraform provider schema, or OpenAPI spec alongside the published docs, it identifies ghost items (documented but do not exist in source), hidden items (exist in source but not documented), and detail mismatches such as wrong flag defaults, incorrect attribute types, or missing parameters.

## What it audits

- **CLI tools** — command tree, flags, arguments, aliases, defaults
- **Terraform providers** — resources, data sources, schema attributes, required/optional status
- **API documentation** — OpenAPI/Swagger endpoints, parameters, request/response schemas, auth

Findings are annotated with confidence levels (High/Medium/Low) and follow a zero-hallucination policy: if information cannot be verified, the skill says so rather than inferring.

## Invocation

```
/doc-accuracy-audit path/to/docs
/doc-accuracy-audit path/to/docs --type cli --source https://github.com/org/repo
/doc-accuracy-audit path/to/docs --output custom-report.md
/doc-accuracy-audit path/to/docs --dry-run
/doc-accuracy-audit path/to/docs --since HEAD~3
```

## Input

- Documentation files or URLs to audit
- Source of truth: code repository, `terraform providers schema -json` output, or OpenAPI/Swagger spec file
- Optional: upstream docs (official) and downstream docs (enterprise) for alignment checking

## Output

Timestamped Markdown report: `{project-name}-accuracy-audit-YYYYMMDD-HHMM-UTC.md`

Report contains findings per audit task (inventory, detail audit, multi-source alignment, example validation), each entry showing the doc claim, source of truth, verdict, and file path. Ends with a summary and recommendations section.
