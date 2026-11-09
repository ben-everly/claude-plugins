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
- When any of its author, source, label, or link is known, the quote ends with
  an attribution line: `> — ` then the known parts in that order, joined by `·`,
  the link as `[↗](<url>)`.

A comment from @alice on GitHub, labeled `#3`, arriving as:

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
>
> — @alice · github · #3 [↗](https://github.com/org/repo/pull/12#discussion_r1234567)
````
