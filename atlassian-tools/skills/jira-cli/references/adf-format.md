# ADF (Atlassian Document Format)

Jira Cloud uses ADF (JSON-based) for rich text fields. Use ADF when you need programmatic/structured content; for most cases, prefer plain text markdown (see SKILL.md).

## acli Limitations

Headings, text marks (bold/italic/code), code block syntax highlighting (the `language` attr in `codeBlock`), and task lists (`taskList`/`taskItem`) are rejected or stripped by acli. For checklists, use plain text `[] item` / `[x] item` syntax instead.

**Supported elements:** Paragraphs, bullet lists, ordered lists, code blocks (no highlighting).

## ADF Structure

Every ADF document wraps content in a top-level `doc` node:

```json
{
  "version": 1,
  "type": "doc",
  "content": [...]
}
```

### Paragraph

```json
{
  "version": 1,
  "type": "doc",
  "content": [
    {
      "type": "paragraph",
      "content": [{ "type": "text", "text": "Your text" }]
    }
  ]
}
```

### Bullet List

```json
{
  "version": 1,
  "type": "doc",
  "content": [
    {
      "type": "bulletList",
      "content": [
        {
          "type": "listItem",
          "content": [
            {
              "type": "paragraph",
              "content": [{ "type": "text", "text": "Item one" }]
            }
          ]
        }
      ]
    }
  ]
}
```

### Ordered List

Same structure as bullet list — replace `bulletList` with `orderedList`.

### Code Block

```json
{
  "version": 1,
  "type": "doc",
  "content": [
    {
      "type": "codeBlock",
      "attrs": {},
      "content": [{ "type": "text", "text": "def hello():\n    print('Hello')" }]
    }
  ]
}
```

## Usage with acli

```bash
# Post a comment using inline ADF JSON
acli jira workitem comment create --key <KEY> --body '{"version":1,"type":"doc","content":[...]}'

# Post a comment from an ADF JSON file
acli jira workitem comment create --key <KEY> --body-file comment.json

# Set description using ADF
acli jira workitem edit --key <KEY> --description '{"version":1,"type":"doc","content":[...]}'
```
