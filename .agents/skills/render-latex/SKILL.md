---
name: render-latex
description: Compile and validate tailored LaTeX CVs and cover letters, create numbered versions when standard artifacts are locked, and finalize accepted CV versions. Use when application documents must be rendered, rerendered, checked for LaTeX errors, or finalized.
---

# Render LaTeX

Build, version, validate, and finalize a self-contained vacancy-specific CV.

## Render or rerender

1. Receive the exact tailored body file and vacancy output directory from the calling workflow. The body must live under `output/<vacancy-slug>/` and originate as a copy of `cv/master_cv.tex`.
2. Run `scripts/render_cv.ps1`; do not recreate its merge, compiler-discovery, compilation, or page-count logic. On this Windows host, invoke it through `powershell.exe` so the system execution policy does not block the repository script:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\.agents\skills\render-latex\scripts\render_cv.ps1" -BodyPath ".\output\<vacancy-slug>\master-tailored-body.tex" -OutputDirectory ".\output\<vacancy-slug>" -DocumentName "CV_Kostiantyn_Pysanyi"
   ```

   Pass `-Passes 2` only when cross-references or page numbering require another pass. Pass `-PdfLatexPath` only when the user supplied a nonstandard compiler location. If the sandbox cannot access the resolved MiKTeX executable, rerun this exact script command with approved external execution.
3. Read the script's JSON result. Treat `status: error`, a nonzero process exit, a missing PDF, or a fatal LaTeX error as failure. Return `first_actionable_error` and `log_path` when supplied.
4. Use the exact `pdf_path`, `tex_path`, `artifact_stem`, `version`, and `page_count` returned by the script. It writes the standard name when available, falls back to `_version1` when a standard artifact is locked, and continues the highest existing version sequence on subsequent rerenders.
5. Do not install Python packages or invoke a separate PDF library to count pages. The script extracts the authoritative count from the LaTeX log.
6. If a PDF renderer is already available, inspect the rendered page for clipping, overflow, broken glyphs, and accidental extra pages. Do not install a renderer solely for the page-count check.
7. Keep the vacancy-specific body and generated artifacts in the same `output/<vacancy-slug>/` directory. Never overwrite `cv/master_cv.tex` or `cv/header_cv.tex`.

## Render a cover letter

1. Save the complete cover-letter source under `output/<vacancy-slug>/` with a safe filename beginning with `Cover_Letter_`.
2. Run the deterministic cover-letter renderer from the repository root:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\.agents\skills\render-latex\scripts\render_cover_letter.ps1" -TexPath ".\output\<vacancy-slug>\Cover_Letter_<name>.tex"
   ```

   Pass `-Passes 2` only when references or PDF metadata require another pass. Do not call `pdflatex.exe` directly. The script restricts inputs to cover-letter sources under `output/`, disables shell escape, resolves the local compiler, handles a locked standard artifact with a numbered PDF version, and returns JSON.
3. Treat `status: error`, a nonzero process exit, a missing PDF, or a fatal LaTeX error as failure. Use the exact paths, version status, page count, and warnings returned by the script.
4. Inspect the rendered page when a PDF renderer is available. A successful compilation is not sufficient when text is clipped, crowded, or unintentionally spans multiple pages.

## Finalize an accepted version

Treat clear approval such as "this version is good", "finalize it", "use the latest version", or an equivalent instruction as authorization to publish the latest version. Do not infer approval from an ordinary correction or rerender request.

1. Run the deterministic finalizer:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\.agents\skills\render-latex\scripts\finalize_cv.ps1" -OutputDirectory ".\output\<vacancy-slug>" -DocumentName "CV_Kostiantyn_Pysanyi"
   ```

   Pass `-Version N` only when the user explicitly accepts a version other than the latest.
2. Let the script verify the selected PDF and page count, publish its artifact set under the standard filename, verify the published PDF and TeX hashes, and then remove `_versionN` build artifacts. Never manually delete versioned files before successful publication.
3. If the result is `finalization_blocked`, tell the user which standard artifact is locked and ask them to close it before retrying. Leave every standard and versioned artifact untouched.
4. If the result is `cleanup_pending`, report the successfully published standard PDF and the locked versioned files that remain. Retry cleanup on a later finalization request; do not treat the published PDF as failed.
5. If the result is `already_standard`, report the existing standard PDF without rewriting it.

## Validation and repair boundary

- Do not silently rewrite the document to make it compile. Return compiler errors to the calling CV-tailoring workflow so it can repair the tailored body while preserving factual content.
- Before compiling, perform safe structural checks when useful: balanced braces, valid `\\href{url}{text}` forms, and escaped textual `&` and `%`.
- Do not bypass the scripts with direct `pdflatex` calls, improvised Python, MiKTeX discovery, file-versioning, or cleanup commands.
- Report rendering as unavailable only after the script's compiler-resolution options fail or MiKTeX reports genuinely missing required packages.

## Output

Report the exact input, artifact/version status, `.tex` path, generated `.pdf` path if successful, compilation status, page count, and the first actionable error plus log path if compilation failed. After CV finalization, report the standard PDF path and any cleanup failures.
