# Examples

### Example 1: Full Pipeline

User runs:
```
/doc-quality-check docs/api/
```

Orchestrator executes:
1. Phase 1: Accuracy audit -> `api-accuracy-audit-20260616-1430.md`
2. Phase 2: Quality audit -> `api-quality-audit-20260616-1430.md`
3. Phase 3: Apply revisions using both reports

Output:
```
Running documentation quality check on docs/api/

Phase 1/3: Accuracy audit
COMPLETE Accuracy audit complete -> api-accuracy-audit-20260616-1430.md

Phase 2/3: Quality audit
COMPLETE Quality audit complete -> api-quality-audit-20260616-1430.md

Phase 3/3: Apply revisions
COMPLETE Revisions complete

Pipeline complete.

Reports generated:
- api-accuracy-audit-20260616-1430.md
- api-quality-audit-20260616-1430.md

Phases completed: 3/3
All phases finished successfully.
```


### Example 2: Audit Only (No Revisions)

User runs:
```
/doc-quality-check docs/api/ --audit-only
```

Orchestrator executes:
1. Phase 1: Accuracy audit -> `api-accuracy-audit-20260616-1432.md`
2. Phase 2: Quality audit -> `api-quality-audit-20260616-1432.md`
3. Phase 3: SKIPPED (--audit-only flag)

Output:
```
Running documentation quality check on docs/api/

Phase 1/2: Accuracy audit
COMPLETE Accuracy audit complete -> api-accuracy-audit-20260616-1432.md

Phase 2/2: Quality audit
COMPLETE Quality audit complete -> api-quality-audit-20260616-1432.md

Skipping Phase 3: Apply revisions (--audit-only)

Pipeline complete.

Reports generated:
- api-accuracy-audit-20260616-1432.md
- api-quality-audit-20260616-1432.md

Phases completed: 2/2
All phases finished successfully.
```


### Example 3: Skip Accuracy, Focus on Style

User runs:
```
/doc-quality-check docs/terraform-provider/ --skip-accuracy
```

Orchestrator executes:
1. Phase 1: SKIPPED (--skip-accuracy flag)
2. Phase 2: Quality audit -> `terraform-provider-quality-audit-20260616-1435.md`
3. Phase 3: Apply revisions using quality report only

Output:
```
Running documentation quality check on docs/terraform-provider/

Skipping Phase 1: Accuracy audit (--skip-accuracy)

Phase 2/2: Quality audit
COMPLETE Quality audit complete -> terraform-provider-quality-audit-20260616-1435.md

Phase 2/2: Apply revisions
COMPLETE Revisions complete

Pipeline complete.

Reports generated:
- terraform-provider-quality-audit-20260616-1435.md

Phases completed: 2/2
All phases finished successfully.
```


### Example 4: Quality Audit Only

User runs:
```
/doc-quality-check docs/cli-tool/ --quality-only
```

Orchestrator executes:
1. Phase 1: SKIPPED (--quality-only flag)
2. Phase 2: Quality audit -> `cli-tool-quality-audit-20260616-1440.md`
3. Phase 3: SKIPPED (--quality-only flag)

Output:
```
Running documentation quality check on docs/cli-tool/

Skipping Phase 1: Accuracy audit (--quality-only)

Phase 2/1: Quality audit
COMPLETE Quality audit complete -> cli-tool-quality-audit-20260616-1440.md

Skipping Phase 3: Apply revisions (--quality-only)

Pipeline complete.

Reports generated:
- cli-tool-quality-audit-20260616-1440.md

Phases completed: 1/1
All phases finished successfully.
```
