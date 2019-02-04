# tikz2svg

Converts Tkiz (La)TeX documents into SVG.

## Usage

```
$ cat tikz.tex
\documentclass{standalone}
\usepackage{tikz}
\begin{document}
  \begin{tikzpicture}
    \node {Hello Tikz!};
  \end{tikzpicture}
\end{document}

$ cat tikz.tex | docker container run --rm -i greegorey/tikz2svg > tikz.svg

