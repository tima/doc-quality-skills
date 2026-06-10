# doc-accuracy-audit

> Part of the [doc-quality-skills](../) family. See the [family README](../README.md) for the complete pipeline.

A Claude Code skill that audits documentation accuracy against a source of truth. Finds ghost items (documented but don't exist), hidden items (exist but not documented), and detail mismatches across three project types.

## Supported Project Types

- **CLI Tools** -- Audit source code against CLI documentation (commands, flags, arguments, defaults)
- **Terraform Providers** -- Audit provider schema/source code against provider documentation (resources, data sources, attributes)
- **API Documentation** -- Audit an OpenAPI/Swagger spec against API documentation (endpoints, parameters, response schemas)

## Installation

See [../INSTALL.md](../INSTALL.md) for detailed instructions.

**Quick install:**

```bash
ln -sf ~/projects/doc-quality-skills/doc-accuracy-audit ~/.claude/skills/doc-accuracy-audit
```

## Usage

Invoke from Claude Code:

```
/doc-accuracy-audit
```

Or describe your intent naturally -- the skill triggers on phrases like:
- "audit the docs for my CLI tool"
- "check if the provider docs match the schema"
- "verify our API docs match the OpenAPI spec"
- "find ghost commands in the documentation"

## Workflow

1. **Gather Context** -- Identifies project type, collects source of truth and documentation locations
2. **Scope the Audit** -- Presents 4 audit tasks, offers full or focused audit
3. **Clarify Ambiguities** -- Resolves any unclear terminology or scope
4. **Execute the Audit** -- Performs selected tasks with strict zero-hallucination policy
5. **Format the Report** -- Generates markdown report with findings, verdicts, and recommendations

## Audit Tasks

| Task | CLI | Terraform | API |
|------|-----|-----------|-----|
| 1. Inventory | Command tree vs docs | Resource registry vs docs | Endpoint list vs docs |
| 2. Detail Audit | Flags, defaults | Schema attributes | Parameters, schemas |
| 3. Alignment | Upstream vs downstream | Registry vs enterprise | Spec vs docs site |
| 4. Example Validation | Trace through code | HCL vs schema | Examples vs spec |

## Report Format

Findings use a consistent format:

```
**Doc Claim:** [what the docs say]
**Source of Truth:** [what the code/schema/spec defines]
**Verdict:** [Verified / Ghost / Hidden / Mismatch]
**File Path:** [relevant file and location]
```

Reports are saved as `{project-name}-docs-audit.md` in the working directory.

## Related Skills

- **doc-quality-audit** -- Audits documentation for tone, style, clarity, and plain language compliance (does not compare against source code)
- **doc-quality-revise** -- Applies corrections from doc-quality-audit reports using a semi-automated workflow

## Replaces

This skill replaces the following individual skills:
- `cli-doc-audit` -- CLI-specific documentation audit
- `terraform-provider-audit` -- Terraform provider documentation audit
