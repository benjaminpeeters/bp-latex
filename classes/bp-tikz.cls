%% bp-tikz.cls
%% Document class for standalone TikZ figures (cropped to content).
%%
%% Usage: \documentclass[timeline]{bp-tikz}   % or [mindmap], [schematic], or none
%%
%% Options:
%%   - timeline / mindmap / schematic: load the matching family style layer
%%   - any other option (border=..., crop=..., 12pt, preview=...) passes to standalone
%%
%% Each figure is its own file compiled to a tight, cropped PDF; documents then
%% \includegraphics the PDF. Colors/fonts/math come from the bp-* internals so
%% figures match the papers.
%%
%% Copyright (c) 2025 Benjamin Peeters
%% Licensed under MIT

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bp-tikz}[2025/01/01 Benjamin Peeters standalone TikZ figure class]

%=====================================================================
% OPTION HANDLING
%=====================================================================

% Family style layers (pick one via a class option; none = generic figure)
\newif\ifbptikz@timeline  \bptikz@timelinefalse
\newif\ifbptikz@mindmap   \bptikz@mindmapfalse
\newif\ifbptikz@schematic \bptikz@schematicfalse

\DeclareOption{timeline}{\bptikz@timelinetrue}
\DeclareOption{mindmap}{\bptikz@mindmaptrue}
\DeclareOption{schematic}{\bptikz@schematictrue}

% Everything else (border=..., crop=..., 12pt, preview=...) goes to standalone
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{standalone}}

\ProcessOptions\relax

%=====================================================================
% LOAD BASE CLASS (standalone -> tight cropped PDF)
%=====================================================================

\LoadClass[crop=true,border=2pt]{standalone}

%=====================================================================
% SHARED SETUP (colors, fonts, math, language, TikZ + common libraries)
%=====================================================================

\RequirePackage{bp-colors}   % xcolor[table,dvipsnames] + lmodern + graphicx + bp palette
\RequirePackage{bp-math}     % amsmath/amssymb + shared macros (\bs, \R, ...) -> match papers
\RequirePackage[english]{babel}

\RequirePackage{tikz}
\usetikzlibrary{calc}
\usetikzlibrary{positioning}
\usetikzlibrary{math}
\usetikzlibrary{matrix}
\usetikzlibrary{arrows.meta}
\usetikzlibrary{shapes}
\usetikzlibrary{shapes.geometric}
\usetikzlibrary{patterns}
\usetikzlibrary{patterns.meta}

% Accent with no bp-colors equivalent (used by the timeline layer's political events)
\definecolor{bppurple}{rgb}{0.47, 0.20, 0.78}

%=====================================================================
% FAMILY STYLE LAYERS
%=====================================================================

\ifbptikz@timeline  \RequirePackage{bp-tikz-timeline}  \fi
\ifbptikz@mindmap   \RequirePackage{bp-tikz-mindmap}   \fi
\ifbptikz@schematic \RequirePackage{bp-tikz-schematic} \fi

\endinput
