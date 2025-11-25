%% bp-note.cls
%% Document class for quick notes (1-10 pages)
%% Minimal setup for fast compilation
%%
%% Usage: \documentclass[11pt]{bp-note}
%%
%% Options:
%%   - 10pt, 11pt, 12pt: font size (default: 11pt)
%%   - draft, final: toggle draft mode (watermark + todo notes)
%%   - bw, colorlinks, nocolorlinks: link color mode (default: colorlinks)
%%
%% Copyright (C) 2025 Benjamin Peeters
%% Licensed under AGPL-3.0

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bp-note}[2025/01/01 Benjamin Peeters note class]

%=====================================================================
% OPTION HANDLING
%=====================================================================

% Boolean flags
\newif\ifbpnote@draft      \bpnote@draftfalse
\newif\ifbpnote@bw         \bpnote@bwfalse
\newif\ifbpnote@colorlinks \bpnote@colorlinkstrue

% Font size (default 11pt for notes)
\newcommand{\bpnote@fontsize}{11pt}

% Declare options
\DeclareOption{10pt}{\renewcommand{\bpnote@fontsize}{10pt}}
\DeclareOption{11pt}{\renewcommand{\bpnote@fontsize}{11pt}}
\DeclareOption{12pt}{\renewcommand{\bpnote@fontsize}{12pt}}

\DeclareOption{draft}{\bpnote@drafttrue}
\DeclareOption{final}{\bpnote@draftfalse}
\DeclareOption{bw}{\bpnote@bwtrue\bpnote@colorlinksfalse}
\DeclareOption{colorlinks}{\bpnote@colorlinkstrue\bpnote@bwfalse}
\DeclareOption{nocolorlinks}{\bpnote@colorlinksfalse\bpnote@bwfalse}

% Pass unknown options to article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessOptions\relax

%=====================================================================
% LOAD BASE CLASS
%=====================================================================

\LoadClass[\bpnote@fontsize]{article}

%=====================================================================
% LOAD INTERNAL PACKAGES WITH OPTIONS
%=====================================================================

% Build option string for bp-core
\ifbpnote@draft
    \PassOptionsToPackage{draft}{bp-core}
\else
    \PassOptionsToPackage{final}{bp-core}
\fi

\ifbpnote@bw
    \PassOptionsToPackage{bw}{bp-core}
\else
    \ifbpnote@colorlinks
        \PassOptionsToPackage{colorlinks}{bp-core}
    \else
        \PassOptionsToPackage{nocolorlinks}{bp-core}
    \fi
\fi

% Load packages (minimal set for fast compilation)
\RequirePackage{bp-core}
\RequirePackage{bp-common}

%=====================================================================
% COMPACT PAGE LAYOUT
%=====================================================================

\RequirePackage[margin=1in]{geometry}

%=====================================================================
% SINGLE SPACING (COMPACT)
%=====================================================================

\RequirePackage{setspace}
\singlespacing

%=====================================================================
% MINIMAL SECTION FORMATTING
%=====================================================================

\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{2}

% Compact list spacing
\RequirePackage{enumitem}
\setlist{noitemsep,topsep=0pt}

\endinput
