# doc-quality-check Orchestration Skill Design

## Overview

A thin orchestrator skill that runs the complete documentation quality check pipeline by invoking the three existing skills in sequence. Lives in the doc-quality-skills family repository as a fourth skill.

## Goals

- Single-command execution of the complete audit → revise pipeline
- Reuse existing skills without duplication
- Handle report passing between phases
- Support optional phase skipping for partial runs
- Provide clear status reporting at each stage

## Architecture

**Location:** `doc-quality-skills/doc-quality-check/SKILL.md`

**Type:** Orchestrator skill - delegates to other skills via Skill tool invocations

**Dependencies:**
- doc-accuracy-audit (optional, can skip)
- doc-quality-audit (required unless --accuracy-only)
- doc-quality-revise (optional, can skip)

## Invocation Flow

```
User: /doc-quality-check path/to/docs [flags]
  ↓
Parse arguments and flags
  ↓
Phase 1: Invoke /doc-accuracy-audit path/to/docs
  ↓
Check for accuracy-audit-report.md
  - Present: Continue
  - Missing: Error recovery (ask user to retry or skip)
  ↓
Phase 2: Invoke /doc-quality-audit path/to/docs
  ↓
Check for quality-audit-report.md
  - Present: Continue
  - Missing: Error recovery
  ↓
Phase 3: Invoke /doc-quality-revise
  - Auto-discovers both report files
  - Runs interactive workflow
  ↓
Report completion status
```

## Supported Flags

- `--skip-accuracy` - Skip doc-accuracy-audit phase, run quality → revise only
- `--skip-quality` - Skip doc-quality-audit phase, run accuracy → revise only
- `--audit-only` - Run accuracy and quality audits, skip revise phase
- `--accuracy-only` - Run only accuracy audit
- `--quality-only` - Run only quality audit

Flag validation: `--skip-accuracy` + `--skip-quality` = error (nothing to audit)

## Error Handling

**Missing report files:**
1. Notify user which phase failed
2. Offer options:
   - Retry the failed phase
   - Skip that phase and continue
   - Abort pipeline

**Skill invocation failures:**
1. Catch and report which skill failed
2. Preserve any partial results (reports from earlier phases)
3. Offer retry or abort

**User cancellation:**
- Respect cancellation at any phase
- Preserve completed work
- Report what was finished vs what was skipped

## Report File Discovery

Pipeline expects reports in current working directory:
- `accuracy-audit-report.md` (from phase 1)
- `quality-audit-report.md` (from phase 2)

doc-quality-revise already handles finding these, no extra work needed.

## User Experience

**Invocation:**
```
/doc-quality-check docs/api/
```

**Output during execution:**
```
Running documentation quality check on docs/api/

Phase 1/3: Accuracy audit
[doc-accuracy-audit skill executes]
✓ Accuracy audit complete → accuracy-audit-report.md

Phase 2/3: Quality audit  
[doc-quality-audit skill executes]
✓ Quality audit complete → quality-audit-report.md

Phase 3/3: Apply revisions
[doc-quality-revise skill executes interactively]
✓ Revisions complete

Pipeline complete. All phases finished successfully.
```

**With flags:**
```
/doc-quality-check docs/api/ --skip-accuracy --audit-only

Running documentation quality check on docs/api/

Skipping Phase 1: Accuracy audit (--skip-accuracy)

Phase 1/1: Quality audit
[doc-quality-audit skill executes]
✓ Quality audit complete → quality-audit-report.md

Skipping Phase 2: Apply revisions (--audit-only)

Pipeline complete.
```

## Installation

After implementation:

```bash
ln -sf ~/projects/doc-quality-skills/doc-quality-check ~/.claude/skills/doc-quality-check
```

Becomes available as `/doc-quality-check`.

## Testing

**Test scenarios:**
1. Full pipeline (no flags) on test-docs/
2. --skip-accuracy flag
3. --skip-quality flag  
4. --audit-only flag
5. Each single-phase flag (--accuracy-only, --quality-only)
6. Error recovery when report file missing
7. User cancellation mid-pipeline

## Non-Goals

- Parallel execution of independent phases (accuracy and quality could theoretically run parallel, but adds complexity for minimal gain)
- Custom report file paths (skills use standard paths)
- Report format conversion (each skill owns its format)
- Automatic git commit of reports (user controls when to commit)

## Future Enhancements

Potential additions outside initial scope:
- Summary report combining findings from all phases
- Pipeline configuration file for project-specific defaults
- Watch mode (re-run on file changes)
- Batch mode (run on multiple doc sets)

## Open Questions

None - design is straightforward delegation with error handling.
