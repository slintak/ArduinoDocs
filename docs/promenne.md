---
layout: docs
title: Proměnné a datové typy
prev_section: 
next_section: 
permalink: /docs/promenne/
---

Při psaní kódu pro Arduino mnohokrát narazíme na potřebu odkládat si někam
výsledky výpočtu, volání funkcí a knihoven. Arduino (a obecně všechny
mikrokontroléry) k tomuto účelu využívají paměť, které říkáme *paměť operační*,
často také *paměť RAM*. V případě Arduina je tato paměť rozdělena na 8 bitové
buňky, neboli paměťová místa. Do těchto buněk lze libovolně zapisovat a
následně z nich lze i číst.

Abychom mohli Arduinu říct, se kterou paměťovou buňkou chceme pracovat, musíme
mu dát její adresu. Adresa není nic jiného než číslo, které odkazuje na jednu
konkrétní buňku v paměti. Program Arduina pak probíhá asi nějak takhle -- ulož
číslo `123` na adresu `0x070A` a k číslu na adrese `0x00E8` přičti
jedničku[^adresy].

[^adresy]: Adresy se většinou zapisují v šestnactkové soustavě. To se pozná předponou `0x` před samotným číslem.

Abychom si zjednodušili práci a nemuseli si pamatovat desítky číselných hodnot,
vznikly v programovacích jazycích proměnné. Jsou to vlastně jména k adresám, na
kterých jsou uložená data se kterými chceme pracovat. Tato jména jsou pouze pro
nás, během překladu zdrojového kódu se jména převedou na konkrétní adresy, se
kterými pak Arduino umí pracovat.

Příklad výše by pak v programovacím jazyku mohl vypadat následovně:

{% highlight c %}
byte cislo_01 = 123;
byte cislo_02++;
{% endhighlight %}

A během překladu a následého nahrání tohoto kódu do Arduina se proměnná
`cislo_01` převede například na adresu `0x070A` a `cislo_02` na adresu
`0x00E8`.

## Vytvoření nové proměnné

Způsob, jakým se v programovacím jazyku Arduina vytvoří proměnná je následující: 

{% highlight c %}
int cislo;
{% endhighlight %} 

Tímto jsme řekli Arduinu, aby si v paměti vyhradilo prostor pro číslo o
velikosti `int` a tento prostor se bude nadále jmenovat `cislo`. Slovo `int` je
další prostředek programovacího jazyka, kterému říkáme *datový typ*. Každá
proměnná musí mít právě jeden datový typ, který přesně určuje co se do proměnné
dá uložit (číslo celé, desetinné, záporné, znak nebo řetězec znaků) a kolik
buňek bude v operační paměti zabírat. Například již zmíněný typ `int` má
velikost dva bajty (neboli 16 bitů) a lze do něj uložit záporná i kladná celá
čísla v rozsahu -32768 až 32767[^rozsah].

[^rozsah]: Z celého 16 bitového rozsahu typu `int` se 15 bitů použije na vyjádření hodnoty ($$2^{15} = 32768$$) a jeden bit bude představovat znaménko.

Dalším příkladem může být: 

{% highlight c %}
char moje_promenna_01 = 12;
{% endhighlight %} 

V tomto případě chceme vyhradit místo o velikosti (typu) `char` a zároveň do
tohoto místa uložíme číslo 12. Všimněte si, že pro jména proměnných
používáme výhradně znaky `a-z`, `A-Z`, čísla `0-9` a znak podtržítka `_`. 

Pokud chceme pracovat se znaky a ne s čísly, můžeme to provést následujícím
způsobem: 

{% highlight c %}
char znak = 'a';
{% endhighlight %} 

Do proměnné `znak` jsme uložili číslo 97, které odpovídá ASCII znaku pro
malé `a`. Co je to ASCII a jak přesně se v paměti ukládají znaky si
povíme později. Zatím si pamatujme, že pro uložení jednoho znaku se používají
jednoduché uvozovky `'`. 

Co když chceme vytvořit prostor pro více, po sobě jdoucích čísel? K tomuto
slouží hranaté závorky za jménem proměnné a této proměnné se pak říká
*pole*: 

{% highlight c %}
int vice_cisel_1[10];
int vice_cisel_2[] = {1, 3, 5, 7, 11, 13, 17};
char retezec[] = "Ahoj svete!";
{% endhighlight %} 

V prvním případě jsme si vytvořili prostor pro deset čísel typu
`int`, který ale zatím nechceme vyplnit daty. V druhém případě jsme si
vytvořili prostor pro 7 čísel a zároveň jsme do něj uložili užitečná data. V
druhém případě jsme také do hranatých závorek neuvedli délku pole. Jelikož jsme
zároveň pole vyplnili daty, délka se stanoví automaticky. Třetí příklad vytvoří
pole a uloží do něj řetězec, který obsahuje pole znaků `Ahoj svete!`. Všimněte
si použití dvojitých uvozovek `"`. 

## Základní datové typy

Jak jsme si již řekli, každá proměnná musí mít svůj datový typ, kterým můžeme
přesně určit co v proměnné bude a jak bude velká. Základní datové typy jsou v
následující tabulce:

|:---------:|:--------:|:----------------------------------------------------------:|
|   typ     | velikost |                               rozsah                       |
|           |          |         `signed`                 | `unsigned`              |
|:---------:|:--------:|:--------------------------------:|:-----------------------:|
| `char`    | 8 b      | $$-128$$ až $$127$$              | $$0$$ až $$255$$        |
| `int`     | 16 b     | $$-32768$$ až $$32767$$          | $$0$$ až $$65535$$      |
| `long`    | 32 b     | $$-2147483648$$ až $$2147483647$$| $$0$$ až $$4294967295$$ |
| `boolean` | 8 b      |                         `true` nebo `false`                |
|-----------|----------|------------------------------------------------------------|

Tyto základní datové typy jsou pro celá čísla. Tabulka obsahuje název datového
typu, počet bitů, které v paměti zaberou a jejich rozsahy. Kromě typu
`boolean`, který se používá pro uložení logických hodnot `true` (pravda,
logická jedna) a `false` (nepravda, logická nula), mají všechny ostatní typy
dvě varianty -- signed (znaménkový, lze ukládat i záporná celá čísla) a
unsigned (neznaménkový, nemůžeme do nich ukládat záporná čísla). Ukažme si
příklady použití těchto typů: 

{% highlight c %}
unsigned int cislo;
signed char zaporne_cislo = -100;
signed long pole_01[] = {-123, 12, 0, -1234567890};
unsigned char znak = 'x';
int cislo_02 = -48;
boolean pravda = true;
{% endhighlight %} 

U předposledního příkladu chybí klíčové slovo `signed` nebo `unsigned`. Toto
slovo je nepovinné a pokud jej neuvedeme, je proměnná automaticky se znaménkem. 

Podívejme se ještě na neceločíselné datové typy, které jsou v druhé tabulce. Do
takto označených proměnných lze ukládat desetinná čísla. Jejich nevýhodou je
velká paměťová náročnost a také se oproti celočíselným typům mnohem déle
sčítají, odčítají i násobí. Navíc, jejich reálná přesnost je v Arduinu
přibližně 6 až 7 desetinných míst. Pokud používáte Arduino Uno nebo
Mega, datový typ `double` je totožný s typem `float`. Zabírá v paměti pouze
32b. `Double` má smysl používat pouze s deskou Arduino Due. 

|:--------:|:--------:|:----------------------------------------------------:|
|    typ   | velikost |                     rozsah                           |
|:--------:|:--------:|:----------------------------------------------------:|
| `float`  |   32 b   | $$3{,}4\cdot 10^{38}$$ až $$3{,}4\cdot 10^{38}$$     |
| `double` |   64 b   | $$-1{,}7\cdot 10^{308}$$ až $$1{,}7\cdot 10^{308}$$  |
|----------|----------|-----------------------------------------------------|

A pár příkladů:

{% highlight c %}
float cislo_03 = 12.5;
float cislo_04 = -0.0012;
{% endhighlight %} 


Je také potřeba si uvědomit, že práce s desetinnými čísly není přesná. Nebudeme
zbytečně zabíhat do detailů, pamatujte si ale, že výraz $$\frac{8{,}0}{2{,}0}$$
nám nemusí vrátit výsledek $$4{,}0$$. Kvůli zaokrouhlování během výpočtu se
může stát, že výsledek bude třeba $$3{,}99987$$. Kdykoliv jde použít
celočíselný datový typ, použijte raději ten a typům jako `float` a `double` se
vyhněte. 

## Velikost datových typů

Pokud vlastníte desky Uno, Nano, Mega a podobné (vpodstatě jakoukoliv desku,
která obsahuje mikrokontrolér z rodiny AVR, tedy NE desky Due, Yún, apod.), pak
vše co jsme si řekli výše platí. Jestli se teprve s Arduinem seznamujete a téma
proměnných a datových typů je pro vás nové, doporučuji zbytek tohoto textu
zatím přeskočit a pokračovat dále. Později se k tomuto textu můžete kdykoliv
vrátit.

Velikosti základních datových typů, které jsme si ukázali v tabulkách výše,
platí pouze pro Arduina, která obsahují mikrokontroléry z rodiny AVR. Pokud
někdy v budoucnu přejdete na desku Due (případně na úplně jinou platformu než
je Arduino), která obsahuje MCU z rodiny ARM, pak jsou velikosti a tedy i
jejich rozsahy uplně jiné.

Na vině není samotné Arduino, ani firma Atmel, která MCU AVR vyrábí. Problém je
v programovacím jazyku C/C++, který používáme. Jazyk C totiž striktně
nespecifikuje velikost základních datových typu, vše záleží na použité
architektuře. Například datový typ `int` má na AVR velikost 16 bitů, ale pro
rodinu ARM nebo x86 je to 32 bitů. V případě jiných architektur to může být
ještě jinak.

Není to chyba jazyka, jak by se na první pohled mohlo zdát, je to spíše jeho
vlastnost. Pokud chceme psát kód, který bude přenositelný i na jiné platformy,
který půjde použít na desce Uno, Due i jinde, pak je nutné s touto vlastností
jazyka počítat. Co ale když opravdu nutně potřebujete vytvořit proměnnou o
přesně dané velikosti? 

K tomuto účelu slouží hlavičkový soubor `<stdint.h>`, který je součástí tzv. standardní knihovny jazyka C. Na začátku vašeho kódu stačí tento soubor includovat:

{% highlight c %}
#include <stdint.h>
{% endhighlight %}

a od této chvíle lze používat typy jako:

{% highlight c %}
// 8 bitový integer
int8_t    // znaménkový
uint8_t   // neznaménkový

// 16 bitový integer
int16_t   // znaménkový
uint16_t  // neznaménkový

// 32 bitový integer
int32_t   // znaménkový
uint32_t  // neznaménkový

// a další...
{% endhighlight %}

včetně užitečných konstant jako:

{% highlight c %}
INT8_MAX  // Maximální hodnota typu int8_t
INT8_MIN  // Minimální hodnota typu int8_t
UINT8_MAX // Maximální hodnota typu uint8_t

// a další
{% endhighlight %}

Více podrobností a seznam všech typů a konstant pro architekturu AVR viz [Standard Integer Types, nongnu.org](http://www.nongnu.org/avr-libc/user-manual/group__avr__stdint.html).
