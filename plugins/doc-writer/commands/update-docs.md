---
name: update-docs
description: Inspect a pull request's code changes and update the relevant documentation inside the repository. Works with GitHub and Azure DevOps. Usage: /update-docs [PR number or branch name]
argument-hint: [pr-number | branch-name]
---

Inspect the pull request changes and update the repository documentation for $ARGUMENTS.

## What This Does

This command invokes the **orchestrator** agent which:

1. Fetches the PR diff, commit log, and changed file list against the base branch
2. Identifies every modified source file in the PR
3. Scans `Docs/`, `docs/`, `README*.md`, and inline doc comments to find related documentation
4. Analyzes what changed (new APIs, renamed symbols, removed features, behavioral changes, config option changes)
5. Rewrites or extends the relevant documentation sections to reflect the code changes
6. Commits the documentation updates — directly to the PR branch (pre-merge) or as a follow-up PR (post-merge)

Activation is also label-driven: applying the `ai-dlc/pr/update-docs` label to any PR triggers this automatically.

## How to Use

```
/update-docs              # Update docs for current branch vs main
/update-docs 123          # Update docs for PR #123 (GitHub) or PR ID 123 (Azure DevOps)
/update-docs feature/foo  # Update docs for branch feature/foo vs main
```

## Platform Support

The plugin auto-detects the hosting platform from your git remote URL:

| Remote URL contains | Platform | How changes are committed |
|---|---|---|
| `github.com` | GitHub | Committed to PR branch via git; summary posted via `gh` |
| `dev.azure.com` / `visualstudio.com` | Azure DevOps | Committed to PR branch via git; summary posted via REST API |
| Anything else | Generic | Written to `doc-update-report.md` with diff ready to apply |

## Execution Modes

| Mode | When | What happens |
|---|---|---|
| **Pre-merge** | PR is still open | Documentation changes are committed directly to the PR branch |
| **Post-merge** | Branch has been merged | A follow-up PR is opened targeting the base branch |

## Documentation Scope

The plugin scans and updates:
- `Docs/` and `docs/` directories (all `.md` files)
- `README*.md` files at any directory level
- Inline doc comments adjacent to changed code (JSDoc, Python docstrings, Go doc comments, XML doc comments)

## Prerequisites

- Must be run inside a git repository
- The current branch must have at least one commit ahead of the base branch
- **GitHub**: `gh` CLI installed and authenticated, or `GITHUB_TOKEN` set (see `docs/platform-setup.md`)
- **Azure DevOps**: `AZURE_DEVOPS_TOKEN` environment variable set (see `docs/platform-setup.md`)
- **Committing**: `GIT_TOKEN` (GitHub) or `AZURE_DEVOPS_TOKEN` (Azure DevOps) must be set for `git push`

---

Starting documentation update now...
