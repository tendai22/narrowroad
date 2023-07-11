module.exports = {
    title: 'Octalのほそ道 - Moore師匠の歩いた道をたどる',
    author: 'Norihiro Kumagai <tendai22plus@gmail.com>',
    language: 'ja',
    size: 'JIS-B5',
    theme: 'css/sample1.css',
    entry: [
        "toppage.md",
        {
            path: 'toc.md',
            rel: 'contents',
        },
        "ch01.md",
        "ch02.md",
        "ch03.md",
        "ch04.md",
        "ch05.md",
        "reference.md",
        "okuduke.md",
    ],
    workspaceDir: 'work',
    output: [
        "narrowroad.pdf"
    ],
    toc: true,
    tocTitle: '目次',
};