---
layout: docs
title: Vstupně výstupní piny
prev_section: 
next_section: 
permalink: /docs/io-piny/
---

Arduino nabízí množství digitálních i analogových pinů, které můžeme ve svých projektech použít k libovolnému účelu. Většinu techto pinů lze použít jak pro vstup tak i pro výstup. Kromě toho mají některé z nich i další funkce, které lze jednoduše aktivovat ve zdrojovém kódu. V dalším textu bude podrobněji popsáno jak se s jednotlivými piny pracuje a ukážeme si i jejich další funkce.

## Digitální vstup a výstup

Téměř všechny piny Arduina lze použít jako digitální vstup nebo výstup. Jejich směr lze přepnout zavoláním funkce a to v libovolném okamžiku. To znamená, že jeden pin může jednu chvíli sloužit jako vstup a poté i jako výstup (možná vás teď nenapadá k čemu by to bylo dobré, ale občas se to opravdu hodí). Jelikož se jedná o *digitální* piny, napětí na nich je Arduinem interpretováno pomocí dvou logických hodnot -- `HIGH` a `LOW`, neboli *pravda* a *nepravda*, často také *logická jedna* a *nula*.

Arduino pracuje s pozitivní TTL logikou. Logická jedna, `HIGH`, je reprezentována napětím blízkým napájecímu (v případě verze Uno je to 5 V, v případě Nano pak 3,3 V) a logická nula, `LOW`, je napětí blízké 0 V. Následující jednoduchý kód způsobí, že na pinu číslo 13 bude logická jedna a tedy na pinu lze pomocí voltmetru naměřit 5 V a na pinu č. 12 bude logická nula, voltmetr naměří 0 V:

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

Ve funkci setup je na prvních dvou řádcích zavolána funkce `pinMode()`, která nastaví směr digitálního pinu (`OUTPUT` neboli výstup a `INPUT` neboli vstup) a která očekává dva parametry -- nejdříve číslo pinu který chceme nastavit a pak samotný směr.

Na dalších dvou řádcích je pak volána funkce `digitalWrite()`, kterou se dá u výstupních pinů nastavit jejich logická hodnota. Funkce opět očekává dva parametry -- nejdříve číslo pinu který chceme měnit a pak logická hodnota.

Poté co tento kód nahrajete do Arduina si můžete vzít do ruky voltmetr a změřit napětí na pinech 12 a 13. Změřené hodnoty by vás již v tomto okamžiku neměli překvapit a měli byste chápat proč tomu tak je. Teď už zbývá si ukázat jak na vstupní piny.

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

Příklad výše bude opakovaně kontrolovat logickou hodnotu na pinu 12, který jsme nastavili jako vstupní. Pokud je na pinu napájecí napětí (tedy logická jedna) na pinu 13 se okamžitě objeví logická jedna (pokud k tomuto pinu připojíme LED s rezistorem, dioda se rozsvítí). Ihned jak k pinu 12 připojíme 0 V (GND), LED zhasne.

## Analogový vstup a výstup

Ne vždy si v elektronice vystačíme jen s digitálním vstupem/výstupem. Relativně často je potřeba pracovat s analogovým (spojitým) signálem. Arduino nám sice práci s nimi maximálně zjednodušuje, ale i tak je potřeba vědět několik důležitých faktů.

Analogový vstup umožňují piny označené jako `A` nebo `Analog`. V případě verze Uno je to celkem 6 pinů, které dokáží pracovat s napětím 0 až 5 V. Tato analogová hodnota je převedena na 10 bitové číslo se kterým pak můžeme v našem projektu dále pracovat. Ukažme si to na jednoduchém příkladě:

{% highlight c %}
void setup() {
}

void loop() {
}
{% endhighlight %}
