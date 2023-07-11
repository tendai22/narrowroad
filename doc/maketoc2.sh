#!/bin/sh

grep '^#' /dev/null  `cat vivliostyle.config.js |
sed -n '/entry:  *\[/,/^[    ]*\]/{
    /^[     ]*{/,/^[    ]*}/d
    s/^[    ]*entry:  *\[ *//
    s/^[    ]*\], *//
    s/^[    ]*"//
    s/", *//
    p
}'` |
sed '1i\
<nav id="toc" role="doc-toc">\

    /{[^{}}]*}$/!d
    s/:##### / XXXXXXXX /
    s/:#### / XXXXXXXX /
    s/:### / XXXXXX /
    s/:## / XXXX /
    s/:# / XX /
    s/^\([^ ]*\) \(XX*\) \([^{}]*\){\([^{}]*\)}/\2 - [\3](\1#\4)/
    s/^XX //
    s/^XXXX /  /
    s/^XXXXXX /    /
    s/^XXXXXXXX /      /
    s/\.md#id=/.html#/
    $a\
</nav>'
echo
echo '</nav>'
