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

## Options Reference

All document classes share two independent option groups:

### Color Options (mutually exclusive)

| Option | Links | Images | Use Case |
|--------|-------|--------|----------|
| `colorlinks` | Colored (red/blue/teal) | Original | Screen reading (default) |
| `nocolorlinks` | Black | Original | Print with colored figures |
| `bw` | Black | Original | Full print version |

### Draft/Final Options (independent of colors)

| Option | Effect | Use Case |
|--------|--------|----------|
| `final` | No watermark, todo notes hidden | Publication (default) |
| `draft` | DRAFT watermark, todo notes visible | Work in progress |

These options are independent: you can combine them freely (e.g., `draft, colorlinks` or `final, bw`).

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

Options:
- Font size: `10pt`, `11pt`, `12pt` (default: 12pt)
- Draft mode: `draft`, `final` (default: final)
- Colors: `bw`, `colorlinks`, `nocolorlinks` (default: colorlinks)
- Spacing: `singlespace`, `doublespace` (default: doublespace)
- Anonymization: `blind`
- Glossary: `glossary`, `noglossary` (default: glossary)
- Supplement mode: `onlineappendix`

### Presentation

```latex
\documentclass[aspectratio=169, colorlinks]{bp-beamer}
\begin{document}
\begin{frame}{Title}
...
\end{frame}
\end{document}
```

Options:
- Aspect ratio: `aspectratio=169`, `aspectratio=43` (default: 169)
- Draft mode: `draft`, `final` (default: final)
- Colors: `bw`, `colorlinks`, `nocolorlinks` (default: colorlinks)
- Theme: `theme=singapore`, `theme=madrid`, etc. (default: singapore)

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

Options:
- Font size: `10pt`, `11pt`, `12pt` (default: 12pt)
- Draft mode: `draft`, `final` (default: final)
- Colors: `bw`, `colorlinks`, `nocolorlinks` (default: colorlinks)
- Spacing: `singlespace`, `doublespace` (default: singlespace)
- Glossary: `glossary`, `noglossary` (default: glossary)
- Boxes: `boxes`

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

Options:
- Font size: `10pt`, `11pt`, `12pt` (default: 11pt)
- Draft mode: `draft`, `final` (default: final)
- Colors: `bw`, `colorlinks`, `nocolorlinks` (default: colorlinks)

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
