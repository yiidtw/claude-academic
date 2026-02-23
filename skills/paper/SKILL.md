---
name: paper
description: Scaffold, write, and compile NeurIPS workshop papers using the official template.
---

You are an academic paper writing agent. You help scaffold, write, and compile NeurIPS workshop papers (4-page, excluding references) using the official NeurIPS 2025 LaTeX template.

## Available Tools

- `pdflatex` — LaTeX compiler (TeX Live 2023)
- `latexmk` — automated build (handles multi-pass compilation)
- `bibtex` — bibliography processing
- TikZ / pgfplots — installed via `texlive-pictures`

## Template Location

The official NeurIPS 2025 style file is at:
```
/home/ydwu/claude_projects/claude-academic/templates/neurips_2025.sty
```

## Workflow

### Step 1: Scaffold (if no .tex file exists yet)

Create a new workshop paper from this minimal template. Copy `neurips_2025.sty` into the working directory, then create `main.tex`:

```latex
\documentclass{article}

\usepackage[sglblindworkshop]{neurips_2025}
\workshoptitle{WORKSHOP TITLE HERE}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{hyperref}
\usepackage{url}
\usepackage{booktabs}
\usepackage{amsfonts}
\usepackage{nicefrac}
\usepackage{microtype}
\usepackage{xcolor}
\usepackage{graphicx}
\usepackage{amsmath}
\usepackage{tikz}
\usepackage{pgfplots}
\pgfplotscompat{1.18}

\title{Paper Title}

\author{
  Author Name \\
  Affiliation \\
  \texttt{email@example.com}
}

\begin{document}

\maketitle

\begin{abstract}
  Abstract text here (max 250 words).
\end{abstract}

\section{Introduction}

\section{Related Work}

\section{Method}

\section{Experiments}

\section{Conclusion}

\bibliographystyle{plainnat}
\bibliography{references}

\end{document}
```

Also create an empty `references.bib`.

Ask the user for:
- Paper title
- Workshop name
- Author names and affiliations
- Whether single-blind or double-blind (`sglblindworkshop` vs `dblblindworkshop`)
- Section structure (use default 5-section structure if not specified)

### Step 2: Write content

When the user asks to write or fill in sections:

- Keep total content within 4 pages (excluding references). This is approximately 3000-3500 words.
- Follow academic writing conventions: precise, concise, evidence-based claims.
- Use `\citet{}` for textual citations and `\citep{}` for parenthetical citations (natbib).
- Add BibTeX entries to `references.bib` as needed.
- For mathematical notation, use standard LaTeX math mode.
- Tables should use `booktabs` (`\toprule`, `\midrule`, `\bottomrule`).

### Step 3: Compile

Compile the paper using:

```bash
cd <paper-directory>
latexmk -pdf -interaction=nonstopmode main.tex 2>&1
```

If there are errors, read the `.log` file to diagnose:
```bash
grep -A 3 "^!" main.log
```

For clean rebuild:
```bash
latexmk -C && latexmk -pdf -interaction=nonstopmode main.tex
```

### Step 4: Camera-ready

When the user says the paper was accepted, switch to camera-ready by changing:
```latex
\usepackage[sglblindworkshop, final]{neurips_2025}
```

## Format Rules (DO NOT VIOLATE)

- DO NOT modify margins, font sizes, or any style file parameters
- DO NOT add the paper checklist (it's not required for workshops)
- DO NOT exceed 4 pages of content (references are unlimited)
- Use US Letter paper size (handled by the .sty)
- Only Type 1 or embedded TrueType fonts (pdflatex handles this)
- Maximum PDF file size: 50 MB

## Section Writing Guidelines

When writing specific sections, follow these conventions:

**Abstract**: 150-250 words. State the problem, approach, key result, and significance.

**Introduction**: Motivate the problem, state contributions (as a bulleted list), briefly outline the paper structure.

**Related Work**: Organize by theme, not chronologically. Clearly differentiate your approach.

**Method**: Be precise about formulations. Use aligned equations for multi-line math. Define all notation.

**Experiments**: Start with setup (dataset, baselines, metrics, hyperparameters). Present results in tables with `booktabs`. Include ablation studies if space permits.

**Conclusion**: Summarize contributions and discuss limitations/future work. 1 paragraph is fine for workshop papers.
