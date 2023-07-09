#!/bin/sh
cat vivliostyle.config.js |
grep '^#' /dev/null  `sed -n '/entry:  *\[/,/^[    ]*\]/{
    s/^[    ]*entry:  *\[ *//
    s/^[    ]*\], *//
    s/^[    ]*"//
    s/", *//
    p
}'` |
sed 's/:###### / 6 /
    s/:##### / 5 /
    s/:#### / 4 /
    s/:### / 3 /
    s/:## / 2 /
    s/:# / 1 /' |
awk '#
prev < $2 {
    for (i = 0; i < $2; ++i) {
        printf "  "
    }
    print "<ul>"
    if ($2 == 3) { section=0; }
    if ($2 == 4) { subsection=0; }
}
prev > $2 {
    for (i = 0; i < prev; ++i) {
        printf "  "
    }
    print "</ul>"
}
{
    if ($2 == 1) { tag="toc-xxx"; }
    if ($2 == 2) { tag="toc-chapter"; chapter++; n=chapter; }
    if ($2 == 3) { tag="toc-section"; section++; n=section; }
    if ($2 == 4) { tag="toc-subsection"; subsection++; n=subsection; }
    for (i = 0; i < $2; ++i) {
        printf "  "
    }
    printf "<li><a href=\"%s#%d-%d\" class=\"%s\">#%s</a></li>\n", $1, $2, n, tag, $0;
}
{ prev=$2; }' |
sed 's/>#[^ ]* [^ ]* />/'

