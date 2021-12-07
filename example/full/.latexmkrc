#!/usr/bin/env perl

# tex options
$latex        = 'uplatex -synctex=1 -shell-escape -halt-on-error -kanji=utf8';
$latex_silent = $latex . ' -interaction=batchmode';
$lualatex     = 'lualatex -synctex=1 -shell-escape';
$biber        = 'upbiber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex       = 'upbibtex %O %B';
$dvipdf       = 'dvipdfmx -d 5 %O -o %D %S';
$makeindex    = 'upmendex %O -o %D %S';
$max_repeat   = 5;
$pdf_mode     = 4;
