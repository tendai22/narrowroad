#!/bin/sh
cat vivliostyle.config.js |
grep '^#' /dev/null  `sed -n '/entry:  *\[/,/^[    ]*\]/{
    s/^[    ]*entry:  *\[ *//
    s/^[    ]*\], *//
    s/^[    ]*"//
    s/", *//
    p
}'` |
sed '/{[^{}}]*}$/!d
    s/:###### / 6 /
    s/:##### / 5 /
    s/:#### / 4 /
    s/:### / 3 /
    s/:## / 2 /
    s/:# / 1 /
    s/^\([^ ]*\) \([^{}]*\){\([^{}]*\)}/\1#\3 \2/' |#cat; exit;
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
    }
    if ($2 == 3) { section=0; }
    if ($2 == 4) { subsection=0; }
}
prev > $2 {    # ダイブアウト
    printf "<!-- %d < %d -->", prev, $2
    for (i = prev; $2 < i; --i) {
        for (j = 0; j < prev; ++j) {
            printf "  "
        }
        print "</li>"
        for (j = 0; j < $2; ++j) {
            printf "  "
        }
        print "</ul>"
    }
    for (i = 0; i < prev; ++i) {
        printf "  "
    }
    print "</li>"

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
    if ($2 == 5) { tag="toc-column"; column++; n=column; }
    if (prev == $2) {
         for (i = 0; i < prev; ++i) {
            printf "  "
        }
        print "</li>"
    }
    for (i = 0; i < $2; ++i) {
        printf "  "
    }
    printf "<li><a href=\"%s\" class=\"%s\">#%s</a>", $1, tag, $0;
}
{ prev=$2; }' |
sed 's/>#[^ ]* [^ ]* />/'

