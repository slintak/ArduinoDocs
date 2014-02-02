---
layout: page
title: Arduino na nepájivém poli
permalink: /docs/uduino/
---

Pro první experimenty jsou oficiální Arduino desky plně dostačující, jelikož
většina projektů které začátečník realizuje jsou jednoduché hříčky,
které jsou realizovány na nepájivém poli. Každý začátečník ale jednou z těchto
jednoduchých projektů *vyroste* a začne přemýšlet, jak realizovat něco
trvalejšího.

Bez ohledu na to, jaký projekt budete chtít vytvořit, použít plnohodnotnou
Arduino desku ve finálním výrobku je neekonomické a navíc technicky zbytečné
(zabírá velkou plochu, má velkou spotřebu, ...). Dobrá zpráva je, že Arduino
lze velmi jednoduše realizovat na nepájivém poli nebo na univerzálním plošném
spoji a stačí k tomu cca 6 součástek.

Nejprve se podívejme na schéma oficiální desky Arduina Una a ukažme si, které
části obvodu jsou zbytečné (zbytečné samozřejmě nejsou, jenom pro nás na
nepájivém poli nejsou důležité).

![Kompletní schéma desky Arduino Uno R3]({{site.url}}/imgs/arduino-breadboard-schm.png){: .caption}

Toto kompletní schéma Arduina obsahuje kromě samotného mikrokontroléru a ještě
obvod pro stabilizaci napájecího napětí, obvod pro komunikaci s osobním
počítačem přes USB (převodník USB-UART) a množství konektorů, které usnadňují
práci během vývoje.


## Schéma zapojení

Pokud z oficiální desky Arduina odstraníme konektory, obvod pro stabilizaci
napájení i obvod pro komunikaci s osobním počítačem, vznikne nám malý obvod
obsahující asi 6 součástek. Jeho schéma je na obrázku níže

![Arduino kompatibilní obvod s minimálním počtem součástek na nepájivém poli]({{site.url}}/imgs/arduino-breadboard-min.png){: .caption}

Je důležité si uvědomit, že celé zapojení je minimalizované jen na
nejnutnější součástky. Na nepájivém poli tak sice vznikne obvod kompatibilní s
Arduinem Unem, který půjde programovat pomocí Arduino IDE (anebo pomocí
Makefile), ale neobsahuje žádné ochranné prvky. Je tedy potřeba dávat veký
pozor na velikost a polaritu napájecího napětí, na zkraty a podobně.

Kondenzátor C4 umístěte co nejblíže mikrokontroléru, funguje jako blokovací
kondenzátor vůči vysokofrekvenčním signálům, které se mohou v obvodu objevit.

Na schématu jsou dvě součástky, které jsou *navíc*. Tzn. nejsou povinné a
pokud je vynecháme, nic se neděje. Jsou to `LED1` a rezistor `R1`. Tato LED je
připojena k pinu `PB5`, což na Arduinu odpovídá digitálním pinu `D13`.

![Kompletní zapojení na nepájivém poli. Obvod je napájen 5 V z připojeného UART převodníku.]({{site.url}}/imgs/arduino-breadboard-foto.jpg){: .caption}

## Seznam potřebných součástek

Ještě jednou si přehledně vypíšeme seznam potřebných součástek k sestavení
obvodu kompatibilního s Arduinem:

* `R2` -- rezistor 10 kΩ
* `C1` -- keramický kondenzátor 100 nF
* `C2` -- keramický kondenzátor 22 pF
* `C3` -- keramický kondenzátor 22 pF
* `C4` -- keramický kondenzátor 100 nF
* `Q1` -- krystal 16 MHz
* `U1` -- mikrokontrolér ATMega328P

Pokud budete k minimálnímu Arduinu chtít připojit i LED k digitálnímu pinu
D13, pak ještě potřebujete:

* `R1` -- rezistor 1 kΩ
* `LED1` -- zelená LED

Pozor, mikrokontrolér ATMega328P musí mít ve své paměti nahraný bootloader,
viz text dále.

![Ze všech součástek je nejdůležitější ATMega328P]({{site.url}}/imgs/uduino-soucastky.jpg){: .caption}

## Programování pomocí Arduino IDE

Nyní máme na nepájivém poli sestaven obvod, který můžeme nazvat například
*miniaturní Arduino*. Abychom jej mohli programovat pomocí Arduino IDE, je
nutné k obvodu připojit převodník USB na UART. To je obvod, který se na straně
osobního počítače chová jako sériová linka. Cokoliv na tuto linku pošleme se
*objeví* na jeho výstupu jako série bajtů. Arduino IDE bude tento převodník
využívat k naprogramování mikrokontroléru.

![Ukázka USB-UART převodníku vhodného k programování *minimálního Arduina*]({{site.url}}/imgs/uart-prevodnik.jpg){: .caption}

K tomuto účelu můžete zvolit vpodstatě libovolný UART převodník. Jediná
podmínka je, aby měl vyveden pin s označením DTR, který použijeme k resetu
Arduina. Převodník na obrázku výše má tento pin vyveden na horní straně desky,
na pinu vlevo označeném písmeny `J3`.

Tento převodník se připojí k Arduinu následujícím způsobem:

* `RX` na převodníku k pinu `PD0` na ATMega,
* `TX` na převodníku k pinu `PD1` na ATMega,
* `GND` na převodníku k `GND` na ATMega,
* `5V` na převodníku k `VCC` na ATMega,
* `DTR` na převodníku ke kondenzátoru `C1`.

Poslední řádek je nejdůležitější. Signál `DTR` z převodníku je potřeba
připojit ke kondenzátoru `C1`, jehož druhý vývod je připojen k
mikrokontroléru. To způsobí, že poté co v Arduino IDE klikneme na tlačítko
*upload*, mikrokontrolér se automaticky restartuje a poté i naprogramuje.

V tomto okamžiku ještě jednou zkontrolujte správnost celého zapojení včetně
UART převodníku a pokud je vše v pořádku, připojte převodník k osobnímu
počítači. Pokud připojujete převodník poprvé a používáte operační systém
Windows, je pravděpodobné že bude potřeba nainstalovat ovladače.

Teď již stačí spustit Arduino IDE, vybrat program který chceme do Arduina
nahrát a kliknout na tlačítko *upload*. Pokud je vše zapojeno bez chyby,
programování proběhne až do konce.

## Značení pinů mikrokontroléru

Oficiální deska Arduino Uno používá k označení digitálních pinů písmeno `D` a
čísla od 0 do 13. K označení analogových pinů je to písmeno `A` a čísla 0 až
5. V katalogovém listu mikrokontroléru ATMega328P toto označení ale nenajdete.

Následující obrázek nám ulehčí orientaci v tom, který pin odpovídá kterému
číslu.

![Značení pinů mikrokontroléru ATMega vs. Arduino Uno]({{site.url}}/imgs/arduino-breadboard-pinout.png){: .caption}

## Bootloader neboli zavaděč

Srdcem Arduina Una a našeho zjednodušeného zapojení je mikrokontrolér
ATMega328P. Tento MCU od firmy Atmel má celkem 32 kB paměti flash do které se
programuje uživatelský kód. Od výroby je tato paměť prázdná a k jejímu
naprogramování slouží tzv. programátor. Originální Arduino však tento
programátor nepoužívá, místo něj si vystačí jenom v převodníkem USB-UART. Jak
docílit toho, aby se stejně choval i náš mikrokontrolér?

Mikrokontroléry v deskách Arduina obsahují na konci paměti flash speciální
kód, kterému se říká bootloader. Ten je spouštěn po resetu MCU a kontroluje,
jestli se uživatel snaží komunikovat po rozhraní UART. Pokud ne, spustí se
uživatelský kód na začátku paměti flash. Pokud ale uživatel po resetu odešle
na UART speciální sekvenci znaků, mikrokontrolér začne z UARTu číst data a sám
sebe programovat. Jak to celé funguje není pro nás příliš zajímavé, pokud
byste se o tomto procesu chtěli dozvědět více, můžete si přečíst článek
[bootloader v mikrokontrolérech AVR](http://uart.cz/721/bootloader-v-avr/).

Z předchozího odstavce si zapamatujme jedno: aby se ATMega328P chovala stejně
jako Arduino, musí mít v paměti bootloader. Bez něj nebude naše *minimální
Arduino* na nepájivém poli vůbec fungovat.

ATMega328P s Arduino bootloaderem se dá sehnat dvěma způsoby:

* buď si ji koupíme s již nahraným bootloaderem
* nebo si do ní bootloader sami naprogramujeme.

První variantu doporučuji začátečníkům. Druhá varianta je pro zkušenější
uživatele kteří navíc vlastní AVR programátor.

Nejdříve sestavte *minimální Arduino* na nepájivém poli a poté k němu připojte
ISP programátor. Pomocí něj nahrajte do mikrokontroléru HEX soubor s
bootloaderem -- najdete jej v [oficiálním Git repozitáři Arduina ve složce `bootloaders/optiboot`](https://github.com/arduino/Arduino/tree/master/hardware/arduino/bootloaders/optiboot). Je to soubor `optiboot_atmega328.hex`.

Zároveň naprogramujte následující fuses:

* HFUSE = 0xDE
* LFUSE = 0xFF
* EFUSE = 0x05

Tyto fuses v MCU aktivují bootloader sekci, externí 16 MHz krystal a další.

Pokud se vše podařilo, máme nyní na stole plně funkční obvod s ATMega328P,
který se dá programovat přes USB-UART převodník pomocí Arduino IDE.

**TODO**:

* podrobně jak se programuje,
* jak nahrát bootloader do MCU,
