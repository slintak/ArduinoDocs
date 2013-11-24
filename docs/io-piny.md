---
layout: docs
title: Vstupně výstupní piny
prev_section: 
next_section: 
permalink: /docs/io-piny/
---

Arduino nabízí množství digitálních i analogových pinů, které můžeme ve svých
projektech použít k libovolnému účelu. Většinu techto pinů lze použít jak pro
vstup tak i pro výstup. Kromě toho mají některé z nich i další funkce, které
lze jednoduše aktivovat ve zdrojovém kódu. V dalším textu bude podrobněji
popsáno jak se s jednotlivými piny pracuje a ukážeme si i jejich další funkce.

## Digitální vstup a výstup

Téměř všechny piny Arduina lze použít jako digitální vstup nebo výstup. Jejich
směr lze přepnout zavoláním funkce a to v libovolném okamžiku. To znamená, že
jeden pin může jednu chvíli sloužit jako vstup a poté i jako výstup (možná vás
teď nenapadá k čemu by to bylo dobré, ale občas se to opravdu hodí). Jelikož se
jedná o *digitální* piny, napětí na nich je Arduinem interpretováno pomocí dvou
logických hodnot -- `HIGH` a `LOW`, neboli *pravda* a *nepravda*, často také
*logická jedna* a *nula*.

Arduino pracuje s pozitivní TTL logikou. Logická jedna, `HIGH`, je
reprezentována napětím blízkým napájecímu (v případě verze Uno je to 5 V, v
případě Nano pak 3,3 V) a logická nula, `LOW`, je napětí blízké 0 V.
Následující jednoduchý kód způsobí, že na pinu číslo 13 bude logická jedna a
tedy na pinu lze pomocí voltmetru naměřit 5 V a na pinu č. 12 bude logická
nula, voltmetr naměří 0 V:

{% highlight c %}
void setup() {
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);

  digitalWrite(12, LOW);
  digitalWrite(13, HIGH);
}

void loop() {
}
{% endhighlight %}

Ve funkci setup je na prvních dvou řádcích zavolána funkce `pinMode()`, která
nastaví směr digitálního pinu (`OUTPUT` neboli výstup a `INPUT` neboli vstup) a
která očekává dva parametry -- nejdříve číslo pinu který chceme nastavit a pak
samotný směr.

Na dalších dvou řádcích je pak volána funkce `digitalWrite()`, kterou se dá u
výstupních pinů nastavit jejich logická hodnota. Funkce opět očekává dva
parametry -- nejdříve číslo pinu který chceme měnit a pak logická hodnota.

Poté co tento kód nahrajete do Arduina si můžete vzít do ruky voltmetr a změřit
napětí na pinech 12 a 13. Změřené hodnoty by vás již v tomto okamžiku neměli
překvapit a měli byste chápat proč tomu tak je. Teď už zbývá si ukázat jak na
vstupní piny.

{% highlight c %}
void setup() {
  pinMode(12, INPUT);
  pinMode(13, OUTPUT);
}

void loop() {
  int tlacitko = digitalRead(12);
  if(tlacitko) {
    digitalWrite(13, HIGH);
  } else {
    digitalWrite(13, LOW);
  }

  delay(100);
}
{% endhighlight %}

Příklad výše bude opakovaně kontrolovat logickou hodnotu na pinu 12, který jsme
nastavili jako vstupní. Pokud je na pinu napájecí napětí (tedy logická jedna)
na pinu 13 se okamžitě objeví logická jedna (pokud k tomuto pinu připojíme LED
s rezistorem, dioda se rozsvítí). Ihned jak k pinu 12 připojíme 0 V (GND), LED
zhasne.

### Více digitálních I/O pinů

V případě, že potřebujete více digitálních pinů než obsahuje vaše verze Arduina, je možné použít i analogové vstupy (běžně označené jako `Analog in` nebo `Analog`). Práce s nimi je úplně stejná jako s digitálními vstupy/výstupy, pouze s tím rozdílem, že ve fukcích `pinMode()`, `digitalWrite()` a `digitalRead()` musíte před číslo pinu vložit písmeno `A`.

V následujícím příkladu použijeme analogový vstup `A0` jako digitální výstup:

{% highlight c %}
void setup() {
  // Nastavíme směr pinu A0 na výstup.
  pinMode(A0, OUTPUT);

  // Nastavíme A0 na log. jedničku.
  digitalWrite(A0, HIGH);

  // Pokud chceme později s A0 pracovat jako
  // s analogovým vstupem, stačí změnit směr
  // na vstup před použitím analogRead()
  pinMode(A0, INPUT);
  int hodnota = analogRead(A0);
}

void loop() {
}
{% endhighlight %}

### Interní pull-up rezistory

Digitálním pinům nastaveným na vstup lze připojit interní pull-up rezistor. To znamená, že uvnitř mikrokontroléru Arduina se zapojí rezistor mezi napájecí napětí a nožičku pinu tak, jak je znázorněno na schématu níže.

![Blokové schéma MCU Arduina zobrazující interní pull-up rezistor]({{site.url}}/imgs/arduino-pullup.png){: .caption}

Softwarové zapnutí pull-up rezistoru ilustruje následující příklad:

{% highlight c %}
void setup() {
  // Nastavíme směr pinu 3 na vstup
  pinMode(3, INPUT);
  // Aktivujeme pull-up
  digitalWrite(3, HIGH);

  // Nyní můžeme s pinem normálne pracovat.
  // Jakmile budeme chtít pull-up vypnout,
  // stačí zavolat funkci:
  digitalWrite(3, LOW);
}

void loop() {
}
{% endhighlight %}

S pull-up rezistory lze pracovat pouze u digitálních pinů nastavených jako vstupní.

## Analogový vstup a výstup

Ne vždy si v elektronice vystačíme jen s digitálním vstupem/výstupem. Relativně
často je potřeba pracovat s analogovým (spojitým) signálem. Arduino nám sice
práci s nimi maximálně zjednodušuje, ale i tak je potřeba vědět několik
důležitých faktů.

Analogový vstup umožňuje 10 bitový, 6 kanálový AD převodník[^1], který je
součástí mikrokontroléru Arduina. Pro analogový vstup lze tedy využít piny
označené jako `A` nebo `Analog`, kterých je celkem šest. ADC dokáže převádět
napětí v rozsahu 0 až 5 V na digitální číslo (konkrétně na typ `unsigned int`)
se kterým pak můžeme v našem projektu dále pracovat.

[^1]: Používaná zkratka je *ADC* neboli *analog-to-digital converter*. Ve starší české literatuře se můžete setkat ještě s *AČ* neboli *analogově číslicový* převodník.

Ukažme si to na jednoduchém příkladě -- na analogovém vstupu `A0` bude
připojena prostřední nožička $$10\;\textrm{k}\Omega$$ potenciometru. Zbylé dva
piny potenciometru připojíme k pinům `VCC` a `GND`. Tím jsme vytvořili dělič
napětí. Otočením hřídele potenciometru se změní napětí na prostřední nožičce a
tím pádem i na analogovém vstupu Arduina.

Následující zdrojový kód bude číst analogovou hodnotu, kterou použijeme ke
změně rychlosti blikání LED na digitálním pinu 13.

{% highlight c %}
void setup() {
  // Nastavíme pin 13 jako výstupní.
  // Na tomto pinu je připojena LED.
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);

  // Aktivuj sériové rozhraní,
  // rychlost 9600 baudů.
  Serial.begin(9600);
}

void loop() {
	// Přečti analogovou hodnotu z pinu č. A0.
	int rychlost = analogRead(0);
	Serial.println(rychlost);

	// Zapni LED.
	digitalWrite(13, HIGH);
	// Počkej 0 až 1023 ms.
	delay(rychlost);
	// Vypni LED.
	digitalWrite(13, LOW);


	delay(1000);

}
{% endhighlight %}

Poté, co nahrajete tento kód do Arduina, můžete měnit rychlost s jakou LED
problikne otočením hřídele potenciometru. Zároveň můžeme pomocí *serial
monitoru* v Arduino IDE sledovat jaké hodnoty jsme načetli v analogového pinu.
Budou vždy v rozmezí od 0 do 1023 (tedy celkem 1024 možných hodnot).

Toto číslo reprezentuje hodnotu napětí, které je přítomno na analogovém pinu.
Pokud chceme vědět jeho přesnou hodnotu ve voltech, přepočet je následující:

$$
U = \frac{VCC}{2^{10}} \cdot x = \frac{5}{1024} \cdot x\;\;[\textrm{V}]
$$

kde $$x$$ je analogová hodnota, kterou jsme načetli pomocí funkce
`analogRead()` (v našem případě proměnná `rychlost`) a $$VCC$$ je napájecí
napětí Arduina (v případě verze Uno je to 5 V).

Tento vztah nám také říká, jaké nejmenší napětí jsme schopni s Arduinem
rozlišit -- $$5/1024 = 4{,}88\;\textrm{mV}$$. Tato přesnost je většinou
dostatečná. Pokud budeme chtít snímat napětí na poteciometru nebo jakémkoliv
běžném senzoru, analogový vstup Arduina a funkce `analogRead()` nám bude
stačit.

**TODO**:

* analogový výstup,
* změna referenčního napětí u ADC.

![PWM neboli analogový výstup z Arduina]({{ site.url }}/imgs/arduino-pwm.png){: .caption}
