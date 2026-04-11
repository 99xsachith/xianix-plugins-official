# Platform Configuration

The `req-analyst` plugin supports **GitHub** and **Azure DevOps** as backlog sources, auto-detecting the platform from `git remote get-url origin`.

---

## GitHub

### Prerequisites

The `gh` CLI must be installed and authenticated.

**Install:**

```bash
# macOS
brew install gh

# Windows
winget install --id GitHub.cli

# Linux (Debian/Ubuntu)
sudo apt install gh
```

**Authenticate:**

```bash
gh auth login
```

Or set the token directly:

```bash
export GITHUB_TOKEN=ghp_your_actual_token_here
```

### Generating a GitHub Token

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)**
3. Select `repo` scope (required for issues)
4. Copy the token and export as `GITHUB_TOKEN` or use `gh auth login`

### Verification

```bash
gh auth status
```

You should see your account listed with the `repo` scope.

### What the plugin uses

| Command | Purpose |
|---|---|
| `gh issue view` | Fetch issue details (title, body, labels, comments) |
| `gh issue list` | Find related issues by milestone, label, or keyword |
| `gh issue comment` | Post each analysis aspect as a comment |
| `gh issue edit --add-label` | Apply verdict label |

---

## Azure DevOps

### Authentication

Azure DevOps uses a Personal Access Token (PAT) passed via the `AZURE_DEVOPS_TOKEN` environment variable. The plugin calls the REST API directly via `curl`.

```bash
export AZURE_DEVOPS_TOKEN=<your-pat>
```

### Generating an Azure DevOps PAT

1. Go to `https://dev.azure.com/<your-org>/_usersSettings/tokens`
2. Click **New Token**
3. Select scopes: `Work Items` → **Read & Write**
4. Copy the token and export as `AZURE_DEVOPS_TOKEN`

### What the plugin uses

| API | Purpose |
|---|---|
| `GET _apis/wit/workitems/{id}` | Fetch work item details (title, description, tags, comments) |
| `POST _apis/wit/wiql` | Query related work items in the same iteration |
| `POST _apis/wit/workitems/{id}/comments` | Post each analysis aspect as a comment |
| `PATCH _apis/wit/workitems/{id}` | Apply verdict tag |

See `providers/azure-devops.md` for full API details.

### Verification

```bash
curl -s -u ":${AZURE_DEVOPS_TOKEN}" \
  "https://dev.azure.com/<your-org>/<your-project>/_apis/wit/workitems?ids=1&api-version=7.1"
```

---

## Summary

| Platform | How items are fetched | How results are posted | Credentials |
|---|---|---|---|
| GitHub | `gh` CLI | `gh issue comment` | `GITHUB_TOKEN` or `gh auth login` |
| Azure DevOps | REST API (`curl`) | REST API (`curl`) | `AZURE_DEVOPS_TOKEN` env var |
| Generic | User-provided or file | Written to `requirement-elaboration-report.md` | — |
