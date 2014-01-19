---
layout: docs
title: Knihovna Serial
prev_section: 
next_section: 
permalink: /docs/serial/
---

Knihovna `Serial` umožňuje ovládat rozhraní UART a zároveň je to jedna z
nejpoužívanějších částí Arduina. Umožňuje komunikaci mezi Arduinem a
připojeným osobním počítačem, případně jakýmkoliv jiným zařízením, které
dokáže komunikovat po UARTu. Toto rozhraní používá dva piny RX a TX,
které jsou v případě Arduino Uno na digitálních pinech `0` a `1`.

Komunikace je obousměrná a vysílání dat může zahájit kterákoliv strana. To
znamená, že Arduino i počítač může začít posílat data ihned a nemusí čekat na
žádné potvrzení od druhé strany. Z toho vyplývá několik omezení, které si
povíme později. Nyní se podívejme, jak se knihovna používá.

## Základní použití

Tento jednoduchý příklad každou vtěřinu odešle řetězec *Ahoj svete!* do
připojeného počítače, kde je možné tato data přečíst.

{% highlight c %}
void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.println("Ahoj svete!");
  delay(1000);
}
{% endhighlight %}

Po nahrání tohoto kódu do Arduina klikněte na ikonku *Serial Monitor*, které
je v pravé části Arduino IDE. Otevře se vám podobné okno  jako na obrázku
níže. Ujistěte se, že v pravé části okna je zvolena rychlost *9600 baud*.
Pokud vše funguje, v Serial Monitoru se každou vteřinu zobrazí nový řádek se
stejným textem.

![Okno *Serial Monitor* Arduino IDE]({{site.url}}/imgs/arduino-serial-monitor.png){: .caption}

Z tohoto příkladu je důležité si pamatovat:

* Pokud chcete knihovnu `Serial` používat, musíte ji *aktivovat* zavoláním funkce `Serial.begin(rychlost)`.
* Rychlost komunikace se udává v baudech a je to celé kladné číslo, viz dále.
* Rychlost komunikace musí být na obou stranách (na Arduinu i na PC) stejná. Pokud se bude lišit, data se ztratí.
* K odeslání řetězce z Arduina do PC slouží funkce `Serial.println(retezec)`.

## Příjem a vysílání

Nyní se podívejme na malinko složitejší příklad. Nyní budeme chtít, aby
Arduino všechna přijatá data okamžitě odeslalo zpět do PC.

{% highlight c %}
void setup() {
  Serial.begin(9600);
}

void loop() {
  // Přijali jsme nějaká data?
  if(Serial.available()) {
    // Přijmi jeden znak z UARTu.
    char znak = Serial.read();

    // Odešli odpověď
    Serial.print("Prijal jsem znak: ");
    Serial.println(znak);
  }
}
{% endhighlight %}

Po naprogramování opět otevřete Serial Monitor a nastavte správnou baud
rychlost. Nyní do řádku vedle tlačitka *Send* napište jakýkoliv znak a
zmáčkněte *Enter* nebo klikněte na tlačítko *Send*. Arduino okamžitě odpoví
větou *Prijal jsem znak: x*.

Z tohoto Příkladu je důležité: 

* k příjmu jednoho znaku slouží funkce `Serial.read()`,
* funkce `Serial.print()` funguje stejně jako `Serial.println()`, pouze s tím rozdílem, že na konci řetězce nepošle znak nového řádku,
* pro kontrolu, jestli Arduino přijalo nějaká data slouží funkce `Serial.available()`, která vrátí `TRUE` pokaždé, když jsou k dispozici nějaká data.

## Rychlost

Jak jsme si již řekli, `Serial` využívá rozhraní UART. To je zkratka, která
znamená *universal asynchronous receiver/transmitter*, tedy *univerzální
asynchronní přijímač/vysílač*. Slovo asynchronní v tomto případě znamená, že
se data vysílají bez hodinového signálu. Jedna strana jednoduše vysílá data o
předem dané rychlosti. Pokud je druhá strana má správně přijmout, je důležité
aby znala přesnou rychlost s jakou byla vyslána.

V případě UARTu se rychlost udává v baudech (baud), což je v případě Arduina
počet bitů za vteřinu. Pokud tedy zvolíte rychlost 9600 baudů, odpovídá to
rychlosti 9600 b/s neboli 1200 B/s neboli 1,2 kB/s.

Další nejčastěji používané rychlosti jou: 2400, 4800, **9600**, 14400,
**19200**, 28800, **38400**, 57600, **76800**, 115200. Tučně jsou zvýrazněný
ty rychlosti, které doporučuji používat na Arduinech s krystalem 16 MHz.

Arduino totiž odesílá data tak, že z hodinové frekvence odvozuje dobu trvání
jednotlivých bitů, které pak v určitých okamžicích odesílá po rozhraní UART. V
případě verze Arduino Uno to znamená, že se doba odvozuje od frekvence
krystalu 16 MHz. Jednoduchým dělením této frekvence zjistíme, že některé
rychlosti jsou vhodnější a některé ne. Pokud např. zvolíme rychlost 115200
baudů, bude chyba v čase až 3,5%, což může v některých případech způsobit
ztrátu nebo poškození dat. Více o tomto tématu naleznete v [datasheetu
ATMega328P](http://www.atmel.com/Images/doc8161.pdf) v sekci 20.3.

## Příjem dat a příchozí buffer

Jak jsme si již na začátku řekli, rozhraní UART používá dvě signálové cesty,
nazývané RX a TX. Každá z obou připojených stran může zahájit komunikaci a
vyslat tolik dat, kolik potřebuje. Z toho vyplývá, že příjem dat druhou
stranou není nijak zaručen. My můžeme z osobního počítače odeslat klidně
tisíce znaků, ovšem pokud Arduino *neposlouchá* a data neukládá, jsou ztracena
a my se o tom nikdy nedozvíme. Jelikož je Arduino řádově mnohem pomalejší než
dnešní PC, je nutné na toto omezení pamatovat.

Příjem dat na straně Arduina probíhá následovně: každý znak, který na UART
odešleme způsobí na straně Arduina přerušení. To znamená, že právě vykonávaný
kód ve funkci `loop()` se dočasně pozastaví, z UARTu se načte jeden znak do
paměti (bufferu) a pak se opět začne vykonávat kód v `loop()` od místa kde k
přerušení došlo.

Obsluhu přerušení a ukládání přijatých dat do bufferu za nás řeší knihovna
Serial na *pozadí*. Pokud je příchozí buffer plný, knihovna začne přepisovat
nejstarší přijatá data a tím pádem dojde k jejich ztrátě.

Naší povinností (pokud o data nechceme přijít) je pravidelně ve funkci
`loop()` (nebo ve funkci `serialEvent()`, viz dále) kontrolovat, jestli jsou k
dospozici nějaká data a případně s nimi provést smysluplnou akci. K této
kontrole slouží funkce `available()` a pracuje se s ní následovně:

{% highlight c %}
chat znak;

void setup() {
  Serial.begin(9600);
}

void loop() {
  // Jakýkoliv užitečný kód.
  // ...

  if(Serial.available()) {
    // Jsou k dispozici data.
    // Načti jeden znak.
    znak = Serial.read();
  }

  // Další užitečný kód.
  // ...
}
{% endhighlight %}

Během jednoho průchodu funkcí `loop()` načteme vždy jeden znak a následně s
ním můžeme něco užitečného udělat.

Pokud cheme načítat více znaků, kód se mírně změní:

{% highlight c %}
char znak;
String retezec = "";         // Buffer, řetězec na příchozí data

void setup() {
  Serial.begin(9600);
  // Připraví v paměti prostor pro 200 znaků.
  inputString.reserve(200);
}

void loop() {
  // Jakýkoliv užitečný kód.
  // ...

  while (Serial.available()) {
    // Jsou k dispozici data.
    // Načti jeden znak.
    char znak = Serial.read(); 
    // Přidej ho do bufferu
    retezec += znak;
  }

  // Další užitečný kód.
  // ...

  // Vyprázdni buffer s přijatým řetězcem
  retezec = "";
}
{% endhighlight %}

V tomto případě máme po skončení cyklu `while` v proměnné `retezec` celý
řetězec přijatých znaků se kterým můžeme dále pracovat.

## Více rozhraní UART

Arduino Uno má jedno hardwarové rozhraní UART na digitálních pinech `0` a `1`.
Toto rozhraní je zároveň připojeno k UART převodníku a tím pádem přes USB k
PC. Pokud bychom chtěli komunikovat s PC a zároveň i s jiným zařízením po
UARTu, Arduino Uno nebude stačit[^swserial].

[^swserial]: Abychom byli přesní, bude stačit i Arduino Uno. Můžeme totiž ještě použít knihovnu *Software Serial*.

Některá Arduina mají i více hardwarových rozhraní UART. Například Arduino Mega
má celkem 4. Pro komunikaci s PC se používá `Serial` a platí vše co jsme si
již řekli. Pro práci s dalším UART rozhraním slouží `Serial1` (piny 18 a 19),
`Serial2` (piny 16 a 17) a `Serial3` (piny 14 a 15). Všechny tyto rozhraní se
používají stejně:

{% highlight c %}
void setup() {
  Serial.begin(9600);
  Serial1.begin(19200);
  Serial2.begin(38400);
  Serial3.begin(76800);
}

void loop() {
  Serial.println("Ahoj svete!");
  Serial1.println("Ahoj svete 1!");
  Serial2.println("Ahoj svete 2!");
  Serial3.println("Ahoj svete 3!");
  delay(1000);
}
{% endhighlight %}

Pro Arduino Due platí to samé jako pro Mega, pouze s tím rozdílem, že se
nepoužívá napětí 5 V ale 3,3 V. U Arduina Leonardo je pouze jeden *Serial*.

## Funkce *serialEvent()*

Knihovna *Serial* poskytuje zajímavou funkci `serialEvent()`. Tato funkce se
zavolá automaticky, pokud Arduino přijalo nějaká data. Funkci `serialEvent()`
nespouští přerušení, ale volá se až po dokončení jednoho průchodu funkce
`loop()`. To znamená, že pokud hlavní programová smyčka obsahuje časově
náročný kód nebo spoustu funkcí `delay()`, bude zpracování dat z UARTu
pomalejší.

Tento jednoduchý příklad ukazuje jak se s funkcí `serialEvent()` pracuje.
Arduino bude přijatá data ukládat do paměti a jakmile načte znak nového řádku
`\n`, vytiskne načtený řetězec zpět.

{% highlight c %}

String inputString = "";         // Buffer, řetězec na příchozí data
boolean stringComplete = false;  // Je řetězec kompletní?

void setup() {
  // Nastav rychlost UARTu na 9600 baudů.
  Serial.begin(9600);
  // Připraví v paměti prostor pro 200 znaků.
  inputString.reserve(200);
}

void loop() {
  // Pokud jsme načetli znak nového řádku, bude proměnná
  // `stringComplete` nastavena na `TRUE`.
  if (stringComplete) {
    // Vytiskni načtená data
    Serial.println(inputString); 
    // Vyprázdni buffer.
    inputString = "";
    stringComplete = false;
  }
}

void serialEvent() {
  while (Serial.available()) {
    // Přečti jeden přijatý znak.
    char inChar = (char)Serial.read(); 
    // Přidej ho do bufferu
    inputString += inChar;
    // Řetězec je kompletní jakmile přijmeme znak nového řádku
    if (inChar == '\n') {
      stringComplete = true;
    } 
  }
} 
{% endhighlight %} 

Tento způsob práce s rozhraním UART se hodí zejména v případech, kdy nechceme
přijatá data zpracovávat ihned, ale *až bude čas* nebo *až načteme dostatečný
počet znaků*.

Pamatujte si, že funkce `serialEvent()` se nevykonává paralelně s `loop()`,
ani není spouštěna asynchronně pomocí přerušení.

<div class="note info">
  <h5>Arduino Esplora, Leonardo a Micro</h5>
  <p>Tato funkce není v současné době kompatibilní s deskami Esplora, Leonardo a Micro. Na těchto deskách nebude fungovat.</p>
</div>

## Funkce pro příjem čísel

Ve světě Arduina se po rozhraní UART nejčastěji posílají textová data, tedy
řetězce obsahující pouze znaky ASCII (`a` až `z`, `A` až `Z`, `0` až `9` a
další speciální znaky, které obsahuje ASCII tabulka). Pokud z počítače
odešleme například řetězec:

{% highlight c %}
"Cisla: 123, 456, 9010"
{% endhighlight %}

Arduino přijme celkem 21 znaků. Pokud chceme s tři výše uvedenými čísly
pracovat jako s čísly a ne jako s řetězcem, je nutné je nejdříve
překonvertovat na správný typ, v našem příkladě na `int`. Knihovna Serial nám
k tomu poskytuje funkci `parseInt()`, která v přijatém řetězci hledá první
výskyt znaků `0` až `9` a ty poté konvertuje na číslo:

{% highlight c %}
void setup() {
  Serial.begin(9600);
}

void loop() {
  while(Serial.available()) {
    int cislo1 = Serial.parseInt(); 
    int cislo2 = Serial.parseInt(); 
    int cislo3 = Serial.parseInt();
  }

    // Nyní máme v proměnných následující obsah
    //   cislo1 = 123
    //   cislo2 = 456
    //   cislo3 = 9010
    // a lze s nimi pracovat jako s typem int.
} 
{% endhighlight %} 

Případně pokud očekáváme desetinná čísla (ovšem pozor, musí obsahovat
desetinnou tečku, ne čárku) můžeme použít funkci `parseFloat()`:

{% highlight c %}
void setup() {
  Serial.begin(9600);
}

void loop() {
  while(Serial.available()) {
    float cislo1 = Serial.parseFloat(); 
  }
    // ...
} 
{% endhighlight %} 

Tyto funkce jsou užitečné v případech, kdy jsme si jisti, že data do Arduina
chodí ve správném formátu. To jsou např. situace kdy si sami z PC odesíláme
předem připravená data a jsme si na 100% jistí, že mají správný formát.

Pokud načítáte data z cizího zdroje (aplikace v PC, jiné zařízení, druhé
Arduino, ...) nespoléhejte se na jejich správnost a vždy se snažte data
validovat a v případě, že jsou chybná tak zahodit. Toto pokročilé téma bude
popsáno v jiné části této dokumentace.
