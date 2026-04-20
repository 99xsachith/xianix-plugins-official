# Xianix Plugins Official

A curated directory of high-quality plugins for [Xianix the-agent](https://opensource.99x.io/xianix-team/) — AI-powered AI-DLC automation tools.

> **Important:** Make sure you trust a plugin before installing, updating, or using it. 99x does not control what MCP servers, files, or other software are included in community plugins and cannot verify that they will work as intended or that they won't change. See each plugin's homepage for more information.

---

## Structure

```
/plugins - Official plugins developed and maintained by 99x / Xianix Team
```

---

## Available Plugins

| Plugin | Version | Description | Category |
|--------|---------|-------------|----------|
| [pr-reviewer](./plugins/pr-reviewer) | 1.2.0 | Comprehensive PR review with specialized agents for code quality, security, test coverage, and performance analysis. Works with GitHub, Azure DevOps, Bitbucket, and any git repository. | code-review |
| [req-analyst](./plugins/req-analyst) | 1.1.0 | Requirement grooming plugin focused on user experience. Analyzes user intent, domain knowledge, competitive context, and workflow to produce well-understood, groomed requirements. | requirements |
| [doc-writer](./plugins/doc-writer) | 1.0.0 | Keeps documentation synchronized with code changes. Inspects PR diffs, maps modified source files to `Docs/`, `docs/`, and `README` files, then generates and commits the necessary updates. Supports GitHub and Azure DevOps with label-driven activation via `ai-dlc/pr/update-docs`. | documentation |

---

## Adding This Marketplace

Add this marketplace to Xianix the-agent using the `plugin marketplace add` command. It accepts a GitHub owner/repo shorthand, git URL, remote URL to a `marketplace.json` file, or a local directory path.

```
claude plugin marketplace add <source> [options]
```

**From GitHub (recommended):**

```
claude plugin marketplace add xianix-team/xianix-plugins-official
```

**Pin to a specific branch or tag** by appending `@ref` to the GitHub shorthand:

```
claude plugin marketplace add xianix-team/xianix-plugins-official@main
```

**From a git URL** (pin to a branch or tag with `#ref`):

```
claude plugin marketplace add https://github.com/xianix-team/xianix-plugins-official.git#main
```

**From a remote `marketplace.json` URL:**

```
claude plugin marketplace add https://raw.githubusercontent.com/xianix-team/xianix-plugins-official/main/.claude-plugin/marketplace.json
```

**From a local directory path:**

```
claude plugin marketplace add ./path/to/xianix-plugins-official
```

---

## Installation

Once the marketplace is added, plugins can be installed via Xianix the-agent's plugin system.

To install, run:

```
/plugin install {plugin-name}@xianix-plugins-official
```

Or browse for the plugin via `/plugin > Discover`.

---

## Contributing

### Official Plugins

Official plugins are developed by the 99x / Xianix team. See [`/plugins/pr-reviewer`](./plugins/pr-reviewer) for a reference implementation.

### Third-Party Plugins

Third-party partners can submit plugins for inclusion in the marketplace. Submitted plugins must meet quality and security standards for approval. To submit a new plugin, open an issue or pull request against this repository.

---

## Plugin Structure

Each plugin follows a standard structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata (required)
├── .mcp.json            # MCP server configuration (optional)
├── commands/            # Slash commands (optional)
├── agents/              # Agent definitions (optional)
├── skills/              # Skill definitions (optional)
├── hooks/               # Lifecycle hooks (optional)
├── providers/           # Provider-specific configuration (optional)
├── styles/              # Output style definitions (optional)
└── README.md            # Documentation
```

---

## License

Please see each linked plugin for the relevant `LICENSE` file.

---

## Documentation

For more information on developing Xianix plugins, visit [opensource.99x.io/xianix-team](https://opensource.99x.io/xianix-team/).
