# Requirement Analyst Plugin

> Requirement grooming for backlog items. Analyzes **user intent**, **domain knowledge**, **competitive context**, and **workflow** — then posts a well-understood, groomed requirement to GitHub or Azure DevOps. Focused entirely on user experience; technical design is a separate activity.

## What This Plugin Does

The **req-analyst** plugin grooms requirements by understanding *why* this exists, *what* success means to users, and *how* it fits the user journey. It scans the repo for existing documentation (README, specs, architecture docs) to build product context, then runs five analysts in two phases — each analyst receives both the issue content and the repo documentation summary. Results are posted as separate comments, preserving the original description.

**Phase 1 — Context Gathering (parallel):**

| Agent | Focus |
| ----- | ----- |
| **intent-analyst** | Intent decomposition, user context, workflow, decision points |
| **domain-analyst** | Domain knowledge, data meaning, business rules, competitive insights |
| **journey-mapper** | End-to-end user journey across related items, journey gaps, moments that matter |
| **persona-analyst** | User types, needs mapping, persona conflicts, persona-specific edge cases |

**Phase 2 — Gap & Risk Analysis:**

| Agent | Focus |
| ----- | ----- |
| **gap-risk-analyst** | Gaps, risks, value/priority, dependencies |

### Output

- **Verdict:** `GROOMED` | `NEEDS CLARIFICATION` | `NEEDS DECOMPOSITION`
- **Summary** with intent decomposition (stated need → underlying intent → success definition)
- **User Context & Workflow** — who, when/where, constraints, before/during/after
- **Domain Context** — data meaning, business rules, competitive insights
- **Gaps & Unresolved Questions**
- **Risks, Dependencies & Assumptions**
- Automatic posting to the backlog platform

---

## Local Testing with Claude Code

Run the plugin interactively in your project using Claude Code (Claude CLI).

### Prerequisites

- [Claude Code](https://docs.anthropic.com/claude-code) installed (`claude` CLI)
- **GitHub**: `gh` CLI installed and authenticated (`gh auth login`) — or `GITHUB_TOKEN` env var
- **Azure DevOps**: `AZURE_DEVOPS_TOKEN` PAT with `Work Items (Read & Write)` scope
- Working directory: your project repo or a clone of the target repo

### 1. Point Claude Code at the plugin

Launch with the plugin directory:

```bash
claude --plugin-dir /path/to/xianix-team/plugins/req-analyst
```

> Replace `/path/to/xianix-team` with the actual path — e.g. if you cloned xianix-team to `~/xianix-team`, use `~/xianix-team/plugins/req-analyst`.

### 2. Configure credentials

**GitHub:**

```bash
gh auth login
# or
export GITHUB_TOKEN=ghp_your_token_here
```

**Azure DevOps:**

```bash
export AZURE_DEVOPS_TOKEN=<your-pat>
```

See [docs/platform-config.md](docs/platform-config.md) for full details.

### 3. Run from your project repo

`cd` into your **project repository** (the one whose backlog you want to elaborate), then start Claude:

```bash
cd /path/to/your-project
claude --plugin-dir /path/to/xianix-team/plugins/req-analyst
```

### 4. Invoke the command

In the Claude chat:

```text
/requirement-analysis 42
```

Elaborate issue #42. The agent will fetch the issue, scan repo documentation for context, run all five analysts, and post each analysis aspect as a separate comment on the issue — the original issue body is never modified.

### Optional: Test without posting

To inspect the output without posting to GitHub, you can ask Claude to run the analysis and show you the elaboration before posting — the command is designed to post automatically, but you can experiment with custom prompts in a separate chat to see the structure.

---

## Central Run with `run-requirement-analysis.sh`

The script `scripts/run-requirement-analysis.sh` is designed for **server/CI** runs: it clones the target repo into an isolated worktree, sets up credentials, runs the analysis, and cleans up. Use it when requirements analysis is triggered centrally (e.g. by a webhook or scheduler).

### Prerequisites (central run)

- `git`, `claude` CLI, and `gh` CLI installed
- Environment variables set for the target platform (see below)

### Required Environment Variables

#### GitHub

| Variable | Description |
| -------- | ----------- |
| `PLATFORM` | `github` |
| `REPO_URL` | Full HTTPS clone URL, e.g. `https://github.com/org/repo.git` |
| `ISSUE_NUMBER` | GitHub issue number to elaborate |
| `GITHUB_TOKEN` | PAT with `repo` scope (used for `gh` CLI and git clone) |

#### Azure DevOps

| Variable | Description |
| -------- | ----------- |
| `PLATFORM` | `azure-devops` |
| `REPO_URL` | Full HTTPS clone URL, e.g. `https://dev.azure.com/org/project/_git/repo` |
| `ISSUE_NUMBER` | Work Item ID to elaborate |
| `AZURE_DEVOPS_TOKEN` | PAT with Work Items (Read & Write) scopes |
| `GIT_TOKEN` | PAT for git clone (often same as `AZURE_DEVOPS_TOKEN`) |

### Usage

Run from the **xianix-team** repo root:

```bash
# GitHub
PLATFORM=github \
REPO_URL=https://github.com/org/repo.git \
ISSUE_NUMBER=42 \
GITHUB_TOKEN=ghp_xxx \
./scripts/run-requirement-analysis.sh
```

```bash
# Azure DevOps
PLATFORM=azure-devops \
REPO_URL=https://dev.azure.com/org/project/_git/repo \
ISSUE_NUMBER=123 \
AZURE_DEVOPS_TOKEN=pat_xxx \
GIT_TOKEN=pat_xxx \
./scripts/run-requirement-analysis.sh
```

### What the Script Does

1. Creates or updates a shared **bare clone** of the target repo (`REPO_CACHE_DIR`)
2. Creates an isolated **per-run worktree** (`WORKDIR`)
3. Sets up credentials (env vars for `gh` CLI and `curl`)
4. Clones/updates **xianix-team** and loads the req-analyst plugin
5. Runs `claude -p "/analyze-requirement <ISSUE_NUMBER>"` inside the worktree
6. Removes the worktree after the run (unless `KEEP_WORKDIR=1`)

### Optional Variables

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `XIANIX_REPO` | `https://github.com/99x/xianix-team.git` | Override plugin source repo |
| `XIANIX_CACHE_DIR` | `/tmp/requirement-analysis-cache/xianix-team` | Path for cloned xianix-team |
| `XIANIX_USE_LOCAL` | `0` | Set to `1` to use XIANIX_CACHE_DIR as-is (no clone/pull) — for local dev |
| `REPO_CACHE_DIR` | `/tmp/requirement-analysis-cache/<repo-slug>` | Path for bare clone |
| `WORKDIR` | `/tmp/requirement-analysis-<ISSUE>-<timestamp>` | Per-run worktree |
| `KEEP_WORKDIR` | `0` | Set to `1` to preserve worktree after run (debugging) |

---

## Documentation

| Document | Description |
| -------- | ----------- |
| [docs/platform-config.md](docs/platform-config.md) | Platform configuration — GitHub CLI, Azure DevOps PAT |
| [docs/backlog-setup.md](docs/backlog-setup.md) | Backlog structure, labels/tags, and workflow for both platforms |
| [providers/github.md](providers/github.md) | GitHub-specific fetching and posting |
| [providers/azure-devops.md](providers/azure-devops.md) | Azure DevOps-specific fetching and posting |
| [providers/generic.md](providers/generic.md) | Fallback — file-based output |
