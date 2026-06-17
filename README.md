# Documentation Quality Skills

A family of four skills for comprehensive documentation auditing and improvement.

## The Skills

### doc-accuracy-audit
Audits documentation accuracy against a source of truth: CLI source code, Terraform provider schemas, or OpenAPI specifications. Finds ghost items (documented but don't exist), hidden items (exist but not documented), and detail mismatches.

**Supports:**
- CLI Tools (commands, flags, arguments, defaults)
- Terraform Providers (resources, data sources, attributes)
- API Documentation (OpenAPI/Swagger specs)

### doc-quality-audit
Audits documentation for intrinsic quality: tone, style, clarity, plain language compliance, formatting. Evaluates quality dimensions using an embedded baseline style guide (IBM, PatternFly, Red Hat standards).

**Dimensions:**
- Default (7 core): Tone, Clarity, Structure, Consistency, Completeness, Audience Appropriateness, Example Quality
- Comprehensive mode adds 3 more: Accessibility, SEO/Discoverability, Visual Formatting

The skill prompts you to choose between default and comprehensive mode at the start of each audit.

### doc-quality-revise
Applies corrections from audit reports using a semi-automated workflow: auto-revises simple issues (word replacements, contractions, formatting), guides interactive manual review for complex changes (rewrites, missing content, structural changes).

**Features:**
- Categorizes revisions by rule type (auto-revisable vs manual review)
- Preview diffs before applying changes
- Git branch workflow with separate commits per revision
- Non-git output strategies (separate directory or side-by-side files)
- Interactive A/B/C/D options for each manual revision

### doc-quality-check
Orchestrates the complete pipeline: runs doc-accuracy-audit → doc-quality-audit → doc-quality-revise in sequence with timestamped reports. Single-command execution of the full workflow with optional phase skipping.

**Features:**
- Timestamped reports (preserves audit history)
- Error recovery between phases
- Flexible phase control (skip phases, run subsets)
- Status reporting at each stage

## The Pipeline

The skills form a complete documentation improvement workflow:

1. **Verify accuracy** → `/doc-accuracy-audit` → `accuracy-audit-report.md`
   - Compare docs against source code, schema, or spec
   - Find ghost/hidden items and detail mismatches
   
2. **Audit for quality** → `/doc-quality-audit` → `quality-audit-report.md`
   - Evaluate tone, style, clarity, formatting
   - Check plain language compliance
   
3. **Apply fixes** → `/doc-quality-revise` (reads audit reports) → revised docs
   - Auto-revise simple issues
   - Guide interactive manual review for complex changes

Use `/doc-quality-check` to automate this entire workflow with a single command.

## Installation

See [INSTALL.md](INSTALL.md) for detailed instructions.

**Quick start (individual skills):**

```bash
ln -sf ~/projects/doc-quality-skills/skills/doc-accuracy-audit ~/.claude/skills/doc-accuracy-audit
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-audit ~/.claude/skills/doc-quality-audit
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-revise ~/.claude/skills/doc-quality-revise
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-check ~/.claude/skills/doc-quality-check
```

Then reload your skill system.

## Usage

Invoke skills by name:

```
/doc-accuracy-audit
/doc-quality-audit
/doc-quality-revise
/doc-quality-check
```

Or describe your intent naturally -- each skill triggers on relevant phrases like:
- "audit the docs for my CLI tool"
- "check if the provider docs match the schema"
- "verify our API docs match the OpenAPI spec"
- "audit documentation for tone and clarity"
- "apply fixes from the audit report"
- "run the full documentation quality pipeline"

## Testing

Run test suite to validate eval structure:
```bash
./test-runner.sh
```

Each skill has evals in `skills/<skill-name>/evals/evals.json` covering common scenarios and edge cases.

Shared test docs in `test-docs/`:
- `sample-cli-doc.md` - CLI documentation with intentional quality and accuracy issues
- `sample-terraform-doc.md` - Terraform provider documentation with issues

These files are used by both doc-quality-audit and doc-quality-revise for testing and demonstration.

## Related Skills

These skills complement each other but are independent. You can use any combination:
- Use doc-accuracy-audit alone to verify docs match source code
- Use doc-quality-audit alone for style/tone reviews
- Use doc-quality-revise alone if you have existing audit reports

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
