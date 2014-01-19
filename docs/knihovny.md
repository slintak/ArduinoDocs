---
layout: docs
title: Knihovny
prev_section: 
next_section: serial
permalink: /docs/knihovny/
---

Důležitou součástí Arduina jsou *knihovny*. Jsou to jakési balíčky obsahující
funkce, které můžeme ve svých projektech používat. Tyto funkce pak mohou
realizovat nějaký složitější algoritmus nebo pracovat s externí součástkou
nebo celým obvodem (např. gyroskop, maticová klávesnice, připojení k
Internetu, ...). Výhodou knihoven je to, že nás jako uživatele nezajímá co
obsahují, ani jak jsou naprogramovány. K běžnému použití stačí znát jména
funkcí a to, v jakém pořadí a jak je volat. O vše ostatní už se postará
samotná knihovna.

Právě díky knihovnám je Arduino tolik oblíbené a tak univerzální. Každý
zkušenější programátor si může napsat vlastní knihovnu, která řeší určitý
problém a pak ji třeba publikovat na Internetu. Od tohoto okamžiku si ji mohou
lidé stáhnout a uložit do Arduino IDE (podrobnosti o přidání nové knihovny do
Arduino IDE viz sekci [vývojové prostředí Arduina]({{site.url}}/docs/arduino-
ide)).

## Práce s knihovnami

S každou knihovnou se pracuje trochu jinak a každá obsahuje jiné funkce. Je
proto ždy nutné přečíst si dokumentaci nebo alespoň projít dodané příklady,
které názorně ukazují její použití. Většina knihoven má dost intuitivní
rozhraní a názvy funkcí samy napovídají jakou funkci provádějí.

Některé vlastnosti mají ale všechny knihovny společné. Obecně se můžeme setkat
s dvěma druhy knihoven. Abychom nemuseli zabýhat do zbytečných detailů,
pojmenujme si tyto dva typy *statické* a *dynamické* knihovny.

### Statické knihovny

Funkce statických knihoven voláme přímo, společně se jménem knihovny a tyto
funkce pak pracují nad společnými daty nebo jedním hardware. Takhle obecně to
zní složitě, ukažme si to na příkladu knihovny
[Serial]({{site.url}}/docs/serial):

{% highlight c %}
void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.println("Ahoj svete!");
  delay(1000);
}
{% endhighlight %}

Jméno knihovny je `Serial` a obsahuje funkce jako `begin()` a `println()`. Co
přesně dělají nás zatím nemusí zajímat. Důležité nyní je, že knihovna `Serial`
je statická, takže pokud chceme volat její funkce, stačí napsat její jméno,
znak tečky a hned poté název funkce a případně její parametry. Všechny funkce
pak pracují nad jedním konkrétním rozhraním a všechny sdílí stejné nastavení a
data.

Dalším příkladem může být práce s interní EEPROM pamětí:


{% highlight c %}
#include <EEPROM.h>

void setup() {
  int i;

  // Zapiš do paměti EEPROM 20 znaků.
  for(i = 0; i < 20; i++) {
    EEPROM.write(i, 'a' + i);
  }

  // Přečti z paměti 20 znaků.
  for(i = 0; i < 20; i++) {
    int znak = EEPROM.read(i);
  }  
}

void loop() {}
{% endhighlight %}

Knihovna `EEPROM` je opět statická. Arduino obsahuje pouze jednu EEPROM paměť,
a proto pokaždé když voláme funkce `read()` a `write()`, voláme je s jménem
knihovny.

### Dynamické knihovny

Druhý typ jsou knihovny dynamické. Před jejich prvním použitím musíme tyto
knihovny tzv. inicializovat. To znamená, že zavoláme speciální funkci, která
knihovnu nakonfiguruje a připraví pro následné použití. Výsledek této
konfigurace se uloží do proměnné a my pak dále pracujeme s touto proměnnou.
Výhotou techto knihoven je, že si můžeme v paměti Arduina nakonfigurovat jednu
knihovnu vícekrát a s různým nastavením.

![LCD displej používající knihovnu `LiquidCrystal`]({{site.url}}/imgs/knihovny-liquidcrystal.png){: .caption}

Opět si to ukažme na příkladu. Typickým představitelem dynamických knihoven je
`LiquidCrystal`, která slouží k práci s alfanumerickými LCD displeji.
Následující příklad vytiskne na displej text *Hello World* a počet vteřin,
které uběhly od spuštění Arduina.

{% highlight c %}
#include <LiquidCrystal.h>

// Inicializace (konfigurace) knihovny. Výsledek
// se uloží do proměnné `lcd`.
// LCD displej je připojen k pinům 12, 11, 5, 4, 3 a 2.
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

void setup() {
  // Displej má 16 znaků ve dvou řádcích.
  lcd.begin(16, 2);
  // Na první řádek vytiskni text.
  lcd.print("hello, world!");
}

void loop() {
  // Přejdi na řádek č. 2 (řádky se počítají od nuly)
  // a první znak (sloupec).
  lcd.setCursor(0, 1);
  // Vytiskni počet vteřin od spuštění.
  lcd.print(millis()/1000);
}
{% endhighlight %}

Pokud bychom k Arduinu později připojili druhý displej, stačí jej
inicializovat a pracovat s ním stejně jako s prvním:

{% highlight c %}
#include <LiquidCrystal.h>

// První diplej
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
// Druhý displej
LiquidCrystal lcd_dva(13, 10, 9, 8, 7, 6);

void setup() {
  // ...
  lcd.begin(16, 2);
  lcd_dva.begin(16, 2);

  lcd.print("LCD jedna");
  lcd_dva.print("LCD dva");
}

void loop() {
  // ...
}
{% endhighlight %}



Dynamické knihovny se tedy musí nejdříve inicializovat a pak se s nimi pracuje
úplně stejně jako se statickými. Pouze se knihovní funkce nevolají s jménem
knihovny, ale s jménem proměnné které jsme si sami zvolili.

## Klíčové slovo *include*

V příkladech z předchozí sekce jste si možná všimli řádku:

{% highlight c %}
#include <LiquidCrystal.h>
{% endhighlight %}

Toto je prostředek programovacího jazyka, kterým říkáme, že od této chvíle
chceme pracovat s knihovnou `LiquidCrystal`. Od tohoto řádku se obsah této
knihovny načte a my ji můžeme používat.

Tento řádek je důležitý a nelze jej vynechat u žádné knihovny se kterou chceme
pracovat. Pokud bychom na řádek s `include` zapomněli, během nahrávání kódu do
Arduina obdržíme chybové hlášení, které vypadá asi nějak takto:

{% highlight bash %}
MujProjekt.ino: In funcion 'void loop()':
MujProjekt:54 error: 'lcd' was not declared in this scope
{% endhighlight %}

Jedinou výjimkou z tohoto pravidla je knihovna `Serial`, která je běžnou
součástí každého Arduina a zároveň je to nejpoužívanější knihovna. Před
jejím použitím proto není potřeba vkládat řádek `include`.

## Pod pokličkou

Těm z vás, kteří již někdy programovali s objektově orientovaném jazyce už je
patrně jasné, jak knihovny fungují. Arduino používá jazyk C++ ze kterého
využívá třídy právě pro knihovny. Každá knihovna je třída obsahující metody a
atributy. Metody mohou být přetížené, třídy (knihovny) mohou využívat
dědičnosti (to je např. případ knihovny `Serial` nebo `Ethernet`), atd.

Pokud dobře ovládáte C++, můžete si napsat své vlastní knihovny. Nic víc v tom
není.
