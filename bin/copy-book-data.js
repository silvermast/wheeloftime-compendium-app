const fs = require('fs');
// const ent = require('ent');

const oldDir = `${__dirname}/../../wotcc/www/data`;
const newDir = `${__dirname}/../assets/data`;


// &#x2009;
// &#x2013;
// &#x2014;
// &#x2018;
// &#x2019;
// &#x201C;
// &#x201D;
// &#x2026;
// &#xA0;
// &#xE7;
// &#xE9;
// &amp;
// &apos;
// &ldquo;
// &mdash;
// &quot;
// &rdquo;
function decodeUtf8(text) {
    return String(text).split(/&#?([^;]+);/g).map(fragment => {
        const entIndex = {
            'amp': '&',
            'apos': "'",
            'ldquo': '“',
            'mdash': '—',
            'quot': '"',
            'rdquo': '”',
        };
        if (fragment[0] === 'x') {
            return String.fromCodePoint(parseInt(fragment.substring(1), 16));
        } else if (entIndex[fragment]) {
            return entIndex[fragment];
        } else {
            return fragment;
        }
    }).join('');
}

fs.readdirSync(oldDir).forEach(bookFile => {
    console.log('Importing', bookFile);
    let bookData = JSON.parse(fs.readFileSync(`${oldDir}/${bookFile}`));
    bookData = Object.values(bookData).map(entry => {
        let { id, name } = entry;
        let chapter = entry.chapters[0].title;
        let info = entry.chapters[0].info;
        info = decodeUtf8(info);
        return { id, name, chapter, info };
    });

    fs.writeFileSync(`${newDir}/${bookFile}`, JSON.stringify(bookData, null, 2));
});