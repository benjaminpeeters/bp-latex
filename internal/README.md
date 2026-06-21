# Internal Packages

Modular LaTeX packages used by bp-latex document classes.

## Compatibility Matrix

| Package | article | book | note | beamer | letter | tikz |
|---------|:-------:|:----:|:----:|:------:|:------:|:----:|
| bp-flags | x | x | x | x | - | - |
| bp-colors | x | x | x | x | - | x |
| bp-math | x | x | x | - | - | x |
| bp-tables | x | x | x | - | - | - |
| bp-refs | x | x | x | - | - | - |
| bp-draft | x | x | x | - | - | - |
| bp-glossary | x | x | - | - | - | - |
| bp-beamer-theme | - | - | - | x | - | - |
| bp-tikz-timeline | - | - | - | - | - | o |
| bp-tikz-mindmap | - | - | - | - | - | o |
| bp-tikz-schematic | - | - | - | - | - | o |

`x` = always loaded; `o` = loaded on demand via a class option.

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
| bp-tikz-timeline | Timeline figure layer: event styles, `\drawTimeline`/`\drawLegend` (bp-tikz `[timeline]`) |
| bp-tikz-mindmap | Mindmap figure layer: varwidth nodes, `comment`/`list` styles (bp-tikz `[mindmap]`) |
| bp-tikz-schematic | Schematic figure layer: box/flowchart node styles (bp-tikz `[schematic]`) |

## Notes

- Beamer is incompatible with most packages due to its own internal handling
- bp-flags and bp-colors are universal (loaded by all classes except letter)
- Classes load packages in order: flags, colors, then feature packages
- bp-letter wraps moderncv directly (does not use internal packages)
- bp-tikz (standalone figure class) loads bp-colors + bp-math and, on demand via a
  class option, one bp-tikz-* family layer. Figure sources live in the sibling
  bp-figures/ repo.
