# ben-everly Claude Code Plugins

A marketplace of Claude Code plugins — skills, commands, and agents for development workflows.

## Installation

Add this marketplace to Claude Code:

```
/plugin marketplace add ben-everly/claude-plugins
```

## Installing Plugins

Browse available plugins:

```
/plugin search @ben-everly
```

Install a plugin:

```
/plugin install <plugin-name>@ben-everly
```

## Available Plugins

| Plugin                   | Description                                                                                       | Install                                           |
| ------------------------ | ------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| **development-workflow** | A structured development workflow covering planning, design, implementation, review, and delivery | `/plugin install development-workflow@ben-everly` |
| **atlassian-tools**      | Atlassian CLI skills — Jira queries, ticket management, sprints, boards, and workflow operations  | `/plugin install atlassian-tools@ben-everly`      |
| **intelephense**         | PHP language server (Intelephense) with optimized file exclusions to reduce RAM usage             | `/plugin install intelephense@ben-everly`         |

## Creating a Plugin

Each plugin lives in its own directory at the repo root with the following structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json         # Plugin metadata (name, version, description, author)
├── skills/                 # Skills (SKILL.md files)
│   └── skill-name/
│       └── SKILL.md
├── commands/               # Slash commands (.md files)
│   └── command-name.md
├── agents/                 # Agents (.md files)
│   └── agent-name.md
└── .mcp.json               # MCP server config (optional)
```

After adding a plugin directory, register it in `.claude-plugin/marketplace.json` under the `plugins` array.

## License

MIT
