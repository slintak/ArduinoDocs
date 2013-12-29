---
layout: docs
title: Knihovna Serial
prev_section: 
next_section: 
permalink: /docs/serial/
---

Knihovna `Serial` je jedna z nejpoužívanějších částí Arduina. Umožňuje
komunikaci mezi Arduinem a připojeným osobním počítačem, případně jakýmkoliv
jiným zařízením, které dokáže komunikovat po rozhraní UART. Toto rozhraní
používá dva piny RX a TX, které jsou v případě Arduino Uno na digitálních
pinech `0` a `1`.

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

**TODO:**

* Zmínit velikost bufferu,
* funkci `serialEvent()`,
* a funkce `parseFloat()`, `parseInt()`.
