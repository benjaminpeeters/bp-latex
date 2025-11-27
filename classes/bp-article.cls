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
%% Copyright (c) 2025 Benjamin Peeters
%% Licensed under MIT

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

% Build option string for bp-flags
\ifbparticle@draft
    \PassOptionsToPackage{draft}{bp-flags}
\else
    \PassOptionsToPackage{final}{bp-flags}
\fi

\ifbparticle@bw
    \PassOptionsToPackage{bw}{bp-flags}
\else
    \ifbparticle@colorlinks
        \PassOptionsToPackage{colorlinks}{bp-flags}
    \else
        \PassOptionsToPackage{nocolorlinks}{bp-flags}
    \fi
\fi

\ifbparticle@blind
    \PassOptionsToPackage{blind}{bp-flags}
\fi

% Load packages (order matters: flags first, then colors, then features)
\RequirePackage{bp-flags}
\RequirePackage{bp-colors}
\RequirePackage{bp-math}
\RequirePackage{bp-tables}
\RequirePackage{bp-refs}
\RequirePackage{bp-draft}

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
% PUBLIC FLAGS FOR CONTENT FILES
%=====================================================================

% Provide \ifblind for use in content files
\newif\ifblind
\ifbparticle@blind
    \blindtrue
\else
    \blindfalse
\fi

% Provide \ifonlineappendix for shared.tex
\newif\ifonlineappendix
\ifbparticle@onlineappendix
    \onlineappendixtrue
\else
    \onlineappendixfalse
\fi

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
% AUTO BACKMATTER COMMANDS
%=====================================================================

% Bibliography file command
\newcommand{\bpbibfile}[1]{\def\bp@bibfile{#1}}

% Acknowledgments command (content only, section added automatically)
\newcommand{\bpacknowledgments}[1]{\def\bp@acknowledgments{#1}}

% Declaration of interest command
\newcommand{\bpdeclaration}[1]{\def\bp@declaration{#1}}

% Need etoolbox for \ifdef
\RequirePackage{etoolbox}

% At end of document, auto-print backmatter
\AtEndDocument{%
    % Declaration of interest (only for main, not supplement)
    \ifbparticle@onlineappendix\else
        \ifdef{\bp@declaration}{%
            \section*{Declaration of interest}
            \bp@declaration
        }{}%
    \fi
    % Acknowledgments (only for main, not supplement)
    \ifbparticle@onlineappendix\else
        \ifdef{\bp@acknowledgments}{%
            \section*{Acknowledgments}
            \bp@acknowledgments
        }{}%
    \fi
    % Bibliography
    \ifdef{\bp@bibfile}{%
        \onehalfspacing
        \section*{References}
        \bibliographystyle{plainnat}
        \bibliography{\bp@bibfile}
    }{}%
    % Glossary (if enabled)
    \ifbparticle@glossary
        \printglossary[type=\acronymtype, title=List of Acronyms]
    \fi
}

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
