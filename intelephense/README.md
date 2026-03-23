# Intelephense Plugin

PHP language server ([Intelephense](https://intelephense.com/)) for Claude Code with optimized file exclusions to reduce RAM usage. Replaces the official `php-lsp` plugin.

## Prerequisites

Install Intelephense globally:

```bash
npm install -g intelephense
```

## Install

```bash
/plugin install intelephense@ben-everly
```

## What It Does

Configures Intelephense as the PHP language server via `.lsp.json` with tuned defaults:

- **Max file size:** 1MB — skips large generated files while still allowing IDE helper files
- **Excluded paths:** Intelephense defaults (`.git`, `node_modules`, `bower_components`, etc.) plus `.history`, vendor test suites, nested vendor directories, and compiled Blade views

## File Exclusions

The exclusion list includes Intelephense's defaults plus additions optimized for Laravel-style PHP projects:

- `**/.git/**`, `**/.svn/**`, `**/.hg/**`, `**/CVS/**` — version control
- `**/.DS_Store/**`, `**/node_modules/**`, `**/bower_components/**` — OS/JS artifacts
- `**/.history/**` — VS Code Local History
- `**/vendor/**/{Tests,tests}/**` — third-party test suites (significant RAM savings)
- `**/vendor/**/vendor/**` — nested vendor directories
- `**/storage/framework/views/**` — compiled Blade views

If your project needs additional exclusions, you can override these settings in your project's `.lsp.json`.

