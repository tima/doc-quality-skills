# Error Handling

### Missing Report File After Audit Phase

If an audit phase completes but the expected report file is missing:

```
Error: Accuracy audit failed - report file not found: api-accuracy-audit-20260616-1430.md

Options:
A) Retry Phase 1
B) Skip Phase 1 and continue
C) Abort pipeline

Choose an option (A/B/C):
```

**Handler:**
- Option A: Re-invoke the failed skill with same arguments
- Option B: Mark phase as skipped, continue to next phase
- Option C: Stop pipeline immediately, preserve any completed reports


### Invalid Flag Combinations

**Error:** Cannot skip both audit phases
```
/doc-quality-check docs/api/ --skip-accuracy --skip-quality
```

Output:
```
Error: Cannot skip both audit phases. Nothing to audit.
```

**Error:** Cannot combine audit-only with phase-specific flags
```
/doc-quality-check docs/api/ --audit-only --accuracy-only
```

Output:
```
Error: Cannot combine --audit-only with --accuracy-only or --quality-only
```


### Missing Documentation Path

User runs:
```
/doc-quality-check
```

Output:
```
Error: Please provide a path to documentation files

Usage: /doc-quality-check <path> [flags]
```


### Skill Invocation Failure

If a delegated skill (`/doc-accuracy-audit`, `/doc-quality-audit`, or `/doc-quality-revise`) fails during execution:

1. Preserve completed work (audit reports already generated)
2. Show what completed successfully
3. Offer recovery options if applicable
4. Report final status showing partial completion

Example output:
```
Phase 2/3: Quality audit
Error: Quality audit skill failed

Pipeline stopped after Phase 1.

Reports generated:
- api-accuracy-audit-20260616-1430.md

Phases completed: 1/3
Pipeline incomplete due to skill failure.
```


### User Cancels During Interactive Revision

If user aborts during Phase 3 (revision phase):

1. Preserve audit reports (Phases 1 and 2 output)
2. Document partial completion
3. User can apply revisions later by invoking doc-quality-revise directly with saved reports

Output:
```
Phase 3/3: Apply revisions
User cancelled revision workflow.

Pipeline stopped.

Reports generated:
- api-accuracy-audit-20260616-1430.md
- api-quality-audit-20260616-1430.md

Phases completed: 2/3
Audit reports preserved. You can apply revisions later using:
  /doc-quality-revise --accuracy-report api-accuracy-audit-20260616-1430.md --quality-report api-quality-audit-20260616-1430.md
```
