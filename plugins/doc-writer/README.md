# doc-writer

An **official Xianix plugin** that keeps repository documentation synchronized with code changes. When a pull request modifies source code, the plugin inspects the diff, finds the relevant `Docs/`, `docs/`, `README*.md`, and inline doc comments, and generates surgical updates — then commits them directly to the PR branch or opens a follow-up PR if the branch has already been merged.

---

## What it does

```
/update-docs [PR number or branch name]
```

| Step | What happens |
|---|---|
| 1 | Fetches the PR diff, commit log, and changed file list against the base branch |
| 2 | Identifies every modified source file with doc-impacting changes |
| 3 | Maps each changed file to its relevant documentation assets |
| 4 | Analyzes what changed (new APIs, renames, removals, behavioral changes, config options) |
| 5 | Generates surgical updates to each affected documentation file |
| 6 | Commits the updates to the PR branch (pre-merge) or opens a follow-up PR (post-merge) |
| 7 | Posts a summary comment to the original PR |

---

## File structure

```
doc-writer/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── settings.json            # Default agent
├── agents/
│   └── orchestrator.md          # Main documentation update agent
├── commands/
│   └── update-docs.md           # Slash command: /update-docs [pr-number | branch]
├── docs/
│   └── platform-setup.md        # Credential and trigger setup for GitHub & Azure DevOps
├── hooks/
│   ├── hooks.json               # Hook registration
│   ├── validate-prerequisites.sh  # PreToolUse: validates git, gh, tokens
│   └── notify-commit.sh         # PostToolUse: confirmation message after push
├── providers/
│   ├── github.md                # GitHub-specific: comment posting, follow-up PRs
│   ├── azure-devops.md          # Azure DevOps-specific: REST API posting
│   └── generic.md               # Fallback: local report file
├── skills/
│   └── update-docs/
│       └── SKILL.md             # Skill exposing the same flow to agents
└── README.md                    # You are here
```

---

## How to use

### Manual invocation

```bash
/update-docs              # Current branch vs main
/update-docs 123          # PR #123 (GitHub) or PR ID 123 (Azure DevOps)
/update-docs feature/foo  # Branch feature/foo vs main
```

### Label-driven (automatic)

Apply the `ai-dlc/pr/update-docs` label (GitHub) or tag (Azure DevOps) to any pull request. The plugin activates on:
- Label/tag applied to an existing PR
- PR created with the label/tag already present
- New commits pushed to a labeled/tagged PR

See `docs/platform-setup.md` for Xianix agent rule configuration.

---

## Platform support

| Remote URL | Platform | How it posts |
|---|---|---|
| `github.com` | GitHub | `gh pr comment` / `gh pr create` |
| `dev.azure.com` / `visualstudio.com` | Azure DevOps | REST API (`curl`) |
| Anything else | Generic | `doc-update-report.md` written locally |

---

## Execution modes

| Mode | Condition | What happens |
|---|---|---|
| **Pre-merge** | PR branch is still open | Docs committed directly to the PR branch |
| **Post-merge** | Branch already merged into base | Follow-up PR opened targeting the base branch |

---

## Credentials

| Platform | Variable | Required for |
|---|---|---|
| GitHub | `GITHUB_TOKEN` or `gh auth login` | `git push`, `gh pr comment`, `gh pr create` |
| Azure DevOps | `AZURE_DEVOPS_TOKEN` | `git push`, REST API comments and PR creation |

See `docs/platform-setup.md` for full setup instructions.

---

## Documentation scope

The plugin scans and updates:
- `Docs/` and `docs/` directories (all `.md` files)
- `README*.md` files at any directory level
- Inline doc comments: JSDoc (`/** */`), Python docstrings, Go doc comments (`// FuncName ...`), C# XML doc comments (`/// <summary>`)

It detects:
- **New public APIs**: new exported functions, classes, interfaces, endpoints, CLI flags
- **Renamed symbols**: functions, classes, config keys, CLI commands
- **Removed or deprecated features**: deleted exports, `@deprecated` annotations
- **Behavioral changes**: altered return values, changed defaults, updated error conditions
- **Configuration changes**: new environment variables, changed config schema, new options

---

## Install

From the marketplace root:

```bash
claude plugin marketplace add ./
/plugin install doc-writer@xianix-plugins-official
```

---

## License

MIT
