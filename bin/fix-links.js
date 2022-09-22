const fs = require('fs/promises');

const SHOW_CONFLICTS = process.argv.includes('--show-conflicts');
const SAVE = process.argv.includes('--save');

const linkOverrides = {
    alDai: 'Bili-al-Dai',
    Alsbet: 'Alsbet-Luhhan',
    Arene: 'Jorin-Arene',
    Artur: 'Artur-Hawkwing',
    Aven: 'Avendasora',
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

async function processBook(bookFile) {
    console.log('--------------', 'Processing', bookFile, '--------------');
    const bookData = await readBook(bookFile);

    // default to static list of repairs
    const linkRepairs = linkOverrides || {};
    const conflicts = {};

    bookData.forEach(character => {
        let links = character.info.match(/'#[^']+'/g);
        if (!links) {
            return;
        }
        links = links.forEach(link => {
            const hashLink = link.replace(/(^'#|'$)/g, '');

            if (linkRepairs[hashLink]) { // link has been processed already
                return;
            }

            if (bookData.find(c => c.id === hashLink)) { // Link is correct
                return;
            }

            if (conflicts[hashLink]) { // we've already parsed it and found conflicts
                return;
            }

            const matcher = new RegExp(`(^|-)${hashLink}(-|$)`);

            const matches = bookData.filter(c => c.id.match(matcher)).map(c => c.id);

            if (matches.length === 1) {
                linkRepairs[hashLink] = matches[0];
            } else {
                conflicts[hashLink] = matches;
            }

            // linkRepairs[hashLink] = matches;
        });
    });
    // console.log(linkRepairs);
    if (Object.keys(conflicts).length || SHOW_CONFLICTS) {
        console.error('FOUND CONFLICTS:', conflicts);

    } else if (SAVE) {

        const replaceLinks = (text) => {
            let newText = text;
            Object.entries(linkRepairs).forEach(([oldLink, newLink]) => {
                newText = newText.replace(new RegExp(`'#${oldLink}'`, 'g'), `'#${newLink}'`);
            });
            return newText;
        };

        await writeBook(
            bookFile, 
            bookData.map(character => {
                character.info = replaceLinks(character.info);
                return character;
            }),
        );

    } else {
        console.log('Propsed fixes:', linkRepairs);

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