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
     "version": "1.0.0",
     "author": {
       "name": "Ben Everly"
     },
     "category": "development"
   }
   ```
5. Update the "Available Plugins" section in README.md.

## Categories

Use one of: `development`, `productivity`, `security`, `testing`, `learning`, `design`, `database`, `monitoring`, `deployment`.
