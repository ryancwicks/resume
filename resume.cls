%
% resume.cls
%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{resume}[2003/10/12 v0.1 Resume document class]
\RequirePackage{strings}
\def\centerline#1{\noindent\hfil\hbox{#1}\par}
\def\lrlinefrac#1#2#3{%
    \noindent
    \@tempdima=#3\hsize
    \@tempdimb=\hsize \advance\@tempdimb-\@tempdima
    \vtop{\hsize\@tempdimb \resetmargins\rightskip\fill#1}\hfill
    \vtop{\hsize\@tempdima \resetmargins\leftskip\fill #2}\par
}%
\def\lrlinedim#1#2#3{%
    \noindent
    \@tempdima=#3\relax
    \@tempdimb=\hsize \advance\@tempdimb-\@tempdima
    \vtop{\hsize\@tempdimb \resetmargins\rightskip\fill#1}\hfill
    \vtop{\hsize\@tempdima \resetmargins\leftskip\fill #2}\par
}%
%
% Styles of the document elements
%
\def\namestyle{\Large\bfseries\MakeUppercase}
\def\degreestyle{\Large\bfseries}
\def\sectionstyle{\bfseries\scshape\lowercase}
\def\datestyle{\itshape}
\def\locstyle{\itshape}
\def\entryheadstyle{\bfseries}
%
% Document elements
%
\def\name#1{\gdef\@name{#1}}
\def\degree#1{\gdef\@degree{, #1}}
\def\address#1{\gdef\@address{#1}}
\def\phone#1{\gdef\@phone{#1}}
\def\email#1{\gdef\@email{#1}}
%
% Header format
%
\def\makeleftheader{\@address}
\def\makerightheader{\@email\\\@phone}
\def\maketitle{%
    \begingroup
%	\moveleft\dateregionwidth \vbox
	{%
	    \resetmargins
	    \centerline{{\namestyle{\@name}\degreestyle{\@degree}}}%
	    \vskip 0.5\baselineskip\@minus0.5\baselineskip
	    \lrlinefrac{\makeleftheader}{\makerightheader}{0.5}%
	}%
	\vskip 0.5\baselineskip
    \endgroup
}
%
% Section format
%
\def\section#1{%
    \@tempskipa=0.8\baselineskip
    \advance\@tempskipa 0pt \@minus 0.5\baselineskip
    \par\vskip\@tempskipa
%    \moveleft\dateregionwidth\vtop
    {%
	\resetmargins
	\noindent{\sectionstyle{#1}}%
	\vskip 2pt
	\hrule width \hsize
    }%
    \vskip\@tempskipa
}
%
% Entry format
%
\def\thepage{}
\newdimen\entry@width
\newif\if@twolinedate
\def\entry#1.#2|{%
    \ifdim\lastskip=\z@\vskip0.5\baselineskip\@minus0.2\baselineskip\fi
    \split@date{#1}%
    \noindent
    \entry@width\textwidth \advance\entry@width-\wd\date@box
    \advance\entry@width-2em \advance\entry@width\textrightmargin
    \if@twolinedate
	\parshape 3 \z@ \entry@width \z@ \entry@width \z@ \textwidth
	\def\par{\@@par
	    \ifnum\prevgraf=\@ne
		\everypar{%
		    \parshape\tw@\z@\entry@width\hangindent\textwidth
		    \everypar{}%
		}%
	    \fi
	    \global\let\par\@@par
	}%
    \else \parshape\tw@\z@\entry@width\z@\textwidth \fi
    \hb@xt@\z@{\hb@xt@\textwidth{\hfil\box\date@box\hskip\textindent}\hss}%
    \noindent
    {\entryheadstyle{\ignorespaces#2}}%
}
\newbox\date@box
{
    \makeatother
    \expandafter\xdef\csname split@date\endcsname#1{%
	\expandafter\noexpand\csname @split\endcsname{ @ }{#1}%
	    \expandafter\noexpand\csname @formatdate\endcsname
    }
}
\def\@formatdate#1#2{%
    \setbox\date@box=\vtop{\halign{\hfil##\cr
	\datestyle{\@split{-}{#1}\@parserange}\cr
	\@ifnotempty{#2}{\locstyle{\@split{,}{#2}{\@formatloc}}\cr}%
    }}%
    \@ifempty{#2}{\@twolinedatefalse}{\@twolinedatetrue}%
    \dp\date@box\z@
}
\def\@formatloc#1#2{%
    #1\@ifnotempty{#2}{, \textsc{\MakeLowercase{\ignorespaces#2}}}%
}
\def\@parserange#1#2{%
    \@parsedate#1///\@end
    \@ifnotempty{#2}{\space--\space\@parsedate#2///\@end}%
}
\def\@parsedate#1/#2/#3/#4\@end{%
    \@ifnotempty{#2}{%
	\count@=0#2\relax
	\ifcase\count@\expandafter\@gobble\or
	Jan\or Feb\or Mar\or Apr\or May\or Jun\or
	Jul\or Aug\or Sep\or Oct\or Nov\or Dec\fi.\ %
	\@ifnotempty{#3}{\count@=0#3\relax\the\count@, }%
    }%
    \edef\reserved@a{\noexpand\@ifempty{\chop@space{#1}}}%
    \reserved@a{\unskip}{#1}%
}
%
% Lists
%
\newlength\listindent
\newlength\listsep
\AtBeginDocument{\listindent=2em\relax\listsep=0.5em}
\def\item{%
    \par
    \hangindent\listindent\advance\hangindent\listsep
    \noindent\hb@xt@\listindent{\hfill\@doitem}\hskip\listsep
}
\newcount\@itemizecolcount
\newcount\@itemizecolnum
\renewenvironment{itemize}[1][1]{
    \@itemizecolnum=#1\relax
    \ifnum\@itemizecolnum=\@ne
	\let\@doitem\textbullet\par
    \else
	\@itemizecolcount\z@
	\def\item{%
	    \let\@afterfi\relax
	    \ifnum\@itemizecolcount=\@itemizecolnum\relax
		\def\@afterfi{\cr}%
		\global\@itemizecolcount\@ne
	    \else
		\ifnum\@itemizecolcount=\z@
		\else
		    \def\@afterfi{&}%
		\fi
		\global\advance\@itemizecolcount\@ne
	    \fi
	    \@afterfi
	    \hb@xt@\listindent{\hfill\textbullet}\hskip\listsep
	}%
	\halign\bgroup
	    \hskip\textindent\ignorespaces##\unskip\hfill
	    &&\ignorespaces##\unskip\hfill\cr
    \fi\ignorespaces
}{
    \ifnum\@itemizecolnum=1
	\par
    \else
	\crcr\egroup
    \fi
    \ignorespacesafterend
}
\newcounter{enumctr}\setcounter{enumctr}{1}
\renewenvironment{enumerate}{%
    \def\@doitem{\arabic{enumctr}\addtocounter{enumctr}{1}.}\par
}{
    \par\ignorespacesafterend
}
%
% Set up paper size and fonts (copied from article.cls)
%
\if@compatibility\else
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}}
\fi
\newcommand\@ptsize{}
\if@compatibility
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi
\ExecuteOptions{10pt,letterpaper,draft}
\ProcessOptions
\input{size1\@ptsize.clo}
%
% Set page parameters (override the size1x.clo file)
%
\RequirePackage{fullpage}
\parindent=0pt
\newskip\textindent \textindent=1em
\leftskip\textindent
\newskip\textrightmargin \textrightmargin=3em\@plus 2em
\rightskip\textrightmargin
\def\resetmargins{\leftskip\z@\rightskip\z@}
%
\endinput
