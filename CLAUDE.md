# Claude Code Marketplace Repository

This repo is a Claude Code plugin marketplace. It follows the marketplace spec used by Claude Code's built-in plugin system.

## Repository Structure

```
.claude-plugin/
    marketplace.json          # Marketplace registry — lists all plugins
<plugin-name>/
    .claude-plugin/
        plugin.json             # Plugin metadata
    skills/<skill-name>/
        SKILL.md                # Skill definitions
    commands/
        <command-name>.md       # Slash commands
    agents/
        <agent-name>.md         # Agent definitions
    .mcp.json                 # MCP server config (if needed)
```

## Key Rules

- **marketplace.json** is the source of truth. Every plugin must be registered in `.claude-plugin/marketplace.json` under the `plugins` array.
- **Plugin directories** live at the repo root (not nested in subdirectories).
- **plugin.json** in each plugin's `.claude-plugin/` directory must include: `name`, `version`, `description`, and `author`.
- **Source paths** in marketplace.json are relative, e.g. `"source": "./<plugin-name>"`.

## Adding a New Plugin

1. Create a directory at the repo root named after the plugin.
2. Add `.claude-plugin/plugin.json` with metadata.
3. Add skills, commands, agents, or MCP config as needed.
4. Register the plugin in `.claude-plugin/marketplace.json`:

    ```json
    {
        "name": "plugin-name",
        "source": "./plugin-name",
        "description": "What the plugin does",
        "version": "0.0.0",
        "author": {
            "name": "Ben Everly"
        },
        "category": "development"
    }
    ```

5. Update the "Available Plugins" section in README.md.

## Releases

Plugins are released automatically by release-it, which derives each plugin's version bump from the Conventional Commits made since its last tag. You should NEVER manually edit plugin versions except to set the initial version, which should always be `0.0.0`.

**Pull requests are squash-merged, so the PR title becomes the commit message release-it reads.** A non-conventional title (e.g. "Add new plugin") collapses to a typeless commit, so release-it falls back to a patch bump and any intended minor bump is lost. PR titles MUST follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` / `feat(scope):` — new capability → **minor**
- `fix:` — bug fix → **patch**
- `feat!:` or a `BREAKING CHANGE:` footer — breaking change → **major**
- `docs:`, `chore:`, `refactor:`, `ci:`, `test:`, `build:` — patch / no release as appropriate

## Categories

Use one of: `development`, `productivity`, `security`, `testing`, `learning`, `design`, `database`, `monitoring`, `deployment`.
