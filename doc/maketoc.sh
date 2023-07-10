#!/bin/sh
cat vivliostyle.config.js |
grep '^#' /dev/null  `sed -n '/entry:  *\[/,/^[    ]*\]/{
    s/^[    ]*entry:  *\[ *//
    s/^[    ]*\], *//
    s/^[    ]*"//
    s/", *//
    p
}'` |
sed 's/:#### / 4 /
    s/:### / 3 /
    s/:## / 2 /
    s/:# / 1 /' |
awk '#
BEGIN {
    print "## 目次"
    print "<nav id=\"toc\" role=\"doc-toc\">"
    prev = 1;
}
$2 !~ /^[0-9]/ { next; }
prev < $2 {   # ダイブイン
    printf "<!-- +++ %d > %d -->\n", prev, $2
    for (i = prev; i < $2; ++i) {
        for (j = 0; j < i; ++j) {
            printf "  "
        }
        print "<ul>"
        #for (j = 0; j < i; ++j) {
        #    printf "  "
        #}
        #printf "<li>"
    }
    if ($2 == 3) { section=0; }
    if ($2 == 4) { subsection=0; }
}
prev > $2 {    # ダイブアウト
    printf "<!-- %d < %d -->", prev, $2
    for (i = prev; $2 <= i; --i) {
        for (j = i; j < prev; ++j) {
            printf "  "
        }
        print "</li>"
    }
    for (i = prev; $2 <= i; --i) {
        for (j = i; j < $2; ++j) {
            printf "  "
        }
        print "</ul>"
    }
}
END {
     for (i = 0; i < prev; ++i) {
        printf "  "
    }
    print "</ul>"
    print "</nav>"
}
{
    if ($2 == 1) { tag="toc-xxx"; }
    if ($2 == 2) { tag="toc-chapter"; chapter++; n=chapter; }
    if ($2 == 3) { tag="toc-section"; section++; n=section; }
    if ($2 == 4) { tag="toc-subsection"; subsection++; n=subsection; }
    if (prev == $2) {
         for (i = 0; i < prev; ++i) {
            printf "  "
        }
        print "</li>"
    }
    for (i = 0; i < $2; ++i) {
        printf "  "
    }
    printf "<li><a href=\"%s#%d-%d\" class=\"%s\">#%s</a>", $1, $2, n, tag, $0;
}
{ prev=$2; }' |cat; exit;
sed 's/>#[^ ]* [^ ]* />/'

