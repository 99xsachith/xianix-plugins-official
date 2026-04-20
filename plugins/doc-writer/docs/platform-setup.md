# Platform Setup

This guide explains how to configure credentials and permissions for the doc-writer plugin on each supported platform.

---

## GitHub

### Required Token Scopes

| Permission | Level | Purpose |
|---|---|---|
| Contents | Read & Write | Read source files; commit documentation updates to the branch |
| Metadata | Read | Repository information (name, default branch) |
| Pull requests | Read & Write | Read PR diffs; post summary comments; open follow-up PRs |

### Option A: GitHub CLI (Recommended for local use)

Install the GitHub CLI: https://cli.github.com

Authenticate:

```bash
gh auth login
```

The plugin uses `gh` for posting comments and opening follow-up PRs. For `git push`, the CLI's stored credential is used automatically.

### Option B: Personal Access Token (CI / non-interactive)

Create a fine-grained PAT at **GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens** with the scopes above.

Export the token before running:

```bash
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

Or pass it inline:

```bash
GITHUB_TOKEN=ghp_xxxxxxxxxxxx claude /update-docs
```

The plugin injects this token for `git push` via `GIT_CONFIG_*` environment variables — your global git config is never modified.

### Trigger via Label

The plugin activates automatically when the `ai-dlc/pr/update-docs` label is applied to a pull request. Configure your Xianix agent rule with:

| Scenario | Condition |
|---|---|
| Label applied | `action==labeled&&label.name=='ai-dlc/pr/update-docs'` |
| PR opened with label | `action==opened&&pull_request.labels.*.name=='ai-dlc/pr/update-docs'` |
| New commits on labeled PR | `action==synchronize&&pull_request.labels.*.name=='ai-dlc/pr/update-docs'` |

Input mappings: `pr-number` from `pull_request.number`, `repository-url` from `repository.html_url`, `pr-head-branch` from `pull_request.head.ref`.

---

## Azure DevOps

### Required PAT Scopes

Create a Personal Access Token at **Azure DevOps → User settings → Personal access tokens** with:

| Scope | Permission |
|---|---|
| Code | Read & Write |
| Pull Request Threads | Read & Write |

### Export the Token

```bash
export AZURE_DEVOPS_TOKEN=<your-pat>
```

Or pass it inline:

```bash
AZURE_DEVOPS_TOKEN=<your-pat> claude /update-docs
```

The plugin uses this token for:
- `git push` (injected via `GIT_CONFIG_*`, not written to disk)
- REST API calls to post comments and open follow-up PRs

### Trigger via Tag

The plugin activates when the `ai-dlc/pr/update-docs` tag appears on a pull request. Configure your Xianix agent rule with:

| Scenario | Webhook event | Condition |
|---|---|---|
| Tag applied | `git.pullrequest.updated` | Message contains "tagged the pull request" with `ai-dlc/pr/update-docs` label present |
| PR created with tag | `git.pullrequest.created` | `ai-dlc/pr/update-docs` label present in resource |
| Source branch updated | `git.pullrequest.updated` | Message contains "updated the source branch" with label present |

Input mappings: `pr-number` from `resource.pullRequestId`, `repository-url` from `resource.repository.remoteUrl`, `pr-head-branch` from `resource.sourceRefName`.

---

## Generic / Unknown Platform

No platform-specific credentials required. The plugin commits documentation changes locally and writes `doc-update-report.md` describing what was updated. Push manually if needed.
