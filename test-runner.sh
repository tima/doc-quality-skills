#!/bin/bash
# test-runner.sh - Run all skill evals for doc-quality-skills

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXIT_CODE=0

echo "=== Doc Quality Skills Test Runner ==="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

run_skill_evals() {
    local skill_name=$1
    local evals_file="${SCRIPT_DIR}/skills/${skill_name}/evals/evals.json"

    if [ ! -f "$evals_file" ]; then
        echo -e "${YELLOW}SKIP${NC} ${skill_name}: No evals file found"
        return 0
    fi

    echo "Running ${skill_name} evals..."

    # Count total evals
    local total=$(jq '.evals | length' "$evals_file")
    echo "  Found $total test scenarios"

    # Parse and display each eval
    local i=0
    while [ $i -lt $total ]; do
        local eval_id=$(jq -r ".evals[$i].id" "$evals_file")
        local eval_type=$(jq -r ".evals[$i].type" "$evals_file")
        local eval_prompt=$(jq -r ".evals[$i].prompt" "$evals_file")

        echo ""
        echo "  Scenario $((i+1))/$total (ID: $eval_id, Type: $eval_type)"
        echo "  Prompt: ${eval_prompt:0:80}..."

        # Note: Actual test execution would invoke the skill here
        # For now, just validate the eval structure
        if [ -z "$eval_id" ] || [ -z "$eval_type" ] || [ -z "$eval_prompt" ]; then
            echo -e "  ${RED}FAIL${NC} Invalid eval structure"
            EXIT_CODE=1
        else
            echo -e "  ${GREEN}PASS${NC} Eval structure valid"
        fi

        i=$((i+1))
    done

    echo ""
}

# Check for jq dependency
if ! command -v jq &> /dev/null; then
    echo -e "${RED}ERROR${NC}: jq is required but not installed"
    echo "Install with: brew install jq (macOS) or apt install jq (Linux)"
    exit 1
fi

# Run evals for each skill
echo "Checking skill evals..."
echo ""

run_skill_evals "doc-accuracy-audit"
run_skill_evals "doc-quality-audit"
run_skill_evals "doc-quality-revise"

# doc-quality-check is an orchestrator with no evals
echo "Skipping doc-quality-check (orchestrator skill, no evals)"
echo ""

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}=== All eval structures valid ===${NC}"
else
    echo -e "${RED}=== Some evals failed validation ===${NC}"
fi

exit $EXIT_CODE
