---
name: update-docs
description: Inspect a PR's code changes and update all relevant documentation in the repository. Scans Docs/, docs/, README*.md, and inline doc comments. Commits changes directly to the PR branch (pre-merge) or opens a follow-up PR (post-merge). Invoke when source code changes require documentation to be kept in sync.
argument-hint: [pr-number | branch-name]
---

Inspect the pull request changes and update the repository documentation.

Invoke the **orchestrator** agent with the provided argument (PR number, branch name, or empty to default to the current branch vs main).

The orchestrator will:
1. Fetch the PR diff and changed file list
2. Identify modified source files with doc-impacting changes (new APIs, renamed symbols, removed features, behavioral changes, config option changes)
3. Map each changed file to its relevant documentation in `Docs/`, `docs/`, `README*.md`, and inline doc comments
4. Generate surgical updates to each affected documentation file
5. Commit the updates to the PR branch or open a follow-up PR if the branch has already been merged
6. Post a summary comment to the PR

This skill is triggered automatically when the `ai-dlc/pr/update-docs` label is applied to a PR, or can be invoked manually via `/update-docs`.
