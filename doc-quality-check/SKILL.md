---
skillType: agent
agent: composer
---
# doc-quality-check

Run doc-quality-audit and doc-quality-revise in sequence, with optional commit.

## Description

Convenience skill that orchestrates a complete documentation quality check:

1. Run doc-quality-audit to generate a quality report
2. Run doc-quality-revise to apply corrections from the report
3. Optionally commit the changes with a structured message

Accepts all flags from both underlying skills and coordinates their execution.

## Usage

```bash
/doc-quality-check [files...] [--auto] [--commit] [--branch name]
```

### Arguments

- `files...` - One or more documentation files to check (passed to both skills)
- `--auto` - Enable auto-revise mode in doc-quality-revise (optional)
- `--commit` - Commit changes after revisions are applied (optional)
- `--branch name` - Create/use git branch for changes (optional)

### Examples

```bash
# Check and revise single file interactively
/doc-quality-check README.md

# Auto-revise multiple files
/doc-quality-check README.md CONTRIBUTING.md --auto

# Auto-revise and commit
/doc-quality-check docs/*.md --auto --commit

# Full workflow with branch
/doc-quality-check README.md --auto --commit --branch docs/quality-improvements
```

## Workflow

1. Parse arguments and validate flags
2. Extract file paths and flags for each skill
3. Run doc-quality-audit with file paths
4. Run doc-quality-revise with audit report and flags
5. If --commit flag present, commit changes with structured message

```bash
#!/usr/bin/env bash

# Parse arguments
files=()
auto_flag=""
commit_flag=false
branch_flag=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --auto)
      auto_flag="--auto"
      shift
      ;;
    --commit)
      commit_flag=true
      shift
      ;;
    --branch)
      branch_flag="--branch $2"
      shift 2
      ;;
    *)
      files+=("$1")
      shift
      ;;
  esac
done

# Validate we have files
if [[ ${#files[@]} -eq 0 ]]; then
  echo "Error: No files specified"
  exit 1
fi
```

```bash
# Generate timestamp and project name for report identification
timestamp=$(date +"%Y%m%d_%H%M%S")
project_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
```

```bash
# Step 1: Run audit
echo "Running doc-quality-audit on ${#files[@]} file(s)..."
audit_cmd="/doc-quality-audit ${files[*]}"
eval "$audit_cmd"

# Capture the audit report path from the audit skill's output
# The audit skill outputs: "Report saved to: /path/to/report.md"
audit_report=$(ls -t .claude/doc-quality-audit/*.md 2>/dev/null | head -n 1)

if [[ ! -f "$audit_report" ]]; then
  echo "Error: Audit report not found"
  exit 1
fi

echo "Audit complete. Report: $audit_report"
```

```bash
# Step 2: Run revise
echo "Running doc-quality-revise..."
revise_cmd="/doc-quality-revise $audit_report ${files[*]} $auto_flag $branch_flag"
eval "$revise_cmd"

echo "Revisions complete."
```

```bash
# Step 3: Commit if requested
if [[ "$commit_flag" == true ]]; then
  echo "Committing changes..."
  
  # Build commit message
  commit_msg="docs: apply quality improvements from ${project_name} audit

- Automated revisions from doc-quality-audit report
- Report: $(basename "$audit_report")
- Files: ${files[*]}
- Timestamp: $timestamp"

  git add "${files[@]}"
  git commit -m "$commit_msg"
  
  echo "Changes committed."
fi
```

```bash
echo "doc-quality-check complete."
```
