---
name: quoting
description: Use when a document you are writing shows text someone else wrote.
---

# Quoting

A quote is the author's text verbatim, inside a blockquote:

- Every line starts with `> `, blank lines and code fences included.
- Each prose paragraph is one line.
- Each heading is a bold line with the same words.
- Code, stack traces, and logs keep their lines exactly as they arrived.
- A truncation marker added by the source becomes
  `(comment truncated by source)`.

A comment arriving as:

````text
## Root cause

The retry loop never backs off, so a
partial outage turns into a hammering:

```python
for attempt in range(5):
    call()
```

[truncated]
````

renders as:

````text
> **Root cause**
>
> The retry loop never backs off, so a partial outage turns into a hammering:
>
> ```python
> for attempt in range(5):
>     call()
> ```
>
> (comment truncated by source)
````
