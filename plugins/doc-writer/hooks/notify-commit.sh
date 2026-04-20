#!/usr/bin/env bash
# notify-commit.sh
# PostToolUse hook — runs after every Bash tool execution.
# If the command was a git commit or git push, outputs a confirmation message.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -o '"command":"[^"]*"' | head -1 | cut -d'"' -f4 2>/dev/null || echo "")

# Act on git commit
if echo "$COMMAND" | grep -qE "^git commit"; then
    COMMIT=$(git log -1 --oneline 2>/dev/null || echo "")
    echo "Documentation committed: ${COMMIT}"
    exit 0
fi

# Act on git push
if echo "$COMMAND" | grep -qE "^git push"; then
    REMOTE=$(git remote get-url origin 2>/dev/null || echo "unknown remote")
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown branch")
    COMMIT=$(git log -1 --oneline 2>/dev/null || echo "")

    echo "Documentation pushed — branch '${BRANCH}' pushed to ${REMOTE}"
    echo "Latest commit: ${COMMIT}"

    if echo "$REMOTE" | grep -q "github.com"; then
        echo "Next step: post the summary comment with gh (see providers/github.md)."
    elif echo "$REMOTE" | grep -qE "dev.azure.com|visualstudio.com"; then
        echo "Next step: post the summary comment via Azure DevOps REST API (see providers/azure-devops.md)."
    else
        echo "Next step: write the update report to doc-update-report.md (see providers/generic.md)."
    fi
fi
