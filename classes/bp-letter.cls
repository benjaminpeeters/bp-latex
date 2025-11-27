%% bp-letter.cls
%% Document class for academic cover letters (journal submissions)
%% Wraps moderncv with BibTeX support
%%
%% Usage: \documentclass[12pt, classic]{bp-letter}
%%
%% Options:
%%   - 10pt, 11pt, 12pt: font size (default: 12pt)
%%   - a4paper, letterpaper: paper size (default: a4paper)
%%   - classic, casual, banking, oldstyle: moderncv style (default: classic)
%%   - draft, final: toggle draft mode
%%
%% Copyright (c) 2025 Benjamin Peeters
%% Licensed under MIT

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bp-letter}[2025/01/01 Benjamin Peeters cover letter class]

%=====================================================================
% OPTION HANDLING
%=====================================================================

% Font size (default 12pt)
\newcommand{\bpletter@fontsize}{12pt}
\DeclareOption{10pt}{\renewcommand{\bpletter@fontsize}{10pt}}
\DeclareOption{11pt}{\renewcommand{\bpletter@fontsize}{11pt}}
\DeclareOption{12pt}{\renewcommand{\bpletter@fontsize}{12pt}}

% Paper size (default a4paper)
\newcommand{\bpletter@paper}{a4paper}
\DeclareOption{a4paper}{\renewcommand{\bpletter@paper}{a4paper}}
\DeclareOption{letterpaper}{\renewcommand{\bpletter@paper}{letterpaper}}

% ModernCV style (default classic)
\newcommand{\bpletter@style}{classic}
\DeclareOption{classic}{\renewcommand{\bpletter@style}{classic}}
\DeclareOption{casual}{\renewcommand{\bpletter@style}{casual}}
\DeclareOption{banking}{\renewcommand{\bpletter@style}{banking}}
\DeclareOption{oldstyle}{\renewcommand{\bpletter@style}{oldstyle}}

% Draft mode
\newif\ifbpletter@draft \bpletter@draftfalse
\DeclareOption{draft}{\bpletter@drafttrue}
\DeclareOption{final}{\bpletter@draftfalse}

% Pass unknown options to moderncv
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{moderncv}}

\ProcessOptions\relax

%=====================================================================
% LOAD BASE CLASS
%=====================================================================

\LoadClass[\bpletter@fontsize,\bpletter@paper,sans]{moderncv}

%=====================================================================
% MODERNCV CONFIGURATION
%=====================================================================

\moderncvstyle{\bpletter@style}
\moderncvcolor{green}

%=====================================================================
% PAGE LAYOUT
%=====================================================================

\RequirePackage[scale=0.87, bottom=0.5in, top=0.5in]{geometry}
\RequirePackage{ragged2e}

%=====================================================================
% BIBLIOGRAPHY SUPPORT
%=====================================================================

\RequirePackage{natbib}
\RequirePackage{etoolbox}
\RequirePackage{url}

% DOI hyperlink command (used by abbrvnat_custom.bst)
\newcommand{\hrefdoi}[1]{\href{https://doi.org/#1}{\nolinkurl{#1}}}

% Bibliography file command
\newcommand{\bpbibfile}[1]{\def\bp@bibfile{#1}}

% Auto-print references at end of document
\AtEndDocument{%
    \ifdef{\bp@bibfile}{%
        \clearpage
        \begingroup
        % Suppress default "References" section heading from natbib
        \renewcommand{\section}[2]{}%
        {\large\textbf{References}}
        \vspace{1em}
        \bibliographystyle{abbrvnat_custom}
        \bibliography{\bp@bibfile}
        \endgroup
    }{}%
}

%=====================================================================
% DRAFT MODE
%=====================================================================

\ifbpletter@draft
    \RequirePackage{datetime}
    \AtBeginDocument{%
        \thispagestyle{empty}
        \begin{center}
        \fbox{\small\textsc{Draft} -- \today\ at \currenttime}
        \end{center}
        \vspace{-1em}
    }
\fi

\endinput
