---
layout: docs
title: Trocha teorie
prev_section: 
next_section: 
permalink: /docs/teorie/
---

V tomto textu se zlehka podíváme na základy elektrotechniky. Pokud vás nezajímá *nudná* teorie, můžete tuto sekci zatím přeskočit. Při práci s Arduinem se (alespoň zpočátku) bez teorie obejdete. Jakmile zjistíte, že nerozumíte některému z dalších textů nebo projektů, můžete se na tuto kapitolu podívat.

## Napětí a proud

Napětí a proud jsou základní obvodové veličiny, se kterými se budeme setkávat neustále. Jsou to fyzikální veličiny a běžně se značí písmeny `U` a `I` a jejich jednotky jsou `V` (volt) a `A` (ampér). V anglicky psané literatuře se napětí častěji značí písmenem `V`, což ale může vyvolat zmatky s jeho jednotkou `V`.

| Název  | Veličina | Jednotka  |
|:------:|:--------:|:---------:|
| Napětí | U        | V (volt)  |
| Proud  | I        | A (ampér) |

Napětí i proud nám dávají představu, co se děje uvnitř obvodu a obě jsou na sobě závislé. V uzavřeném obvodu nemůže existovat napětí bez proudu a naopak. Proto se jim říká *základní obvodové veličiny*.

Určitě víte, že na bateriích je napsáno jaké napětí lze na jejich svorkách naměřit. Například jedna tužková baterie typu AA má napětí 1,5 V. To znamená, že pokud ke svorkám baterie přiložíme voltmetr (například ruční multimetr nastavený na měření napětí), objeví se na měřicím přístroji hodnota právě 1,5 V. Jak si ale velikost napětí představit?

K popisu napětí a proudu se často používá analogie s vodou a vodovodním potrubím. V této analogii si můžeme napětí baterie představit jako malé čerpadlo. To přečerpává vodu z níže položené nádržky do nádržky nahoře -- na baterii označené jako mínus `-` a plus `+`. Čím větší napětí baterie, tím výše je horní nádrž položena a tím více práce musí čerpadlo vykonat, aby dostalo vodu nahoru. Jakmile je jednou voda nahoře, může vlivem gravitace stékat potrubím dolů a zpátky do spodní nádrže a po cestě může vykonávat práci -- například roztáčet lopatky turbíny. Rozdíl hladin v obou nádržích způsobuje, že voda může protékat. To samé platí i o napětí na baterii. Říkáme, že mezi kontakty baterie je *rozdíl potenciálů*, neboli napětí. Čím větší napětí, tím více proudu proteče obvodem a tím pádem se vykoná i více práce[^1].

[^1]: V elektrotechnice málokdy hovoříme o práci. Častěji se používá slovo *výkon*, což je vlastně práce za čas.

Proud je pak reakce na vzniklý rozdíl potenciálů. Představte si jej jako množství vody, které proteče určitým úsekem potrubí za určitý čas. Pokud zvětšíme průměr potrubí, proteče jím za stejnou dobu více vody. To znamená dvě věci -- jednak se musí zvětšit práce/výkon našeho imaginárního čerpadla, protože musí do horní nádrže dodat za stejný čas více vody. Za druhé pak proud vody po cestě vykoná více práce -- rychleji roztočí elektromotor, více nažhaví vlákno žárovky, apod.

![Zdroj napětí se znázorněnými směry napětí a proudu]({{ site.url }}/imgs/zdroj-napeti.png){: .caption}

Pojďme se teď podívat na další podrobnosti vztahující se k napětí a proudu. V elektrotechnice se k zápisu obvodů používají tzv. *elektronická schémata*. Není to nic jiného, než zjednodušený nákres skutečnosti, který nám umožňuje pochopit jak je daný obvod zapojen.

Na obrázku výše jsou schématické značky pro zdroje napětí. To je obecně jakýkoliv prvek, který dokáže do obvodu dodávat předem dané napětí a libovolně velký proud[^2]. V odborné literatuře se ke znázornění zdroje napětí používá kruh, na kterém je zvýrazněna kladná a záporná svorka (viz část obrázku vlevo). Ve starších knihách nebo v případě, že chceme znázornit baterii jako zdroj napětí, se používá krátké a dlouhé čáry (viz část obrázku vpravo).

[^2]: A existuje také *zdroj proudu*. Má jinou schématickou značku a chová se jinak než zdroj napětí, ale my se jím zatím zabývat nebudeme.

Na obrázku jsou také znázorněny směry napětí a proudů. Šipka znázorňující napětí `U` jde od kladné svorky zdroje k záporné svorce. Proud `I` pak teče obvodem od kladné svorky k záporné[^3].

[^3]: To je pouze formální zápis směru proudu. Ve skutečnosti se zjistilo, že proud teče od záporné svorky ke kladné, ale z historických důvodů se stále ve schématech používá směr opačný.

Zastavme se na chvíli nad terminologií. V případě proudu říkáme, že teče z bodu A do bodu B. Například *proud I teče ze zdroje do spotřebiče* nebo *proud tekoucí obvodem má velikost tolik a tolik ampér*. Naopak u napětí hovoříme o tom, že se vyskytuje na konkrétním prvku. Například *mezi svorkami zdroje je napětí tolik a tolik voltů* nebo *úbytek napětí na rezistoru je tolik a tolik voltů*.

## Ohmův zákon

Pokud se na chvíli zamyslíte nad tím, co již bylo řečeno, pravděpodobně brzy přijdete na to, že napětí a proud jsou na sobě nějakým způsobem závislé. V naší analogii s vodou jsme si řekli, že aby se zvětšil proud, musíme buď umístit horní nádržku s vodou mnohem výše anebo rozšířit potrubí. První případ -- poloha nádržky s vodou -- představuje velikost napětí zdroje. Pokud do stejného obvodu připojíme k jedné tužkové baterii ještě jednu, proud tekoucí do obvodu se zvětší na dvojnásobek. Co ale znamená to rozšíření potrubí?

Představte si nádržku s jedním litrem vody. Pokud k ní připojíme velmi široké potrubí, voda z nádrže vyteče téměř okamžitě. Pokud k ní ale připojíme úzké potrubí, voda bude z nádrže vytékat v mnohem menší míře a tím pádem bude i déle trvat, než se nádrž celá vyprázdní. Stejné je to i v případě baterií. Pokud vložíme dvě tužkové baterie do foťáku, vybijí se mnohem dříve než kdybychom je vložili do dálkového ovládání k televizi. Zatímco ve fotoaparátu vydrží baterie pár desítek fotografií, v dálkovém ovládání mohou pracovat klidně několik let. V obou případech je napětí baterií stejné, řekněme 3 V. To co je ale důležité a co se liší je proud. Fotoaparát k nabití blesku a následnému uložení informací na paměťovou kartu potřebuje řádově stokrát větší proud, než dálkové ovládání k přepnutí televizního kanálu -- ve fotoaparátu je mnohem širší potrubí než v dálkovém ovládání.

Šířka potrubí tedy určuje, jak velký proud poteče ze zdroje (baterie) do spotřebiče (fotoaparát, dálkové ovládání). V elektronice neříkáme *šířka potrubí* ani *šířka vodiče*, k vyjádření vztahu mezi napětím a proudem používáme spojení *elektrický odpor*, značíme jej písmenem `R` a jeho fyzikální jednotka je `Ω` (čti *ohm*, podle německého fyzika *George Simona Ohma*).

Vztah mezi proudem, napětím a elektrickým odporem lze zapsat následujícím způsobem:

$$ U = R \cdot I\;\;\mathrm{[V, }\;\Omega\mathrm{, A]} $$

Tomuto vztahu se v elektronice říká *Ohmův zákon* a je jedním ze tří nejdůležitějších vztahů elekroniky. Zkuste si z tohoto vztahu vyjádřit proud a potom i odpor a popřemýšlet, co nám Ohmův zákon říká:

$$
I = \frac{U}{R}\;\mathrm{[A}],\;\;\;
R = \frac{U}{I}\;\mathrm{[}\Omega\mathrm{]}
$$

Z těchto vztahů je patrné, že pokud chceme aby do obvodu tekl menší proud, musíme buď zmenšit napětí nebo zvětšit odpor. Také nám vztahy říkají, že pokud se zmenší napětí zdroje (například baterie se vybije), přímoúměrně se zmenší i proud. Pokud se napětí zmenší na polovinu, klesne na polovinu i proud. Ukažme si to na jednoduchém příkladě:

> *Napětí zdroje je 1,5 V, proud tekoucí do obvodu je 0,1 A. Jaký proud poteče do obvodu, když napětí stoupne na 2 V?*

Nejdříve si spočítejme odpor z původního napětí a proudu. Zjistíme, že odpor obvodu je $$R = 15\;\Omega$$. Jakmile již známe odpor, spočítáme nový proud.

$$
R = \frac{U}{I} = \frac{1{,}5}{0{,}1} = 15 \; \Omega \\
I = \frac{U}{R} = \frac{2{,}0}{15} = 0{,}13\;\mathrm{A}
$$

Nový proud tekoucí ze zdroje do obvodu je tedy $$I = 0{,}13\;\mathrm{A}$$, neboli $$130\;\mathrm{mA}$$.

Z toho co jsme si zatím uvedli je jasné, že odpor ovlivňuje *jak rychle roste proud*. Říkáme, že mezi proudem a napětím je *lineární závislost*.

Představte si například dvě různé žárovky s různým odporem žhavícího vlákna připojené ke stejnému zdroji napětí. Postupně zvyšujme napětí zdroje a sledujme, co se děje s proudem. Prvním případě (v případě odporu $$R_{\mathrm{1}}$$ první žárovky) poroste proud do spotřebiče rychleji než v případě $$R_{\mathrm{2}}$$ druhé žárovky. Z Ohmova zákona můžeme odvodit, že $$R_{\mathrm{1}} < R_{\mathrm{2}}$$. Celá situace je zachycena na obrázku níže.

![Ohmův zákon vyobrazený graficky]({{ site.url }}/imgs/ohmuv-zakon.png){: .caption}

V tomto okamžiku povídání o Ohmově zákonu ukončíme. Nerad bych vás odradil zdlouhavou teorií, Arduino je totiž hlavně o zábavě a jednoduchosti.

## Střídavý a stejnosměrný proud

Kdykoliv jsme zatím mluvili o zdroji napětí, popisovali jsme si baterii, která je založena na chemickém principu. Její svorky jsou jasně označeny a nemůže být pochyb o tom, kterým směrem teče proud a jak je orientováno napětí. Existují však i jiné zdroje napětí, například nejrůznější nabíječky, adaptéry a samozřejmě také zásuvky elektrické sítě. V čem se tyto zdroje liší?

Jednu věc mají společnou -- všechny jsou zdroje napětí a dodávají do obvodu proud. Na druhou stranu se liší ve velikosti napětí. Zatímco na bateriích jsou většinou jednotky voltů, v zásuvkách elektrické sítě je 230 V, což je mnohem více, než budeme kdy v této knize potřebovat[^4]. Dalším rozdílem je fakt, že baterie dodává napětí stejnosměrné a v elektrické síti je napětí střídavé.

[^4]: Například Arduino potřebuje ke své činnosti 5 V a k tomu nám stačí buď baterie nebo USB v počítači.

Stejnosměrné napětí má konstantní hodnotu, která se v čase nemění. Proud takového zdroje teče od kladné svorky k záporné a tento změr zůstává pořád stejný. Téměř všechny spotřebiče, od osobního počítače přes Arduino, mobilní telefony a tablety a další spotřebiče, potřebují ke své činnosti právě stejnosměrné napětí.

Naopak v zásuvkách elektrické sítě je napětí střídavé. Takové napětí během jediné vteřiny několikrát změní svůj směr i velikost. Říkáme, že v elektrické síti je sinusové napětí s frekvencí 50 Hz, což nám dává docela přesnou představu, jak takové napětí vypadá. Ve většině případů je proto nutné toto napětí nejdříve pomocí tranformátoru zmenšit na vhodnou hodnotu (například z původních 230 V na 12 V) a poté *usměrnit*. Usměrnění je proces, během kterého se z napětí střídavého vyrobí napětí stejnosměrné, které je již možné použít ve spotřebiči.

Možná vás teď napadlo, proč tedy není v zásuvkách malé stejnosměrné napětí, které je mnohem vhodnější pro většinu spotřebičů. Důvod je ryze praktický. V minulosti se totiž zjistilo, že střídavé vysoké napětí je mnohem vhodnější pro přenos na velké vzdálenosti. Pokud by z elektrárny až k vám domů vedlo stejnosměrné napětí, vznikaly by na přenosovém vedení velké ztráty, což je nejenom neekonomické, ale i nepraktické.

Pro potřeby této dokumentace nemusíme zabýhat do dalších podrobností, Arduino a veškerá digitální elektronika, kterou se budeme zabývat potřebuje napětí stejnosměrné, maximálně do 12 V. Takové napětí je bezbečné pro jakékoliv experimentování a nemůže nám za normálních okolností nijak ublížit. To ale neznamená, že si nemusíme dávat pozor. I malé napětí může v lepším případě způsobit požár, nebo vás v tom horším případě poranit! 
