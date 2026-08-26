# CV Tailoring with Codex

This repository keeps a factual CV source of truth and a reusable Codex skill for tailoring it to job descriptions.

## Use from this repository

Open Codex with `C:\Users\konst\cv-tailor` as the working directory and paste:

```text
Use the tailor-cv skill.

Tailor my CV to this position:

[paste the complete position description]
```

Or, more briefly:

```text
Tailor my CV to this position:

[paste the complete position description]
```

The skill analyzes the match first, then returns the complete tailored LaTeX CV. It uses `cv/master_cv.tex` for facts and `cv/template_cv.tex` for formatting. Vacancy-specific files can be saved under `output/`.

Do not put unsupported experience into the master CV. Update that file only when adding a fact that is genuinely true, then let the skill use it for future applications.
