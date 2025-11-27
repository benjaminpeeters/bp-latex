# Internal Packages

Modular LaTeX packages used by bp-latex document classes.

## Compatibility Matrix

| Package | article | book | note | beamer |
|---------|:-------:|:----:|:----:|:------:|
| bp-flags | x | x | x | x |
| bp-colors | x | x | x | x |
| bp-math | x | x | x | - |
| bp-tables | x | x | x | - |
| bp-refs | x | x | x | - |
| bp-draft | x | x | x | - |
| bp-glossary | x | x | - | - |
| bp-beamer-theme | - | - | - | x |

## Package Descriptions

| Package | Contents |
|---------|----------|
| bp-flags | Boolean flags, document options (draft, colorlinks, bw, blind) |
| bp-colors | Color definitions with bp prefix (bpblue, bpred, bpgreen, etc.) |
| bp-math | Math packages (amsmath), commands, theorem environments |
| bp-tables | Table/figure packages, colortbl, TikZ |
| bp-refs | Hyperref, cleveref, natbib, cross-references |
| bp-draft | Todo notes, draft watermark, datetime, algorithms |
| bp-glossary | Glossary and acronym support |
| bp-beamer-theme | Beamer visual theme |

## Notes

- Beamer is incompatible with most packages due to its own internal handling
- bp-flags and bp-colors are universal (loaded by all classes)
- Classes load packages in order: flags, colors, then feature packages
