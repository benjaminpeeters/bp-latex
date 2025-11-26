%% bp-beamer.cls
%% Document class for presentations
%%
%% Usage: \documentclass[aspectratio=169, colorlinks]{bp-beamer}
%%
%% Options:
%%   - aspectratio=169, aspectratio=43: slide aspect ratio (default: 169)
%%   - draft, final: toggle draft mode (watermark + todo notes)
%%   - bw, colorlinks, nocolorlinks: link color mode (default: colorlinks)
%%   - theme=singapore, theme=madrid, etc.: beamer theme (default: singapore)
%%
%% Copyright (c) 2025 Benjamin Peeters
%% Licensed under MIT

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bp-beamer}[2025/01/01 Benjamin Peeters beamer class]

%=====================================================================
% OPTION HANDLING
%=====================================================================

% Boolean flags
\newif\ifbpbeamer@draft      \bpbeamer@draftfalse
\newif\ifbpbeamer@bw         \bpbeamer@bwfalse
\newif\ifbpbeamer@colorlinks \bpbeamer@colorlinkstrue

% Aspect ratio (default 16:9)
\newcommand{\bpbeamer@aspectratio}{169}

% Theme (default singapore)
\newcommand{\bpbeamer@theme}{singapore}

% Declare options
\DeclareOption{draft}{\bpbeamer@drafttrue}
\DeclareOption{final}{\bpbeamer@draftfalse}
\DeclareOption{bw}{\bpbeamer@bwtrue\bpbeamer@colorlinksfalse}
\DeclareOption{colorlinks}{\bpbeamer@colorlinkstrue\bpbeamer@bwfalse}
\DeclareOption{nocolorlinks}{\bpbeamer@colorlinksfalse\bpbeamer@bwfalse}

% Handle key=value options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=bpbeamer,prefix=bpbeamer@}
\DeclareStringOption[169]{aspectratio}
\DeclareStringOption[singapore]{theme}

% Pass unknown options to beamer class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}

\ProcessKeyvalOptions*
\ProcessOptions\relax

%=====================================================================
% LOAD BASE CLASS
%=====================================================================

\LoadClass[aspectratio=\bpbeamer@aspectratio]{beamer}

%=====================================================================
% LOAD INTERNAL PACKAGES WITH OPTIONS
%=====================================================================

% Build option string for bp-core
\ifbpbeamer@draft
    \PassOptionsToPackage{draft}{bp-core}
\else
    \PassOptionsToPackage{final}{bp-core}
\fi

\ifbpbeamer@bw
    \PassOptionsToPackage{bw}{bp-core}
\else
    \ifbpbeamer@colorlinks
        \PassOptionsToPackage{colorlinks}{bp-core}
    \else
        \PassOptionsToPackage{nocolorlinks}{bp-core}
    \fi
\fi

% Load packages (NOT bp-common or bp-glossary - incompatible with beamer)
\RequirePackage{bp-core}
\RequirePackage{bp-beamer-theme}

\endinput
