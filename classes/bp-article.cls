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
\newif\ifbparticle@lineno     \bparticle@linenofalse

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
\DeclareOption{lineno}{\bparticle@linenotrue}

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

\ifbparticle@lineno
    \PassOptionsToPackage{lineno}{bp-flags}
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

% environ: capture abstract/keyword environment bodies for the custom title page.
\RequirePackage{environ}

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
% TITLE PAGE
%=====================================================================
% Class-owned \maketitle: lays out title + authors + date + (main only)
% abstract + keywords/JEL on ONE vertically balanced page, robust to varying
% title/abstract length. Documents set \title ONCE (the supplement label is
% prepended automatically) and supply metadata via the standard abstract
% environment plus an Elsevier elsarticle-style keyword environment.

% Supplement label: single source of truth (also used by the running header).
\newcommand{\bp@supplementlabel}{Supplementary Material}
\newcommand{\bpsupplementlabel}[1]{\renewcommand{\bp@supplementlabel}{#1}}

% Capture the abstract + keyword bodies so \maketitle can place them. Both must
% appear in the document BEFORE \maketitle.
\newif\ifbp@hasabstract
\newif\ifbp@haskeyword
\newcommand{\bp@abstract}{}
\newcommand{\bp@keyword}{}
\RenewEnviron{abstract}{\global\let\bp@abstract\BODY\global\bp@hasabstracttrue}
\NewEnviron{keyword}{\global\let\bp@keyword\BODY\global\bp@haskeywordtrue}

% Render the captured keyword block in Elsevier elsarticle's style: italic
% "Keywords:"/"JEL:" labels, \sep -> comma, single-spaced, raggedright.
\newcommand{\bp@printkeywords}{%
    \begingroup
        \normalsize\normalfont\setstretch{1}\parskip\z@\raggedright
        \def\sep{\unskip, }%
        \def\MSC{\@ifnextchar[{\@bp@MSC}{\@bp@MSC[2000]}}%
        \def\@bp@MSC[##1]{\par\leavevmode\hbox{\it ##1~MSC:\space}}%
        \def\PACS{\par\leavevmode\hbox{\it PACS:\space}}%
        \def\JEL{\par\leavevmode\hbox{\it JEL:\space}}%
        \noindent\textit{Keywords: }\bp@keyword\par
    \endgroup}

% Title-page vertical-balance weights (top : mid : bottom stretch glue) and the
% per-side abstract narrowing. Tunable.
\newcommand{\bp@titletopweight}{1}
\newcommand{\bp@titlemidweight}{1.4}
\newcommand{\bp@titlebotweight}{1.8}
\newlength{\bp@abstractindent}
\setlength{\bp@abstractindent}{0.06\textwidth}

\renewcommand{\maketitle}{%
    \begingroup
        \thispagestyle{empty}%
        \setstretch{1}% single-spaced title page despite the doublespace default
        \ifbparticle@lineno\nolinenumbers\fi
        % title-page footnotes (\thanks / author \footnote) use *, dagger, ...
        \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
        \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
        \setcounter{footnote}{0}%
        \null\vspace*{\stretch{\bp@titletopweight}}%
        \begin{center}%
            \ifonlineappendix
                {\large\scshape \bp@supplementlabel\par}%
                \vskip 1.2em
            \fi
            {\LARGE\bfseries \@title \par}%
            \vskip 1.5em
            {\large \let\footnote\thanks
                \begin{tabular}[t]{c}\@author\end{tabular}\par}%
            \vskip 1em
            {\large \@date \par}%
        \end{center}%
        \ifbparticle@draft
            \vskip 1.5em
            \begin{center}\small
                \fbox{\parbox{0.75\textwidth}{\centering
                    \textsc{Draft Version} -- Generated: \today\ at \currenttime\\[0.2em]
                    \footnotesize This document is a working draft and should not be circulated or cited.%
                }}%
            \end{center}%
        \fi
        \ifonlineappendix\else
            \ifbp@hasabstract
                \vspace*{\stretch{\bp@titlemidweight}}%
                {\setstretch{1}\small
                    \begin{center}\textbf{\abstractname}\end{center}%
                    \vskip 0.3em
                    \begingroup
                        \leftskip\bp@abstractindent \rightskip\bp@abstractindent
                        \noindent \bp@abstract \par
                    \endgroup}%
            \fi
            \ifbp@haskeyword
                \vskip 0.9em
                \bp@printkeywords
            \fi
        \fi
        \vspace*{\stretch{\bp@titlebotweight}}%
        \@thanks
    \endgroup
    \clearpage
    \ifonlineappendix
        % supplement keeps roman numbering + section-prefixed footnotes from the
        % onlineappendix \AtBeginDocument hook; only reset the footnote counter.
        \setcounter{footnote}{0}%
    \else
        \setcounter{page}{1}%
        \setcounter{footnote}{0}%
        \renewcommand{\thefootnote}{\arabic{footnote}}%
    \fi
    \ifbparticle@lineno\linenumbers\fi
    \global\let\@thanks\@empty
    \global\let\thanks\relax
    \global\let\and\relax
}

%=====================================================================
% ONLINE APPENDIX MODE
%=====================================================================

\ifbparticle@onlineappendix
    \AtBeginDocument{%
        \pagestyle{fancy}
        \fancyhf{}
        \fancyhead[R]{\bp@supplementlabel}
        \fancyfoot[C]{\thepage}
        \appendix
        \pagenumbering{roman}
        % Custom numbering for online appendix (section-prefixed)
        \def\theequation{\thesection.\arabic{equation}}
        \def\thefigure{\thesection.\arabic{figure}}
        \def\thetable{\thesection.\arabic{table}}
        \def\thefootnote{\thesection.\arabic{footnote}}
    }
\fi

%=====================================================================
% AUTO BACKMATTER (GLOSSARY ONLY)
%=====================================================================
% Bibliography, acknowledgments, and declaration are NOT auto-printed.
% Put them in a backmatter.tex that each document \inputs just before
% \end{document} (see templates/article-with-supplement/). This keeps
% \bibliography a literal that both the LaTeX build and the editor LSP
% resolve; a macro-indirected \bibliography is invisible to the LSP and
% makes it report every \cite as an undefined reference.

% At end of document, auto-print the glossary (if the glossary option is set).
\AtEndDocument{%
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

\endinput
