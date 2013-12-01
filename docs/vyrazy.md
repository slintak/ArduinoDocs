---
layout: docs
title: Výrazy a operátory
prev_section: promenne
next_section: 
permalink: /docs/vyrazy/
---

Nyní již víme jak se data ukládají do proměnných a jak se taková proměnná
vytvoří. V této sekci budeme s proměnnými dále pracovat. 

Mějme proměnné ``cislo_a``, ``cislo_b`` a ``cislo_c``, které jsou typu
*signed int* (tedy znaménkové celé číslo):

{% highlight c %}
signed int cislo_a = 1;
signed int cislo_b = 2;
signed int cislo_c;
{% endhighlight %} 

Nyní chceme první dvě proměnné sečíst a jejich výsledek uložit do třetí. Možná
už vás napadlo jak na to: 

{% highlight c %}
cislo_c = cislo_a + cislo_b; // Výsledek je 3
{% endhighlight %} 

A to je vše, této konstrukci se v jazyce C říká *výraz*. Každý výraz má levou
stranu, znak rovná se, pravou stranu a na konci řádku středník. Pravá strana
pak může obsahovat libovolně složitý výpočet využívající operátory jazyka.

Odčítání, násobení i dělení je obdobné a stejně jednoduché: 

{% highlight c %}
cislo_c = cislo_a - cislo_b; // Výsledek: -1
cislo_c = cislo_a * cislo_b; // Vysledek: 2
cislo_c = cislo_a / cislo_b; // Výsledek: 0 (!)
{% endhighlight %} 

U posledního výrazu se zastavme. Výsledek po dělení je desetinné číslo --
$$\frac{1}{2} = 0{,}5$$. Do proměnné ``cislo_c`` se však uloží nula. Z pohledu
programovacího jazyka i Arduina je vše v pořádku. Chtěli jsme přece dělit dvě
celá čísla a výsledek uložit opět do celočíselné proměnné. Nám ale tento
výsledek bude pravděpodobně vadit, očekáváme přece výsledek 0,5. Možným řešením
je použít pro všechny tři proměnné typ ``float``[^float]. To je sice možné, ale
tím pádem se nám mnohonásobně zpomalí výpočet všech ostatních operací --
sčítání, odčítání i násobení. V tomto případě je mnohem vhodnější uložit do
neceločíselné proměnné pouze výsledek po dělení: 

[^float]: Tedy datový typ pro desetinná čísla.

{% highlight c %}
float cislo_d = cislo_a / cislo_b; // Výsledek: 0 (!)
{% endhighlight %} 

Co se stalo? I přes to, že je ``cislo_d`` desetinné, je výsledek stále nula, což
je očividně špatně. Problém je tentokrát ve způsobu, jakým Arduino výraz
vyhodnocuje. Nejdříve načte z paměti obsah proměnné ``cislo_a``, potom
``cislo_b``. Obě proměnné jsou celočíselné, chceme dělit, použije se tedy
celočíselné dělení[^deleni]. My ale víme, že výsledek bude desetinný a to
musíme Arduinu vhodným způsobem sdělit. Programovací jazyk nám k tomuto dává
prostředek, kterému se říká *přetypování*. Jak již název napovídá, je to změna
jednoho typu na druhý.  Výraz výše tak můžeme zapsat následujícím způsobem: 

[^deleni]: Zatím nemáme dostatek znalostí, abychom si mohli vysvětlit podrobnosti. Stručně řečeno -- Arduino má více možností jak dělit nebo násobit čísla. Rychlejší je celočíselná varianta, mnohem pomalejší a méně přesnější je desetinná varianta. Kdykoliv to jde, volí se varianta pro celá čísla.

{% highlight c %}
// Správně, výsledek: 0,5
float cislo_d = (float)cislo_a / cislo_b;
{% endhighlight %} 

Konečně jsme obdrželi správný výsledek. Proměnná ``cislo_a`` se nejdříve
přetypuje na typ ``float`` a teprve až poté se z paměti načte ``cislo_b`` a
provede dělení. 

Možná vás napadlo provést přetypování proměnné následujícím způsobem: 

{% highlight c %}
int cislo_a = 5;
float cislo_a; // Chyba, nejde o přetypování
{% endhighlight %} 

Tento zápis je chybný a nejde o přetypování. V jazyce C nemůžeme na jednom
místě vytvořit proměnnou a na druhém ji chtít vytvořit znovu s jiným typem.
Jméno každé proměnné musí být jedinečné v celém úseku kódu, ve kterém je
proměnná viditelná.

**TODO: Odkaz na kapitolu "viditelnost proměnných".**

Tímto jsme si vysvětlili přetypování a nutnost volit vždy správný datový typ,
podle očekávaného výsledku. Vraťme se teď zpátky k popisu výrazů. 

Znaky ``+``, ``-``, ``*`` a ``/`` pro jednotlivé operace se souhrně označují
*operátory*. Říkáme například, že znak hvězdičky ``*`` je *operátor násobení*.
V dalším textu si podrobně probereme všechny typy operátorů, které nám jazyk C
nabízí.

## Aritmetické operátory

Většinu aritmetických operátorů již známe. Jsou to 

* ``+`` → sčítání
*  ``-`` → odčítání
* ``*`` → násobení
* ``/`` → dělení
* ``=`` → přiřazení
* ``%`` → zbytek po dělení

První 4 operátory jsme si již ukázali a jsou nám dobře známé z hodin matematiky
na základní škole. Pátý operátor, znak *rovná se* jsme již používali, ale
neřekli jsme si že se jedná o *operátor přiřazení*. Tento operátor nedělá nic
jiného, než že přiřadí hodnotu do proměnné: 

{% highlight c %}
cislo_a = 5;
cislo_a = cislo_b;
float cislo_e = 3.14;
float cislo_f = 3.14 / cislo_b;
{% endhighlight %} 

Můžeme říct, že operátor přiřazení *vezme* výraz na své pravé straně, vyhodnotí
jej (spočítá) a výsledek přiřadí (uloží) do proměnné na levé straně. 

Posledním aritmetickým operátorem je znak procenta ``%``. Jedná se o *dělení
modulo*, neboli zbytek po dělení. Nejlépe si jeho funkci ukážeme na příkladu: 

{% highlight c %}
cislo_a = 5;
cislo_b = 2;
int vysledek = cislo_a / cislo_b; // Výsledek: 2
int zbytek = cislo_a % cislo_b; // Výsledek: 1
{% endhighlight %} 

Operátor modulo je zbytek po celočíselném dělení a hodí se například pro
určování dělitelnosti. Pokud chceme zjistit, jestli je číslo sudé nebo liché,
použijeme k tomu modulo: 

{% highlight c %}
int sude_01 = 8 % 2; // Výsledek: 0
int sude_02 = 12 % 2; // Výsledek: 0
int sude_03 = 128 % 2; // Výsledek: 0
int liche_01 = 9 % 2; // Výsledek: 1
int liche_02 = 315 % 2; // Výsledek: 1
{% endhighlight %} 

## Operátory porovnávání

Kromě šesti aritmetických operátorů existují ještě operátory pro porovnávání.
Těch je také šest a jsou to: 

* ``==`` → rovná se
* ``!=`` → nerovná se
* ``>`` → větší než
* ``<`` → menší než
* ``>=`` → větší nebo rovno
* ``<=`` → menší nebo rovno 

Výsledek výrazu, který obsahuje některý z těchto operátorů je vždy typu
``boolean``, takže nabývá pouze hodnot ``true``, pravda nebo ``false``,
nepravda. Na levé i pravé straně těchto operátorů mohou být konstanty, proměnné
nebo další výrazy: 

{% highlight c %}
boolean porovnani = 5 < 1; // Výsledek: false
porovnani = 5 > 1; // Výsledek: true
porovnani = 5 < 5; // Výsledek: false
porovnani = 5 <= 5; // Výsledek: true 

int cislo = 11;
porovnani = 5 < cislo; // Výsledek: true
porovnani = 5 == (cislo - 6); // Výsledek: true
{% endhighlight %} 

Ve všech příkladech se výraz na pravé straně od operátoru přiřazení vyhodnotí a
výsledek, který může být buď *pravda* nebo *nepravda* se uloží do proměnné na
levé straně. Například na posledním řádku dojde k následujícímu: nejdříve se
načte z paměti proměnná ``cislo`` a odečte se od ní konstanta ``6``. Poté se
tento výsledek porovná v konstantou ``5``. Jelikož platí, že ``5 ==  (11 -
6)``, výraz je pravdivý a do proměnné *porovnani* se uloží hodnota ``true``. 

Tyto operátory se často používají v kombinaci s podmíněnými skoky, které si
budeme vysvětlovat v kapitole **TODO: odkaz na podmíněné skoky**.

## Logické operátory

Nyní se pojďme podívat na tzv. *logické operátory*. Zatímco aritmetické
operátory většinou pracují s datovými typy pro celá (``int``, ``long``, atd.)
nebo desetinná (``float``) čísla, logické operátory slouží pro práci s
proměnnými typu ``boolean``. 

* ``&&`` → logický součin (AND)
* ``||`` → logický součet (OR)
* ``!`` → logická negace (NOT) 

Opět si je ukážeme na příkladech. Představme si, že máme malého robůtka, který
dokáže jezdit dopředu a dozadu (proměnné ``vpred`` a ``vzad``) a má k dispozici
dva senzory přiblížení (proměnné ``prekazka_vepredu`` a ``prekazka_vzadu``).
Robůtek jede dopředu dokud je proměnná ``pohyb = true`` a zastaví se v
okamžiku, kdy před sebou detekuje překážku ``prekazka = true``. 

{% highlight c %}
boolean stuj = prekazka_vzadu || prekazka_vepredu;
{% endhighlight %} 

Využili jsme operátor pro logický součet. Celý výraz je pravdivý, pokud alespoň
jedna z proměnných je pravdivá. Pokud chce robůtek zjistit jestli se má
zastavit, načte proměnné ze senzorů ``prekazka_vepredu`` a ``prekazka_vzadu`` a
provede nad nimi logický součet (OR). Slovně bychom si mohli první výraz napsat
následovně: Pokud je ``prekazka_vepredu`` pravda *nebo* ``prekazka_vzadu``
pravda, bude ``stuj`` také pravda, jinak nepravda. Situaci si můžeme přiblížit
ještě na tzv. *pravdivostní tabulce* (viz tabulka níže), která se často používá
při vyhodnocování logických výrazů. 

|:---------------------:|:--------------------:|:---------:|
| Operace OR                                               |
| ``prekazka_vepredu``  |  ``prekazka_vzadu``  |  ``stuj`` |
|:---------------------:|:--------------------:|:---------:|
| ``true``              |  ``true``            |  ``true`` |
| ``true``              |  ``false``           |  ``true`` |
| ``false``             |  ``true``            |  ``true`` |
| ``false``             | ``false``            | ``false`` |
|:---------------------:|:--------------------:|:---------:|

Přidejme našemu robůtkovi světelný senzor (například fotorezistor). Pokud se na
robota posvítí, proměnná ``svetlo`` se nastaví na hodnotu ``true``, jinak bude
``false``. Chceme dosáhnout, aby robot kontroloval překážky před sebou a za
sebou pouze když se na něj svítí. 

{% highlight c %}
boolean prekazka = prezka_vzadu || prekazka_vepredu;
boolean stuj = prekazka && svetlo;
boolean pohyb = !stuj;
{% endhighlight %} 

V tomto příkladu jsme již využili všechny tři operátory. Logický součin (AND)
na druhém řádku je pravdivý pouze pokud jsou obě jeho strany také pravdivé.
Můžeme napsat: pokud je ``prekazka`` pravda *a zároveň* je ``svetlo``
pravda, bude ``stuj`` pravda. Takže pokud se na robota svítí a zároveň narazil
na překážku, zastaví. Tuto situaci a zároveň funkci AND ilustruje další tabulka 
níže. Je tedy zřejmé, že pokud se na robota svítit nebude,
bude ``stuj`` vždy ``false``, bez ohledu na přítomnost překážek. 

|:------------:|:----------:|:---------:|
| Operace AND                           |
| ``prekazka`` | ``svetlo`` | ``stuj``  |
|:------------:|:----------:|:---------:|
|  ``true``    |  ``true``  | ``true``  |
|  ``true``    |  ``false`` | ``false`` |
|  ``false``   |  ``true``  | ``false`` |
|  ``false``   |  ``false`` | ``false`` |
|:------------:|:----------:|:---------:|

Tímto jsme ale získali výraz pro zastavení robota (``stuj``) a my chtěli
zjistit kdy se má pohybovat. K tomu nám poslouží logická negace (NOT), která je
na třetím řádku příkladu a její možné stavy pak ukazuje tabulka
níže. Jak je vidět, výsledkem negace je vždy opačný stav
oproti vstupní proměnné. 

|:---------:|:---------:|
| Operace NOT           |
| ``stuj``  | ``pohyb`` |
|:---------:|:---------:|
| ``true``  | ``false`` |
| ``false`` | ``true``  |
|:---------:|:---------:|

Tyto operátory se často využívají v kombinaci s operátory pro porovnávání.
Pokud bychom našemu robůtkovi přidali navíc senzor vzdálenosti, který
vrací vzdálenost od překážky v centimetrech jako celé číslo typu
``unsigned int`` (v proměnné ``vzdalenost``), pak můžeme napsat třeba
takovéto podmínky: 

{% highlight c %}
boolean vpred = !prekazka_vpredu && (vzdalenost > 15) && ! svetlo;
boolean vzad = !prekazka_vzadu && !svetlo;
boolean pohyb = vpred || vzad;
{% endhighlight %} 

Téměř celý příklad by nám měl být jasný. Jediná novinka je na prvním řádku. V
závorce je použit operátor porovnávání ``vzdalenost > 15``. Jak jsme si
řekli v předchozí sekci, výsledkem tohoto výrazu je buď ``true`` nebo
``false``, a proto je možné tyto operátory používat společně s logickými
operátory. 

První řádek tak můžeme interpretovat následujícím způsobem: robot se bude
pohybovat vpřed pouze pokud před ním není překázka a zároveň se na něj nesvítí
a zároveň je vzdálenost od nejbližší překážky větší jak 15 centimetrů. 

## Bitové operátory

Nyní se dostáváme k předposlední skupině operátorů, které lze v programovacím
jazyce C použít. Jsou to tzv. *bitové operátory* a jak již název
napovídá, pracují s jednotlivými bity v proměnné[^bool].

[^bool]: Datový typ proměnné ale musí být vždy celočíselný, například ``byte``, ``int``, atd.

Z předchozí kapitoly víme, jak se data ukládají do paměti a také jak se dá
zapsat libovolné číslo do dvojkové soustavy. Právě znalost dvojkové soustavy je
nutná pro pochopení této skupiny operátorů. 

Bitových operátorů je celkem šest: 

* ``&`` → bitový součin (AND)
* ``|`` → bitový součet (OR)
* ``~`` → bitová negace (NOT)
* ``^`` → exkluzivní disjunkce (XOR)
* ``<<`` → bitový posun vlevo
* ``>>`` → bitový posun vpravo 

Dobrá zpráva je, že tři z nich již známe. Bitový součin, součet a negace jsou
velmi podobné svým protějškům ze skupiny logických operátorů. Pravdivostní
tabulky, které jsme si ukázali již dříve pro logický součin, součet a negaci
platí i zde. Jediný rozdíl jsou datové typy. Zatímco logické operátory pracují
s typy ``boolean``, bitové mohou fungovat s libovolným celočíselným typem.
Mějme dvě proměnné, které nabývají hodnot deset a šest. Ty můžeme jednoduše
přepsat do dvojkové soustavy a ukázat si na nich bitový AND, OR a NOT: 

$$
\begin{array}{rrr} & 1010 & (10) \\ \& & 0110 & (6) \\ \hline & 0010 & (5)\end{array},\;\;\;
\begin{array}{rrr} & 1010 & (10) \\ | & 0110 & (6) \\ \hline & 1110 & (14)\end{array},\;\;\;
\begin{array}{rrr} & & \\ \sim & 1010 & (10) \\ \hline & 0101 & (5)\end{array}
$$

Bitové operátory *prochází* celé číslo bit po bitu a provádí požadovanou
operaci podle pravdivostních tabulek. Podívejme se například na operátor ``&``
(AND). Jeden konkrétní bit výsledku je roven jedné pouze pokud jsou
odpovídající bity vstupů také jedna. U operátoru ``|`` (OR) je to stejné, s tím
rozdílem, že bit ve výsledku je jedna v případě, že je jednička alespoň v
jedném z obou vstupů. Vstupem operátoru ``~`` (NOT) je pouze jedna proměnná a
výsledkem je její *opačná* hodnota. Slovem opačná je v tomto případě myšleno
*opačná bit po bitu*.   

Ukažme si nyní tyto příklady na typu ``unsigned char``, který jak již víme má
délku 8 bitů. Použijeme stejné vstupy jako v přechozím příkladu. Jediný rozdíl
je ten, že místo 4 bitů musí Arduino vyhodnotit 8 bitů. Pokud bychom použili
``unsigned int``, opět by byl výsledek stejný, jenom by se použilo 16
bitů. 

{% highlight c %}
unsigned char A = 10;
unsigned char B = 6; 

unsigned char C = A & B; // Výsledek: 2
unsigned char D = A | B; // Výsledek: 14
unsigned char E = ~A; // Výsledek: 5
{% endhighlight %} 

Z těchto tří operátorů je asi nejvíce užitečný bitový AND. Ten se často používá
k tzv. *maskování* nepotřebných bitů v proměnné. Představte si, že máte k
Arduinu připojen obvod reálného času DS1307. To je integrovaný obvod, který
počítá aktuální datum a čas a tyto informace z něj pak lze Arduinem přečíst.
Část odpovědi obsahuje jeden bajt, ve kterém jsou uloženy aktuální počet hodin,
informace o tom, jestli je odpoledne nebo dopoledne a informace v jakém formátu
hodiny jsou (12 nebo 24 hodinový formát). Tuto situaci ilustruje obrázek: 

| 0 | 12/24 | AM/PM | H | H | H | H | H |

Řekněmě, že je 7 hodin večer a hodiny se ukládají ve 12 hodinovém formátu.
Arduino pak z obvodu DS1307 přečte následující bajt: 

| 0 | 12/24 | AM/PM | H | H | H | H | H |
| 0 | 0 | 1 | 0 | 0 | 1 | 1 | 1 |

Uložme si jej do proměnné ``cas`` a poté pomocí bitové operace AND získejme
jednotlivé informace: 

{% highlight c %}
unsigned char format = cas & 0x40;
unsigned char odpoledne = cas & 0x20;
unsigned char hodiny = cas & 0x1F;
{% endhighlight %} 

Zápis v šestnáctkové soustavě je sice běžný, ale nepříliš přehledný pro
začátečníka. Rozepišme si situaci podrobněji:  

$$
\begin{array}{rr} & 00100111 \\ \& & 01000000 \\ \hline & 00000000 \\ & ``format`` \end{array},\;\;\;
\begin{array}{rr} & 00100111 \\ \& & 00100000 \\ \hline & 00100000 \\ & ``odpoledne`` \end{array},\;\;\;
\begin{array}{rr} & 00100111 \\ \& & 00011111 \\ \hline & 00000111 \\ & ``hodiny`` \end{array}
$$

Druhému číslu, které používáme k vymaskování dat se říká *maska*. Ten bit,
který nás v datech zajímá a chceme aby byl i ve výsledku, nastavíme v masce na
jedničku. Všechny ostatní bity, které ve výsledku nemají co dělat nastavíme na
nulu. Z principu funkce bitového AND je zřejmé, že tam kde je v masce nula bude
nula i ve výsledku, nezávisle na tom, jaká hodnota byla v původních datech. 

V našem případě pak můžeme prohlásit, že pokud je ``format`` roven nule, jsou
data v 12 hodinovém formátu. Naopak, pokud je ``format`` roven 0x40 (nebo v
desítkové soustavě 64), jsou data v 24 hodinovém formátu. Pokud je odpoledne,
je ``odpoledne = 0x20``, jinak ``odpoledne = 0x00``. Data uložena v ``hodiny``
pak odpovídají přímo aktuálním hodinám, v našem případě 7 odpoledne. 

Pojďme se nyní podívat na čtvrtý bitový operátor — *exkluzivní disjunkce*,
často také nazývaný *XOR*. Nelekněte se složitě znějícího názvu, samotná
operace je jednoduchá. Tabulka ilustruje pravdivostní tabulku XORu. Tato
operace je rovna jedné pouze pokud je na vstupu právě jedna jednička. Pokud jsou
na vstupech obě hodnoty stejné, je výsledek nula.

|:-:|:-:|:---:|
| A | B | XOR |
|:-:|:-:|:---:|
| 0 | 0 |  0  |
| 0 | 1 |  1  |
| 1 | 0 |  1  |
| 1 | 1 |  0  |
|:-:|:-:|:---:|

Ukažme si ještě příklad v programovacím jazyce:

{% highlight c %}
unsigned char A = 10; // 1010
unsigned char B = 6; // 0110
unsigned char C = A ^ B; // Výsledek: 12, 1100
{% endhighlight %} 

Jedna zajímavost tohoto operátoru: pokud xorujeme dvě stejná čísla, nebo jedno
číslo samo sebou, výsledek bude vždy nula. Naopak, pokud provedeme XOR nad
číslem a jeho negací, bude výsledek obsahovat samé jedničky. 

{% highlight c %}
unsigned char A = 42;
unsigned char B = A ^ A; // Výsledek: 0, 00000000
unsigned char C = A ^ ~A; // Výsledek: 255, 11111111
{% endhighlight %} 

A k čemu je tento operátor dobrý? XOR se často používá pro jednoduchý
*kontrolní součet*. To je trochu pokročilé téma a v našich začátcích s Arduinem
se s tímto nesetkáme, ale je dobré jej znát. Představte si situaci, kdy si
někam ukládáte naměřená data[^data]. Řekněme, že se jedná o data z malé
meteorologické stanice a každou hodinu ukládáte teplotu, vlhkost, tlak a úroveň
okolního světla. Data se ukládají jako 4 čísla, třeba typu ``long``, tedy
$$4\times32$$ bitů. Jak si ale po uložení můžete být jisti, že se data přenesla a
uložila bez chyb? Co když během přenosu na kartu nebo do paměti došlo k chybě a
místo 20 stupňu Celsia uložíte -20? Jak tuto chybu odhalíte při pozdějším čtení
a reprezentaci dat? K tomu slouží technika zvaná *kontrolní součet*. V podstatě
se vezmou všechna data, která ukládáte a třeba pomocí XORu se sečtou dohromady.
Výsledek se pak uloží jako páté číslo na kartu. Pokud při zápisu dojde k chybě,
kontrolní součet se nebude shodovat a vy, při čtení dat víte, že máte tento
konkrétní údaj zahodit, protože je špatný.

[^data]: Na SD kartu, do EEPROM paměti, nebo přes Internet na váš web.

Máme před sebou poslední dva bitové operátory. Jsou jimi bitový posun vlevo a
vpravo. Jejich funkce je zřejmá z názvu: vezme se požadované číslo a bit po
bitu se posune o daný počet doleva nebo doprava. 

$$
\begin{array}{rr}00010000 & (0x10) \\ \gg 1 &  \\ \hline 00001000 & (0x08)\end{array},\;\;\;
\begin{array}{rr}00010000 & (0x10) \\ \ll 1 &  \\ \hline 00100000 & (0x20)\end{array}
$$

Nebo zápis v jazyce Arduina:

{% highlight c %}
unsigned char A = 0x40; // 01000000
unsigned char B = A >> 1; // Výsledek: 0x20, 00100000 

unsigned char A = 0xAA; // 10101010
unsigned char B = A >> 2; // 0x2A, 00101010
{% endhighlight %} 

Bitové posuny se často využívají společně s maskováním. Připomeňme si příklad z
obvodem reálného času DS1307: 

{% highlight c %}
unsigned char format = 00000000;
unsigned char odpoledne = 00100000;
unsigned char hodiny = 00000111;
{% endhighlight %} 

Na proměnné ``format`` a ``odpoledne`` můžeme použít bitový posun doprava: 

{% highlight c %}
format = format >> 6; // Výsledek: 0
odpoledne = odpoledne >> 5; // Výsledek: 1
{% endhighlight %}

## Složené operátory

A konečně poslední skupina operátorů jsou tzv. *složené operátory*. Mám
pro vás dobrou zprávu -- tato skupina neobsahuje nic nového, všechny tyto
oprátory již známe a umíme používat. Jsou to vpodstatě zkratky, které nám
ulehčí psaní kódu. Patří sem: 

* ``++`` → inkrementace
* ``--`` → dekrementace
* ``+=`` → sčítání
* ``-=`` → odčítání
* ``*=`` → násobení
* ``/=`` → dělení
* ``&=`` → bitový součin
* ``|=`` → bitový součet 

Jejich použití a funkci si nejlépe ukážeme na příkladech: 

{% highlight c %}
unsigned char cislo = 10; 

cislo++; // Výsledek: 11
cislo--; // Výsledek: 10
cislo *= 2; // Výsledek: 20
cislo /= 10; // Výsledek: 2
cislo |= 0x80; // Výsledek: 130
cislo &= 0x07; // Výsledek: 2
{% endhighlight %} 

Všechny tyto příklady můžeme přepsat i bez použití složených operátorů. Na
první pohled by se tak mohlo zdát, že jsou tyto operátory nadbytečné, ale brzy
zjistíte, že výrazne ulehčují zápis a zpřehledňují kód: 

{% highlight c %}
unsigned char cislo = 10; 

cislo = cislo + 1; // Výsledek: 11
cislo = cislo - 1; // Výsledek: 10
cislo = cislo * 2; // Výsledek: 20
cislo = cislo / 10; // Výsledek: 2
cislo = cislo | 0x80; // Výsledek: 130
cislo = cislo & 0x07; // Výsledek: 2
{% endhighlight %} 

A to je vše. Tímto jsme ukončili povídání o operátorech. Na závěr ještě několik
poznámek. 

Dejte si pozor na operátory ``&&``, ``||`` a ``&``, ``|``. První dvojice jsou
operátory logické, pracující nad ``boolean`` a druhá dvojice je bitová,
pracující nad jednotlivými bity v proměnných. Jejich záměna způsobí naprosto
nevhodné výsledky, které zaručeně neočekáváte. 

Všechny operátory mají svoji *prioritu*. To znamená, že pokud se sejde více
operátorů v jednom výrazu (na jednom řádku), budou se některé operátory
vyhodnocovat dříve než druhé. Změna tohoto pořadí je možná pomocí závorek. Toto
si určitě si pamatujete ze základní školy: 

{% highlight c %}
int cislo_01 = 12 + 128 * 0; // Výsledek: 12
int cislo_02 = (12 + 128) * 0; // Výsledek: 0 

int cislo_03 = 5 * cislo_02++; // Výsledek: 5
int cislo_04 = (5 * cislo_02)++; // Výsledek: 1 

boolean vyraz_01 = 12 * 2 >= 24; // Výsledek: true
boolean vyraz_02 = true & (2 >= 24); // false
{% endhighlight %} 

Obecně platí, že pokud si nejste jisti, který operátor má přednost před kterým,
použijte závorky. Doporučuji abyste používali závorky i v případě, že jste si
jistí. Závorkami nic nezkazíte, naopak zvýšíte čitelnost kódu a zmenšíte riziko
chyb, kterých se u složitějších výrazů určitě dopustíte. 

Pokud máte stále problémy s pochopením bitových operátorů a převody mezi
desítkovou, šestnáctkovou a dvojkovou soustavou vám stále trvají dlouho,
napište si vše potřebné na kus papíru (pravdivostní tabulky pro AND, OR, XOR i
převody mezi soustavami pro čísla 0 až 15). Časem, jak budete tyto věci stále
používat si vše zapamatujete. 
