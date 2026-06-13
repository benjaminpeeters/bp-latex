%% bp-book.cls
%% Document class for books
%%
%% Usage: \documentclass[12pt, colorlinks, boxes]{bp-book}
%%
%% Options:
%%   - 10pt, 11pt, 12pt: font size (default: 12pt)
%%   - draft, final: toggle draft mode (watermark + todo notes)
%%   - bw, colorlinks, nocolorlinks: link color mode (default: colorlinks)
%%   - singlespace, doublespace: line spacing (default: singlespace)
%%   - glossary, noglossary: include glossary (default: glossary)
%%   - boxes: enable tcolorbox environments (boxcasestudy, boxconcept, boxwarning)
%%   - preview: minimal mode for previewing content (enables boxes, empty pagestyle)
%%
%% Copyright (c) 2025 Benjamin Peeters
%% Licensed under MIT

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bp-book}[2025/01/01 Benjamin Peeters book class]

%=====================================================================
% OPTION HANDLING
%=====================================================================

% Boolean flags
\newif\ifbpbook@draft      \bpbook@draftfalse
\newif\ifbpbook@bw         \bpbook@bwfalse
\newif\ifbpbook@colorlinks \bpbook@colorlinkstrue
\newif\ifbpbook@doublespace\bpbook@doublespacefalse  % Default single for books
\newif\ifbpbook@glossary   \bpbook@glossarytrue
\newif\ifbpbook@boxes      \bpbook@boxesfalse
\newif\ifbpbook@preview    \bpbook@previewfalse
\newif\ifbpbook@lineno     \bpbook@linenofalse

% Font size (default 12pt)
\newcommand{\bpbook@fontsize}{12pt}

% Declare options
\DeclareOption{10pt}{\renewcommand{\bpbook@fontsize}{10pt}}
\DeclareOption{11pt}{\renewcommand{\bpbook@fontsize}{11pt}}
\DeclareOption{12pt}{\renewcommand{\bpbook@fontsize}{12pt}}

\DeclareOption{draft}{\bpbook@drafttrue}
\DeclareOption{final}{\bpbook@draftfalse}
\DeclareOption{bw}{\bpbook@bwtrue\bpbook@colorlinksfalse}
\DeclareOption{colorlinks}{\bpbook@colorlinkstrue\bpbook@bwfalse}
\DeclareOption{nocolorlinks}{\bpbook@colorlinksfalse\bpbook@bwfalse}
\DeclareOption{singlespace}{\bpbook@doublespacefalse}
\DeclareOption{doublespace}{\bpbook@doublespacetrue}
\DeclareOption{glossary}{\bpbook@glossarytrue}
\DeclareOption{noglossary}{\bpbook@glossaryfalse}
\DeclareOption{boxes}{\bpbook@boxestrue}
\DeclareOption{preview}{\bpbook@previewtrue\bpbook@boxestrue\bpbook@glossaryfalse}
\DeclareOption{lineno}{\bpbook@linenotrue}

% Pass unknown options to book class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

\ProcessOptions\relax

%=====================================================================
% LOAD BASE CLASS
%=====================================================================

\ifbpbook@preview
    \LoadClass[\bpbook@fontsize,oneside]{book}
\else
    \LoadClass[\bpbook@fontsize]{book}
\fi

%=====================================================================
% LOAD INTERNAL PACKAGES WITH OPTIONS
%=====================================================================

% Build option string for bp-flags
\ifbpbook@draft
    \PassOptionsToPackage{draft}{bp-flags}
\else
    \PassOptionsToPackage{final}{bp-flags}
\fi

\ifbpbook@bw
    \PassOptionsToPackage{bw}{bp-flags}
\else
    \ifbpbook@colorlinks
        \PassOptionsToPackage{colorlinks}{bp-flags}
    \else
        \PassOptionsToPackage{nocolorlinks}{bp-flags}
    \fi
\fi

\ifbpbook@lineno
    \PassOptionsToPackage{lineno}{bp-flags}
\fi

% Load packages (order matters: flags first, then colors, then features)
\RequirePackage{bp-flags}
\RequirePackage{bp-colors}
\RequirePackage{bp-math}
\RequirePackage{bp-tables}
\RequirePackage{bp-refs}
\RequirePackage{bp-draft}

\ifbpbook@glossary
    \RequirePackage{bp-glossary}
\fi

%=====================================================================
% PAGE LAYOUT
%=====================================================================

\RequirePackage[left=20mm,right=20mm,top=25mm,bottom=25mm]{geometry}

%=====================================================================
% LINE SPACING
%=====================================================================

\RequirePackage{setspace}
\ifbpbook@doublespace
    \doublespacing
\else
    \singlespacing
\fi

%=====================================================================
% CHAPTER STYLING
%=====================================================================

\RequirePackage[raggedright]{titlesec}
\newcommand{\hsp}{\hspace{10pt}}
\titleformat{\chapter}[hang]{\LARGE\bfseries}{\thechapter\hsp\textcolor{bpgray5}{$|$}\hsp}{0pt}{\LARGE\bfseries}

%=====================================================================
% TOC CONFIGURATION
%=====================================================================

\RequirePackage{tocbibind}

%=====================================================================
% HEADERS AND FOOTERS
%=====================================================================

\RequirePackage{fancyhdr}
\fancyhf{}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0pt}

\ifbp@draft
    \fancypagestyle{plain}{%
        \fancyhf{}%
        \fancyfoot[C]{\thepage}%
        \fancyhead[C]{\footnotesize\textcolor{bpred}{\textbf{DRAFT} -- \today}}%
    }
    \fancyhead[C]{\footnotesize\textcolor{bpred}{\textbf{DRAFT} -- \today}}
\fi
\ifbpbook@preview
    \pagestyle{empty}
\else
    \pagestyle{fancy}
\fi

%=====================================================================
% ADDITIONAL PACKAGES
%=====================================================================

\RequirePackage{lscape}
\RequirePackage{pdflscape}
\RequirePackage[title]{appendix}
\RequirePackage{eurosym}

%=====================================================================
% TCOLORBOX ENVIRONMENTS (OPTIONAL)
%=====================================================================

\ifbpbook@boxes
    \RequirePackage[many]{tcolorbox}

    % Case study box (green)
    \newtcolorbox[auto counter,number within=chapter, list inside=casestudy]{boxcasestudy}[2][]{%
        breakable,
        skin=bicolor jigsaw,
        colbacklower=black!6,
        colback=white,
        colframe=bpgreen!60!black,
        fonttitle=\bfseries,
        center title,
        colbacktitle=bpgreen!10!white,
        coltitle=black,
        boxrule=1.2pt,
        titlerule=0.0pt,
        arc=0.5mm,
        toptitle=2mm,
        bottomtitle=2mm,
        subtitle style={boxrule=0.0pt, halign=center},
        lines before break=20,
        title=Case study~\thetcbcounter: #2,#1}

    % Technical note box (blue)
    \newtcolorbox[auto counter,number within=chapter]{boxconcept}[2][]{%
        breakable,
        skin=bicolor jigsaw,
        colbacklower=black!6,
        colback=white,
        colframe=bpblue!60!black,
        fonttitle=\bfseries,
        center title,
        colbacktitle=bpblue!10!white,
        coltitle=black,
        boxrule=1.2pt,
        titlerule=0.0pt,
        arc=0.5mm,
        toptitle=2mm,
        bottomtitle=2mm,
        subtitle style={boxrule=0.0pt, halign=center},
        lines before break=20,
        title=Technical Note~\thetcbcounter: #2,#1}

    % Warning box (red)
    \newtcolorbox{boxwarning}[2][]{%
        colframe=bpred!75!black,
        colback=bpred!5!white,
        fonttitle=\bfseries,
        center title,
        boxrule=0.9pt,
        titlerule=0.0pt,
        arc=0.5mm,
        toptitle=2mm,
        bottomtitle=2mm,
        lines before break=20,
        title=Warning: #2,#1}

    % Command to print list of case studies
    \newcommand{\listofcasestudies}{%
        \tcblistof[\chapter*]{casestudy}{List of Case Studies}%
        \addcontentsline{toc}{chapter}{List of Case Studies}%
    }
\fi

%=====================================================================
% PREVIEW MODE SUPPORT
%=====================================================================

\ifbpbook@preview
    \RequirePackage{xstring}
    % Smart path handling for preview content:
    %   \previewcontent{concepts/file}        -> ../concepts/file (adds ../)
    %   \previewcontent{../concepts/file}     -> ../concepts/file (unchanged)
    %   \previewcontent{/absolute/path/file}  -> /absolute/path/file (unchanged)
    \newcommand{\previewcontent}[1]{%
        \IfBeginWith{#1}{/}{\input{#1}}{%
            \IfBeginWith{#1}{..}{\input{#1}}{%
                \input{../#1}%
            }%
        }%
    }
\fi

\endinput
