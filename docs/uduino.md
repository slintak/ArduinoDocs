---
layout: page
title: Arduino na nepájivém poli
permalink: /docs/uduino/
---

Pro první experimenty jsou oficiální Arduino desky plně dostačující, jelikož
většina prvních projektů které začátečník realizuje jsou jednoduché hříčky,
které jsou realizovány na nepájivém poli. Každý začátečník ale jednou z těchto
jednoduchých projektů *vyroste* a začne přemýšlet, jak realizovat něco
trvalejšího.

Bez ohledu na to, jaký projekt budete chtít realizovat, použít plnohodnotnou
Arduino desku ve finálním výrobku je neekonomické a navíc technicky zbytečné
(zabírá velkou plochu, má velkou spotřebu, ...). Dobrá zpráva je, že Arduino
lze velmi jednoduše realizovat na nepájivém poli nebo na univerzálním plošném
spoji a stačí k tomu cca 6 součástek.

Nejprve se podívejme na schéma oficiální desky Arduina Una a ukažme si, které
části obvodu jsou zbytečné (zbytečné samozřejmě nejsou, jenom pro nás na
nepájivém poli nejsou důležité).

![Kompletní schéma desky Arduino Uno R3]({{site.url}}/imgs/arduino-breadboard-schm.png){: .caption}

Je důležité si uvědomit, že celé zapojení je minimalizované jen na
nejnutnější součástky. Na nepájivém poli tak sice vznikne obvod kompatibilní s
Arduinem Unem, který půjde programovat pomocí Arduino IDE (anebo pomocí
Makefile), ale neobsahuje žádné ochranné prvky. Je tedy potřeba dávat veký
pozor na velikost a polaritu napájecího napětí, na zkraty a podobně.

![Arduino kompatibilní obvod s minimálním počtem součástek na nepájivém poli]({{site.url}}/imgs/arduino-breadboard-min.png){: .caption}

Kondenzátor C4 umístěte co nejblíže mikrokontroléru, funguje jako blokovací
kondenzátor vůči vysokofrekvenčním signálům, které se mohou v obvodu objevit.
Na schématu výše je zakresleno výsledné zapojení.

Na schématu jsou dvě součástky, které jsou *navíc*. Tzn. nejsou povinné a pokud je vynecháme, nic se neděje. Jsou to `LED1` a rezistor `R1`. Tato LED je připojena k pinu `PB5`, což na Arduinu odpovídá digitálním pinu `D13`.

![Kompletní zapojení na nepájivém poli. Obvod je napájen 5 V z připojeného UART převodníku.]({{site.url}}/imgs/arduino-breadboard-foto.jpg){: .caption}

![Značení pinů mikrokontroléru ATMega vs. Arduino Uno]({{site.url}}/imgs/arduino-breadboard-pinout.png){: .caption}

**TODO**:

* Podrobněji se rozepsat o zapojení,
* ukázat sestavení na univerzální DPS,
* podrobně jak se programuje,
* jak nahrát bootloader do MCU,
* UART převodník a jak ho použít,