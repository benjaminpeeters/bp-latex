# bp-latex

Personal LaTeX document classes for academic writing by Benjamin Peeters.

## Features

- One-line document setup via custom classes
- No hardcoded paths (portable across machines)
- Consistent styling for papers, presentations, books, and notes
- Built-in glossary/acronym support
- Todo notes for draft mode
- Theorem environments with cleveref integration

## Installation

```bash
git clone https://github.com/benjaminpeeters/bp-latex.git ~/MEGA/repo/latex
cd ~/MEGA/repo/latex
./install.sh
```

The install script:
1. Creates symlinks in ~/texmf (changes reflect immediately)
2. Sets up the $BPBIB environment variable for bibliography

## Usage

### Paper/Article

```latex
\documentclass[12pt, draft, colorlinks, doublespace]{bp-article}
\begin{document}
\title{My Paper}
\author{Author Name}
\maketitle
...
\end{document}
```

Options: 10pt/11pt/12pt, draft/final, colorlinks/nocolorlinks, singlespace/doublespace, blind, glossary/noglossary, onlineappendix

### Presentation

```latex
\documentclass[aspectratio=169, colorlinks]{bp-beamer}
\begin{document}
\begin{frame}{Title}
...
\end{frame}
\end{document}
```

Options: aspectratio=169/43, draft/final, colorlinks/nocolorlinks

### Book

```latex
\documentclass[12pt, colorlinks, boxes]{bp-book}
\begin{document}
\frontmatter
...
\mainmatter
\chapter{Introduction}
...
\end{document}
```

Options: 10pt/11pt/12pt, draft/final, colorlinks/nocolorlinks, singlespace/doublespace, glossary/noglossary, boxes

The `boxes` option enables special tcolorbox environments:
- `\begin{boxcasestudy}{Title}...\end{boxcasestudy}` (green, numbered)
- `\begin{boxconcept}{Title}...\end{boxconcept}` (blue, numbered)
- `\begin{boxwarning}{Title}...\end{boxwarning}` (red)

### Quick Note

```latex
\documentclass[11pt]{bp-note}
\begin{document}
\section{Notes}
...
\end{document}
```

Options: 10pt/11pt, draft/final, colorlinks/nocolorlinks

## Available Features

### Math Commands
- `\R` - Real numbers
- `\argmin`, `\argmax` - Argument min/max
- `\bs{x}` - Bold symbol

### Theorem Environments
theorem, assumption, hypothesis, proposition, conjecture, lemma, corollary, observation, definition

### Acronyms (bp-article, bp-book)
Use `\gls{gdp}` for acronyms. Common ones predefined: GDP, IMF, FDI, etc.

### Todo Notes (draft mode)
- `\unsure{text}` - Orange note
- `\change{text}` - Red note
- `\comment{text}` - Inline note

## Directory Structure

```
bp-latex/
├── classes/          # Document classes (.cls)
├── internal/         # Internal packages (.sty)
├── data/             # Data files (glossary entries)
├── bst/              # Bibliography styles
├── templates/        # Starter templates
├── install.sh        # Installation script
├── uninstall.sh      # Uninstallation script
└── README.md
```

## Uninstallation

```bash
cd ~/MEGA/repo/latex
./uninstall.sh
```

## License

AGPL-3.0

## Author

Benjamin Peeters - benjaminpeeters.com
