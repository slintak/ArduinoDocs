---
layout: docs
title: Vývojové prostředí Arduina
prev_section: 
next_section: 
permalink: /docs/arduino-ide/
---

Úspěch Arduina a jeho velké rozšíření není jenom díky zajímavému hardwaru, ale
především jednoduchému vývojovému prostředí (zkráceně *IDE*, což doslova
znamená *Integrated Development Environment*). Arduino IDE je aplikace, která
nám umožní jednoduše s deskou Arduino pracovat.

Arduino IDE obsahuje mimo jiné textový editor a několik tlačítek, které slouží
k překladu (*verify*) a následnému nahrání kódu do Arduina (*upload*). Dále je
součástí prostředí nástroj *serial monitor*, který umožňuje jednoduchou
komunikaci s Arduino deskou (na straně hardware k tomuto účelu pak slouží
[knihovna Serial](/docs/serial/).

## Instalace a první spuštění

Instalační soubor pro platformu Windows, Linux nebo Mac OS X lze nalézt na
oficiálním webu Arduino.cc v sekci
[downloads](http://arduino.cc/en/Main/Software). Instalace je přímočará a velmi
jednoduchá. Na operačním systému Windows můžete stáhnout buď instalátor, který
se postará o vše potřebné nebo ZIP soubor, který stačí rozbalit do libovolného
adresáře v počítači. Pod operačním systémem Mac OS X pak stačí balíček
*Arduino.app* zkopírovat do adresáře */Applications/*.

![Hlavní obrazovka vývojového prostředí]({{site.url}}/imgs/arduino-ide.png){: .caption}

Po prvním zapnutí je potřeba projít nastavení, které Arduino IDE nabízí.
Otevřete proto okno s nastavením (*preferences*) a nastavte adresář kam se
budou ukládat vaše projekty. Tento adresář je důlěžitý, dále mu budeme říkat
*pracovní adresář*. V originále se nazývá *sketchbook*. To proto, že projektům
v Arduinu se říká *sketch*, což česky znamená *skica* nebo *náčrtek*. V této
dokumentaci budeme ale místo *sketch* používat *projekt*.

![Okno s nastavením]({{site.url}}/imgs/arduino-settings.png){: .caption}

## Pracovní adresář a jeho struktura

Všechny projekty se tedy budou ukládat do pracovního adresáře. Každý projekt má
svou podsložku, která se jmenuje stejně jako projekt. V ní pak můžeme nalézt
zdrojové kódy s příponou `.ino` nebo `.pde`[^pripona]. Pro ilustraci a lepší
pochopení, jak Arduino IDE ukládá projekty je níže malá ukázka:

[^pripona]: Přípona `.ino` je novější a standardně se používá pro všechny projekty vytvořené v Arduino IDE verze 1.0 a vyšší. Přípona `.ide` je starší a dnes se již nepoužívá.

{% highlight bash %}
C:/cesta/k/pracovnimu/adresari/
  ./MujProjekt/
    ./MujProjekt.ino
  ./Test/
    ./Test.ino
  ./Komplikovany_Projekt/
    ./Komplikovany_Projekt.ino
    ./funkce.cpp
    ./funkce.h
  ./libraries/
  ./hardware/
{% endhighlight %}

Náš pracovní adresář obsahuje celkem 3 projekty s názvy `MujProjekt`, `Test` a
`Komplikovany_Projekt`. Tento poslední projekt obsahuje ve svém podadresáři
více souborů s příponami `.cpp` a `.h` (k čemu slouží a jak s nimi pracovat si
povíme jindy, je to pokročilé téma).

V pracovním adresáři jsou ale ještě dva podadresáře o kterých jsme si zatím nic
neřekli -- `libraries` a `hardware`. Tyto podadresáře v našem pracovním
prostoru mohou ale i nemusí být, jsou nepovinné. Pokud ale v pracovním adresáři
jsou, Arduino IDE je při startu kontroluje a čte jejich obsah.

### Uživatelské knihovny

Jak již název napodívá, ve složce `libraries` v našem pracovním adresáři se
mohou nacházet knihovny, které si uživatel (tedy my) přeje ve svých projektech
používat. Na internetu lze totiž nalézt velké množství knihoven pro nejrůznější
senzory, moduly a shieldy, které Arduino IDE nemá standardně ve své výbavě.
Dejme tomu, že si koupíte teplotní čidlo *DS18B20* a na webu naleznete knihovnu
která s ním dokáže komunikovat. Adresář s knihovnou pak stačí zkopírovat právě
do podsložky `libraries/` a restartovat Arduino IDE. Od toho okamžiku půjde
novou knihovnu nalézt v menu *Sketch->Import Library* a pokud knihovna obsahuje
i ukázkové kódy, tak ty jsou v menu *File->Examples*.

![Menu obsahující seznam všech instalovaných knihoven]({{site.url}}/imgs/arduino-libraries.png){: .caption}

Nově, od verze Arduino IDE 1.0.5, existuje ještě jednodušší možnost jak
nainstalovat novou knihovnu. Stačí v menu *Sketch->Import Libraries* kliknout
na položku *Add Library* a zvolit ZIP soubor s knihovnou, který jste stáhli z
internetu.

### Podpora nového hardware

Ještě nám zbývá popsat si k čemu slouží adresář `hardware/`.

V základu dokáže Arduino IDE pracovat s deskami (neboli hardwarem):

* Arduino Uno
* Arduino Duemilanove
* Arduino Nano
* Arduino Mega
* Arduino Leonardo
* Arduino Esplora
* Arduino Mini
* Arduino Ethernet
* Arduino Fio
* LilyPad Arduino
* ...

<div class="note info">
  <h5>Arduino Yún a Due</h5>
  <p>Pokud vlastníte Arduino Yún nebo Due, musíte si nainstalovat Arduino 1.5, které je momentálně ve verzi BETA. Více informací na oficiálním webu Arduina.</p>
  <p><em>O těchto nových deskách bych rád napsal samostatnou kapitolu, bohužel ale zatím ani jednu z nich nevlastním.</em></p>
</div>

Co ale když máte hardware, který v seznamu není? To se může nejčastěji stát
stavitelům 3D tiskárny RepRap, případně majitelům nějaké neoficiální desky jako
je například *Calunium*.

V takovém případě stačí do adresáře `hardware/` zkopírovat složku s definicí
nové desky, kterou stáhnete z internetu. Po restartu Arduino IDE se nový
hardware objeví k menu *Tools->Boards*.

## Náš první program

Nyní již známe vše potřebné, abychom úspěšně naprogramovali Arduino a spustili
náš první program.

Zapněte Arduino IDE a připojte k počítači vaši desku. Předpokládejme, že se
jedná o Arduino Uno[^jine-verze]. V menu *File->Examples->Basics* vyberte
příklad s názvem *Blink*, který stále dokola bliká LED, která je připojena na
digitálním pinu č. 13.

[^jine-verze]: Pokud máte jinou desku, např. Nano nebo Mega, nic se neděje. Stačí v menu *Tools->Boards* vybrat tu vaši.

Nyní stačí v Arduino IDE kliknout na tlačítko *upload* (tlačítko s obrázkem
šipky doprava). Aplikace na pozadí přeloží zdrojový kód a následně se jej
pokusí nahrát do Arduina. Pravděpodobně se vám zobrazí okno s výběrem sériového
portu ke kterému je Arduino připojeno. Na operačním systému Windows se port
jmenuje `COMx`, například `COM3`, pod Unixovými operačními systémy to bude
`/dev/tty.xxx`, například `/dev/tty.usbmodem641`.

![Okno s výběrem sériového portu]({{site.url}}/imgs/arduino-port.png){: .caption}

Pokud jste vybrali správný port, měly by začít diody `RX` a `TX` na desce
Arduina okamžitě blikat. To indikuje, že počítač komunikuje s deskou. Jakmile
tyto diody přestanou blikat, v Arduino IDE se objeví ve spodní části oznámení
*Done...*. V tomto okamžiku je program nahraný v Arduinu a vy byste měli vidět
pomalu blikat oranžovou diodu.
