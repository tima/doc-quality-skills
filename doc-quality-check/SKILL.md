---
name: doc-quality-check
description: Orchestrate complete documentation quality pipeline (accuracy → quality → revise) with timestamped reports
triggers:
  - "run the doc quality pipeline"
  - "check documentation quality"
  - "audit and fix docs"
  - "complete doc audit"
---

# doc-quality-check

Run the complete documentation quality pipeline: accuracy audit → quality audit → apply revisions.

**Part of:** [doc-quality-skills](../) family

## What This Does

Orchestrates three skills in sequence:
1. `/doc-accuracy-audit` - Compare docs against source of truth
2. `/doc-quality-audit` - Evaluate style, tone, clarity
3. `/doc-quality-revise` - Apply corrections interactively

All reports are timestamped to preserve audit history across runs.

## Arguments

Required:
- `path/to/docs` - Directory or file to audit

Optional flags:
- `--skip-accuracy` - Skip accuracy audit phase
- `--skip-quality` - Skip quality audit phase
- `--audit-only` - Skip revision phase (audit only)
- `--accuracy-only` - Run only accuracy audit
- `--quality-only` - Run only quality audit

**Flag validation:** Cannot combine `--skip-accuracy` + `--skip-quality` (nothing to audit)

## Usage

Full pipeline:
```
/doc-quality-check docs/api/
```

Skip phases:
```
/doc-quality-check docs/api/ --skip-accuracy
/doc-quality-check docs/api/ --audit-only
```

Single phase:
```
/doc-quality-check docs/api/ --accuracy-only
```

---

## Workflow


### Step 1: Parse Arguments and Validate Flags

**Extract from arguments string:**
- `docs_path` - First non-flag argument
- `skip_accuracy` - Boolean, `--skip-accuracy` present
- `skip_quality` - Boolean, `--skip-quality` present
- `audit_only` - Boolean, `--audit-only` present
- `accuracy_only` - Boolean, `--accuracy-only` present
- `quality_only` - Boolean, `--quality-only` present

**Validate flags:**

1. Check for invalid combinations:
   - If `skip_accuracy` AND `skip_quality`: Error "Cannot skip both audit phases. Nothing to audit."
   - If `audit_only` AND any `*_only` flag: Error "Cannot combine --audit-only with --accuracy-only or --quality-only"

2. Determine which phases to run:
   - If `accuracy_only`: Run only Phase 1
   - If `quality_only`: Run only Phase 2
   - If `audit_only`: Run Phase 1 + Phase 2, skip Phase 3
   - If `skip_accuracy`: Run Phase 2 + Phase 3
   - If `skip_quality`: Run Phase 1 + Phase 3
   - Default (no flags): Run all three phases

3. If `docs_path` not provided: Error "Please provide a path to documentation files"


### Step 2: Generate Timestamp and Project Name

**Capture timestamp** using Bash:

```bash
date +"%Y%m%d-%H%M"
```

Store result as `timestamp` (e.g., "20260615-1430")

**Derive project name from docs_path:**

1. Remove trailing slashes: `docs/api/` → `docs/api`
2. Take last path component: `docs/api` → `api`
3. Clean up: lowercase, replace spaces/special chars with hyphens
4. Store as `project_name`

Example: `docs/api/` → project name is `api`

**Build report filenames:**
- `accuracy_report_file` = `{project_name}-accuracy-audit-{timestamp}.md`
- `quality_report_file` = `{project_name}-quality-audit-{timestamp}.md`

