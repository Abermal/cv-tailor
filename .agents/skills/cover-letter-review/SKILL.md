---
name: cover-letter-review
description: Independently and critically review an existing cover letter for one vacancy, find text that reads as generic, generated, unnatural, padded, or weakly relevant, and correct it by cutting, rewriting, or replacing the point with stronger evidence that cv/master_cv.tex supports. Use when asked to review, critique, or harden a cover letter, and in the unattended review pass after a letter is drafted.
---

# Cover Letter Review

You are a second reader, not the author. Assume the draft has weaknesses and look for them sentence by sentence. A reader at the company sees dozens of letters a week, and many were written by a model. Your job is to make this one read as a specific engineer writing to a specific employer, and to make every sentence earn its place.

The `cover-letter` skill defines the standard for structure, voice, and factual limits. Read its `SKILL.md` and follow it; this skill adds the critical pass on top of it. Where the two seem to differ, the factual rules win.

## Sources

1. Read the vacancy completely, the letter (TXT and TEX), `cv/master_cv.tex`, and [career context](../cover-letter/references/career-context.md). Read the tailored CV body in the vacancy directory to see what the CV already says, so the letter adds to it rather than repeating it.
2. `cv/master_cv.tex` is the factual source of truth. Career context holds additional user-confirmed background, project details, and motivation; a claim supported there is supported, as long as it is used exactly as recorded and not strengthened. Do not remove a strong, supported point only because it comes from career context rather than the CV. A fix must never add a fact, number, technology, responsibility, or motivation that these sources do not support. Dropping an unsupported claim is always allowed.

## Step 1: decide what this employer most needs

Before judging any sentence, write down for yourself the two or three things this vacancy most needs: a problem, a kind of system, a domain, a working mode such as ownership in a small team. Ignore boilerplate requirements every vacancy lists. Then list the candidate's strongest supported evidence for each of them from the master CV, including items the draft did not use.

## Step 2: find the weak points

Check every sentence against these patterns. They are the usual tells of a generated or template letter.

- **Summary and filler sentences.** A sentence that only restates the paragraph or announces what the evidence "shows": "Together these show how I…", "This experience has taught me…", "Diese Erfahrungen zeigen…". Cut it, or replace it with a concrete consequence.
- **Abstract value statements.** Claims about principles or values with nothing behind them: "Reliable, traceable systems are a central measure of good engineering for me", "I value ownership, fast progress, and reliable engineering". Keep a value only if a concrete example sits next to it.
- **Mirrored triplets and rhythm.** Lists of exactly three abstract nouns or adjectives, sentences built as "not only X but also Y" / "nicht nur … sondern auch", "from X to Y" spans, and a closing line that ties the list back ("a founding role asks for all three"). One such device in a letter can be natural; two or more read as generated.
- **Copied vacancy language.** Phrases, slogans, or the list of responsibilities taken from the posting, or an opening that restates the job title and the posting's own description of the team. Explain the match in the candidate's words.
- **Template sentences.** Sentences that would fit any company if the name were swapped: "I would like to bring my experience with reproducible ML workflows to your solutions", "Gern bringe ich meine Erfahrung … ein", generic praise of the mission. The motivation paragraph must name something specific to this employer's work or say modestly that the candidate is drawn to the advertised work.
- **Tool inventories.** A sentence that strings tools together ("DVC data versioning, MLflow experiment tracking and automated evaluation…") without the problem they solved. Keep a tool when it explains a decision; otherwise name the problem and the result.
- **Repeated stock evidence.** The same paragraph about the same projects, in the same order, regardless of the role. Ask whether this evidence is the best answer to Step 1 for *this* vacancy. If a less-used but supported item fits better (text data, real-time systems, mentoring, research, a freelance project, an internship in the employer's domain), swap it in and shorten the weaker one.
- **Overclaims and hedged bridges.** "Transfers directly", "I am confident that…", "state of the art", "immediate real-world impact", and any wording that turns study, familiarity, or team work into personal hands-on ownership.
- **Unnatural phrasing.** Stacked dashes or semicolons used for drama, nominal chains, inflated verbs ("leverage", "spearhead", "drive"), words the candidate would not say in an interview, idioms, and in German letters stiff officialese or anglicised word order. Grammar must stay correct; do not simulate mistakes.
- **Weak structure.** An opening without a fit claim, evidence that never connects to the role, a motivation paragraph that is about career advancement, repeated ideas across paragraphs, or a practical point (language level, location) buried in a paragraph where it does not belong.

## Step 3: correct

- Change what is weak, keep what works. A sentence that is specific, supported, and relevant stays word for word. Prefer cutting over adding. Do not restyle a good letter just to show activity; "unchanged" is a valid outcome.
- When you cut a weak point, either let the paragraph end earlier or use the space for the stronger evidence found in Step 1. Develop that evidence as the `cover-letter` skill describes: the problem or constraint, the candidate's contribution, and the supported result or significance.
- Keep the structure, the language of the letter, the salutation and sign-off, the company address block, and the length within the `cover-letter` target (about 250–350 words; never longer than the draft by more than a few words). The letter must still fit on one page.
- Re-check each changed sentence against the master CV and the chronology before keeping it.

## Step 4: final read

Read the corrected letter top to bottom once as the hiring manager. Every sentence should answer "why this candidate for this role" or "why this company". Check that no new pattern from Step 2 was introduced by your own edits.

## Output

- **Interactive use.** Report the findings and show the corrected draft in chat. Edit files only when the user asks to apply the changes.
- **Files, when asked to apply or in unattended runs.** Edit the letter in place:
  - The TXT stays clean plain text with paragraph breaks and no markup.
  - In the TEX, change only the letter's text. Keep the preamble, packages, macros, layout, address block, and date as they are. Escape `&`, `%`, `$`, `#`, `_` and use valid LaTeX. Do not render it unless the user asks; the job-scout worker renders unattended letters itself.
  - The TXT and TEX must contain the same wording.
- **Review note.** When files are edited, or the caller asks for one, write the note to the path the caller gives (by default `Cover_Letter_Review.txt` in the vacancy directory). Write it in English, plain text, in this form:

  ```text
  Verdict: revised (<n> changes)
  Focus: <the two or three needs from Step 1, one line>

  Changes:
  - [<pattern>] "<original excerpt>" -> "<new text, or 'removed'>": <why, one line>

  Kept: <one line on what was already strong>
  Unresolved: <claims that need the candidate's confirmation, or "None">
  ```

  Use `Verdict: unchanged` and omit the `Changes:` list when nothing needed to change. The first line must start with `Verdict:` because the worker reads it. Keep excerpts short and do not include private material beyond the letter itself.
- Never modify the master CV, career context, skills, the tailored CV, the job summary, or any other file in the vacancy directory.
