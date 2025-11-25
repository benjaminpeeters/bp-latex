%% bp-article.cls
%% Document class for academic papers and articles
%%
%% Usage: \documentclass[12pt, draft, colorlinks, doublespace]{bp-article}
%%
%% Options:
%%   - 10pt, 11pt, 12pt: font size (default: 12pt)
%%   - draft, final: toggle draft mode (watermark + todo notes)
%%   - bw, colorlinks, nocolorlinks: link color mode (default: colorlinks)
%%   - singlespace, doublespace: line spacing (default: doublespace)
%%   - blind: anonymous mode for submissions
%%   - glossary, noglossary: include glossary (default: glossary)
%%   - onlineappendix: online appendix mode
%%
%% Copyright (C) 2025 Benjamin Peeters
%% Licensed under AGPL-3.0

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bp-article}[2025/01/01 Benjamin Peeters article class]

%=====================================================================
% OPTION HANDLING
%=====================================================================

% Boolean flags
\newif\ifbparticle@draft      \bparticle@draftfalse
\newif\ifbparticle@bw         \bparticle@bwfalse
\newif\ifbparticle@colorlinks \bparticle@colorlinkstrue
\newif\ifbparticle@doublespace\bparticle@doublespacetrue
\newif\ifbparticle@blind      \bparticle@blindfalse
\newif\ifbparticle@glossary   \bparticle@glossarytrue
\newif\ifbparticle@onlineappendix \bparticle@onlineappendixfalse

% Font size (default 12pt)
\newcommand{\bparticle@fontsize}{12pt}

% Declare options
\DeclareOption{10pt}{\renewcommand{\bparticle@fontsize}{10pt}}
\DeclareOption{11pt}{\renewcommand{\bparticle@fontsize}{11pt}}
\DeclareOption{12pt}{\renewcommand{\bparticle@fontsize}{12pt}}

\DeclareOption{draft}{\bparticle@drafttrue}
\DeclareOption{final}{\bparticle@draftfalse}
\DeclareOption{bw}{\bparticle@bwtrue\bparticle@colorlinksfalse}
\DeclareOption{colorlinks}{\bparticle@colorlinkstrue\bparticle@bwfalse}
\DeclareOption{nocolorlinks}{\bparticle@colorlinksfalse\bparticle@bwfalse}
\DeclareOption{singlespace}{\bparticle@doublespacefalse}
\DeclareOption{doublespace}{\bparticle@doublespacetrue}
\DeclareOption{blind}{\bparticle@blindtrue}
\DeclareOption{glossary}{\bparticle@glossarytrue}
\DeclareOption{noglossary}{\bparticle@glossaryfalse}
\DeclareOption{onlineappendix}{\bparticle@onlineappendixtrue}

% Pass unknown options to article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessOptions\relax

%=====================================================================
% LOAD BASE CLASS
%=====================================================================

\LoadClass[\bparticle@fontsize]{article}

%=====================================================================
% LOAD INTERNAL PACKAGES WITH OPTIONS
%=====================================================================

% Build option string for bp-core
\ifbparticle@draft
    \PassOptionsToPackage{draft}{bp-core}
\else
    \PassOptionsToPackage{final}{bp-core}
\fi

\ifbparticle@bw
    \PassOptionsToPackage{bw}{bp-core}
\else
    \ifbparticle@colorlinks
        \PassOptionsToPackage{colorlinks}{bp-core}
    \else
        \PassOptionsToPackage{nocolorlinks}{bp-core}
    \fi
\fi

\ifbparticle@blind
    \PassOptionsToPackage{blind}{bp-core}
\fi

% Load packages
\RequirePackage{bp-core}
\RequirePackage{bp-common}

\ifbparticle@glossary
    \RequirePackage{bp-glossary}
\fi

%=====================================================================
% PAGE LAYOUT
%=====================================================================

\RequirePackage[margin=0.9in]{geometry}

%=====================================================================
% LINE SPACING
%=====================================================================

\RequirePackage{setspace}
\ifbparticle@doublespace
    \doublespacing
\else
    \singlespacing
\fi

%=====================================================================
% SECTION FORMATTING
%=====================================================================

\RequirePackage{titlesec}
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{3}

% List spacing
\RequirePackage{enumitem}
\setlist{noitemsep}

%=====================================================================
% HEADERS AND FOOTERS
%=====================================================================

\RequirePackage{fancyhdr}

%=====================================================================
% BIBLIOGRAPHY SPACING
%=====================================================================

\setlength{\bibsep}{0pt plus 0.1ex}

%=====================================================================
% ONLINE APPENDIX MODE
%=====================================================================

\ifbparticle@onlineappendix
    \AtBeginDocument{%
        \pagestyle{fancy}
        \fancyhf{}
        \fancyhead[R]{Supplement}
        \fancyfoot[C]{\thepage}
        \appendix
        \pagenumbering{roman}
    }
\fi

%=====================================================================
% BLIND MODE (ANONYMOUS SUBMISSIONS)
%=====================================================================

\ifbparticle@blind
    % Redefine \author to hide author info
    \renewcommand{\author}[1]{\gdef\@author{[Author information removed for blind review]}}
    % Can add more anonymization here
\fi

%=====================================================================
% DRAFT MODE NOTICE
%=====================================================================

\ifbparticle@draft
    \AtBeginDocument{%
        \let\bp@oldmaketitle\maketitle
        \renewcommand{\maketitle}{%
            \bp@oldmaketitle
            \begin{center}
            \fbox{\parbox{0.8\textwidth}{%
                \centering
                \textsc{Draft Version} -- Generated: \today\ at \currenttime\\[0.5em]
                \small This document is a working draft and should not be circulated or cited.
            }}
            \end{center}
            \vspace{1em}
        }%
    }
\fi

\endinput
