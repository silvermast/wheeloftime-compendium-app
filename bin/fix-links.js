const fs = require('fs/promises');

const SHOW_CONFLICTS = process.argv.includes('--show-conflicts');
const SAVE = process.argv.includes('--save');

const linkOverrides = {
    alDai: 'Bili-al-Dai',
    Alsbet: 'Alsbet-Luhhan',
    Arene: 'Jorin-Arene',
    Artur: 'Artur-Hawkwing',
    Aven: 'Avendesora',
    Avendo: 'Avendoraldera',
    Baal: 'Ba-alzamon',
    Balwen: 'King-Balwen-Mayel',
    Barran: 'Doral-Barran',
    Bashere: 'Davram-t-Ghaline-Bashere',
    Belal: 'Be-lal',
    Bornhald: 'Geofram-Bornhald',
    Caar: 'Caar-al-Thorin-al-Toren',
    Carridin: 'Jaichim-Carridin',
    Cole: 'Master-Cole',
    Cowin: 'Cowin-Gemallen',
    Darl: 'Darl-Coplin',
    Dark: 'Dark-One',
    Dawn: 'He-Who-Comes-With-the-Dawn',
    Dragon: 'The-Dragon',
    Fitch: 'Master-Fitch',
    Grinwell: 'Else-Grinwell',
    Hawking: 'Artur-Hawking',
    Hornwell: 'Master-Hornwell',
    Kari: 'Kari-al-Thor',
    Kin2: 'Kin',
    Luca: 'Valan-Luca',
    Luhhan: 'Haral-Luhhan',
    MeriConlin: 'Meri-do-Ahlan-a-Conlin',
    Morning: 'Lord-of-the-Morning',
    MralDai: 'Master-al-Dai',
    Nem: 'Admer-Nem',
    Nethin: 'Tal-Nethin',
    Rogosh: 'Rogosh-of-Talmour',
    SusaWynn: 'Susa-Wynn',
    Thane: 'Jon-Thane',
    Thorin: 'Thorin-al-Toren-al-Ban',
    Thom: 'Thomdril-Thom-Merrilin',
    TomasT: 'Tomas-Trakand',
    Wil: 'Wil-al-Caar',
    WillaMandair: 'Willa-Mandair',
    '9Moons': 'Daughter-of-the-Nine-Moons',
    Osangar: 'Osan-gar',
    Arangar: 'Aran-gar',
    Caracarn: 'Car-a-carn',
    Naeblis: 'Nae-blis',
    Anan: 'Setalle-Anan',
    WilalSeen: 'Wil-al-Seen',
    Grady: 'Jur-Grady',
    MHael: 'M-Hael',
    Leilwin2: 'Leilwin-Shipless',
    LenCongar: 'Len-Congar',
    JacCoplin: 'Jac-Coplin',
    Aldragoran: 'Weilin-Aldragoran',
    Ayellin: 'Jon-Ayellin',
    Hob: 'Old-Hob',
    Fanwar: 'Renald-Fanwar',
    Taidaishar: 'Tai-daishar',
    Bunt: 'Almen-Bunt',
    OakDancer: 'Oak-Dancer',
    Emarin2: 'Emarin',
    Osiellin: 'Lord-Amondrid-Osiellin',
    Janduin2: 'Janduin',
    Torkumen: 'Lord-Vram-Torkumen',
    Wind2: 'Wind',
};

async function readBook(bookFile) {
    return JSON.parse(await fs.readFile(`${__dirname}/../assets/data/${bookFile}`));
}

async function writeBook(bookFile, bookData) {
    return await fs.writeFile(`${__dirname}/../assets/data/${bookFile}`, JSON.stringify(bookData, null, 2));
}

function staticRepairs(text) {
    return text
        .replace(/<a class='name' [^>]+>([^<]+)<[^a]+a>/g, '$1')
        .replace(/<a href='([^']+)'>([^<]+)<\/a>/g, '[$2]($1)') // <a href='#Mistress-of-Novices'>Mistress of Novices</a>
        .replace(/<\/?(i|em)>/g, '_')
        .replace(/<!--[^>]+>/g, '')
        .trim();
}

function repairEntry(text, oldLink, newLink) {
    return text.replace(new RegExp(`'#${oldLink}'`, 'g'), `'#${newLink}'`);
}

function findCharacterById(bookData, id) {
    return bookData.find(c => c.id === id);
}

async function processBook(bookFile) {
    console.log('Processing', bookFile);
    const bookData = await readBook(bookFile);

    // default to static list of repairs
    const linkRepairs = linkOverrides || {};
    const conflicts = {};

    const newBookData = bookData.map(character => {
        let links = character.info.match(/'#[^']+'/g) || [];

        links.forEach(link => {
            const hashLink = link.replace(/(^'#|'$)/g, '');

            if (findCharacterById(bookData, hashLink)) { // Link is correct
                return;
            }

            // NOTE: Some character IDs change between books (marriage, titles, etc.)
            // Double-check them here!!
            if (linkRepairs[hashLink] && findCharacterById(bookData, linkRepairs[hashLink])) {
                character.info = repairEntry(character.info, hashLink, linkRepairs[hashLink]);
                return;
            }

            if (conflicts[hashLink]) { // we've already parsed it and found conflicts
                return;
            }

            const matcher = new RegExp(`(^|-)${hashLink}(-|$)`);

            const matches = bookData.filter(c => c.id.match(matcher)).map(c => c.id);

            if (matches.length === 1) {
                character.info = repairEntry(character.info, hashLink, matches[0]);

            } else {
                conflicts[hashLink] = matches;
            }

        });

        character.info = staticRepairs(character.info);

        return character;
    });

    if (Object.keys(conflicts).length || SHOW_CONFLICTS) {
        console.error('FOUND CONFLICTS:', conflicts);

    } else if (SAVE) {
        await writeBook(bookFile, newBookData);

    } else {
        console.log(JSON.stringify(newBookData, null, 2));

    }
}

(async () => {

    await processBook('book-00.json'); // - OK
    await processBook('book-01.json'); // - OK
    await processBook('book-02.json'); // - OK
    await processBook('book-03.json'); // - OK
    await processBook('book-04.json'); // - OK
    await processBook('book-05.json'); // - OK
    await processBook('book-06.json'); // - OK
    await processBook('book-07.json'); // - OK
    await processBook('book-08.json'); // - OK
    await processBook('book-09.json'); // - OK
    await processBook('book-10.json'); // - OK
    await processBook('book-11.json'); // - OK
    await processBook('book-12.json'); // - OK
    await processBook('book-13.json'); // - OK
    await processBook('book-14.json'); // - OK

})()