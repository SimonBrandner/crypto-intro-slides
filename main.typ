#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.5" as fletcher: node, edge, diagram
#import "@preview/pinit:0.2.2": pin, pinit-arrow
#import themes.university: *

#let touying-fletcher-diagram = touying-reducer.with(
  reduce: fletcher.diagram,
  cover: fletcher.hide,
)

#show: university-theme.with(
  aspect-ratio: "16-9",
  header: utils.display-current-heading(level: auto, style: auto),
  config-info(
    title: [Úvod do kryptografie],
    author: [Šimon Brandner],
    date: datetime.today(),
  ),
  config-common(
    slide-level: 3,
    //show-notes-on-second-screen: right,
  ),
)

#let spacing = 0.9em
#set par(leading: spacing, spacing: spacing)
#set list(spacing: spacing)
#set text(lang: "cs")
#set heading(numbering: "1.1")
#show heading.where(level: 1): set heading(numbering: "1.")
#show link: underline

#title-slide()

= Úvod

== Motivace

Hello

== Dělení

#align(
  center + horizon,
  touying-fletcher-diagram(
    pause,
    node((-0.25, 0), shape: rect, stroke: black, name: "logy", [Kryptologie]),
    pause,

    node((-1, 1), shape: rect, stroke: black, name: "graphy", [Kryptografie]),
    edge(<logy.south>, <graphy.north>),
    pause,

    node(
      (-1.75, 2),
      shape: rect,
      stroke: black,
      name: "sym",
      [Symetrické\ šifry],
    ),
    edge(<graphy.south>, <sym.north>),
    pause,

    node(
      (-2.25, 3),
      shape: rect,
      stroke: black,
      name: "block",
      [Blokové\ šifry],
    ),
    edge(<sym.south>, <block.north>),
    pause,

    node(
      (-1.25, 3),
      shape: rect,
      stroke: black,
      name: "stream",
      [Proudové\ šifry],
    ),
    edge(<sym.south>, <stream.north>),
    pause,


    node(
      (-1, 2),
      shape: rect,
      stroke: black,
      name: "asym",
      [Asymetrické\ šifry],
    ),
    edge(<graphy.south>, <asym.north>),
    pause,

    node(
      (-0.25, 2),
      shape: rect,
      stroke: black,
      name: "hash",
      [Hashovací\ funkce],
    ),
    edge(<graphy.south>, <hash.north>),
    pause,

    node(
      (0.75, 1),
      shape: rect,
      stroke: black,
      name: "analysis",
      [Kryptoanalýza],
    ),
    edge(<logy.south>, <analysis.north>),
  ),
)

= Historie

== Caesarova šifra

#let letters = ("Y", "Z", "A", "B", "C", "D")

#let alphabet(prefix) = {
  table(
    columns: 8,
    $dots.c$,
    ..letters.enumerate().map(e => {
      let (index, letter) = e

      [#pin(prefix + str(index)) #letter]
    }),
    $dots.c$,
  )
}

#pause

#align(center + horizon)[
  #alphabet("a")
  #alphabet("b")
  #for i in range(4) {
    pinit-arrow(
      "a" + str(i),
      "b" + str(i + 2),
      thickness: 1pt,
      start-dx: 10pt,
      start-dy: 22pt,
      end-dx: 10pt,
      end-dy: -7pt,
    )
  }
]

#pause

Pro anglickou abecedu lze popsat vzorcem#pause

$ (t + k) mod 26, $#pause

kde $t$ je šifrovaný text (písmeno) a $k$ je klíč (posun).#pause

Příklad: Klíč (posun) je $k = 3$.#pause
- $\""D\"" ->#pause (\""D\"" + 3) mod 26 =#pause (4 + 3) mod 26 =#pause 7 mod 26 =#pause 7$#pause
- $\""Y\"" ->#pause (\""Y\"" + 3) mod 26 =#pause (25 + 3) mod 26 =#pause 28 mod 26 =#pause 2$

#speaker-note[
  - Hodiny
  - 26 je počet znaků
  - Uvozovky pro odlišení
]

== Polybiův čtverec

#pause
#align(
  center + horizon,
  table(
    columns: 6,
    [], [*1*], [*2*], [*3*], [*4*], [*5*],
    [*1*], [A], [B], [C], [D], [E],
    [*2*], [F], [G], [H], [I/J], [K],
    [*3*], [L], [M], [N], [O], [P],
    [*4*], [Q], [R], [S], [T], [U],
    [*5*], [V], [W], [X], [Y], [Z],
  ),
)
#pause

Příklad:

- $\""H\"" -> (3, 2)$


== Frekvenční analýza

#pause
#align(
  center,
  figure(
    image("images/frequency_analysis.png", height: 90%),
    caption: [Typická distribuce výskytu písmen v anglickém textu.],
  ),
)

#speaker-note[
  - Lze i pro větší celky slabiky/morfémy/slova
  - Zipfův zákon
  - Substituce písmen nebo jiných celků nestačí
  - Arab al-Kindi
]

== Vigenèrova šifra

== Playfair cipher

== One-time pads (Vernamova šifra)

#pause
$t_n + k_n mod 26$ pro $n in {1, dots, l}$, kde $l$ je délka $t$, což je šifrovaný text, a $k$ je klíč.#pause

*Příklad*: Zašifrujte $t = \""HELLO\""$#pause, jestliže klíč $k = (6, 10, 19, 0, 20)$.#pause

$
  \""H\""#pause ->& (7 + 6)   &mod 26 #pause&= 13 mod 26 #pause&=& 13 #pause&-> \""R\""#pause\
  \""E\""#pause ->& (4 + 10)  &mod 26 #pause&= 14 mod 26 #pause&=& 14 #pause&-> \""O\""#pause\
  \""L\""#pause ->& (11 + 19) &mod 26 #pause&= 30 mod 26 #pause&=& 6  #pause&-> \""G\""#pause\
  \""L\""#pause ->& (11 + 0)  &mod 26 #pause&= 11 mod 26 #pause&=& 11 #pause&-> \""L\""#pause\
  \""O\""#pause ->& (14 + 20) &mod 26 #pause&= 34 mod 26 #pause&=& 10 #pause&-> \""K\""#pause\
$

Zašifrovaný text je tedy $c = \""ROGLK\""$.

#speaker-note[
  - Frank Miller v roce 1882 pro telegrafie
  - Neprolomitelná šifra, pokud se klíč udrží v tajnosti
  - Klíč musí být skutečně náhodný, aby nebyl uhodnutelný
  - Klíč musí být alespoň tak dlouhý jako je šifrovaný text (nesmí se použít vícekrát)
]

== Enigma

#pause
#figure(
  image("images/enigma.jpg", height: 90%),
  caption: [Stroj Enigma (jeden z modelů)],
)

#slide[
  #let image-height = 10.5em
  #columns(2)[
    #pause
    #figure(
      image("images/alan_turing.jpg", height: image-height),
      caption: [Alan Turing\ (1912 -- 1954)],
    )
    #pause
    #colbreak()
    #figure(
      image("images/gordon_welchman.jpg", height: image-height),
      caption: [Gordon Welchman (1906 -- 1985)#footnote[Převzato z #link("https://en.wikipedia.org/wiki/File:Gordon_Welchman.jpg").]],
    )
  ]

  #speaker-note[
    - Alan Turing extrémně zajímavý i jiných důvodů (Turingovy stroje)
  ]
]

#pause
#figure(
  image("images/bombe.jpg", height: 90%),
  caption: [Bomba (anglicky _bombe_)],
)

= Hashovácí funkce

== Definice

- (nejde o hashovací funkce používané pro rozpylové/hash tabulky)

#align(
  center + horizon,
  touying-fletcher-diagram(
    node((-2, 0), shape: rect, name: "input", [Vstup]),
    pause,
    edge(<input>, <hash>, "->"),
    pause,
    node(
      (0, 0),
      shape: rect,
      stroke: black,
      name: "hash",
      [Hashovací funkce],
    ),
    pause,
    edge(<hash>, <output>, "->"),
    pause,
    node((2, 0), shape: rect, name: "output", [Výstup]),
    pause,
    node(
      (0, 1),
      shape: rect,
      stroke: black,
      name: "inverse",
      [Inverzní funkce],
    ),
    pause,
    edge(<output>, "d", <inverse>, "->"),
    pause,
    edge(<inverse>, "l,l", <input>, "->"),
    pause,
    edge((0.5, 1.5), (-0.5, 0.5), "-", stroke: 5pt + red),
    edge((-0.5, 1.5), (0.5, 0.5), "-", stroke: 5pt + red),
  ),
)

== Úkládání hesel

= Symetrické šifry

= Asymetrické šifry

== Princip

#let tint(c) = (
  stroke: c,
  fill: rgb(..c.components().slice(0, 3), 15%),
  inset: 8pt,
)

#align(
  center + horizon,
  touying-fletcher-diagram(
    pause,
    node(
      enclose: ((-2.5, 0), (-0.6, 4)),
      corner-radius: 1em,
      ..tint(blue),
      align(top)[Odesílatel],
    ),
    pause,
    node(
      enclose: ((2.5, 0), (0.6, 4)),
      corner-radius: 1em,
      ..tint(red),
      align(top)[Příjemce],
    ),
    pause,
    node(
      (-2, 2),
      shape: rect,
      corner-radius: 10pt,
      fill: lime,
      name: "plain-text-original",
      [Text],
    ),
    pause,
    edge(
      <plain-text-original>,
      <cipher-text>,
      "->",
      label-side: center,
      [Šifrování],
    ),
    pause,
    node(
      (1.35, 1),
      shape: rect,
      corner-radius: 10pt,
      fill: purple,
      name: "receiver-keys",
      [Klíče příjemce],
    ),
    pause,
    edge(
      <receiver-keys>,
      (-1, 1),
      (-1, 1.85),
      "->",
      [Veřejný klíč],
      label-pos: 100% - 40pt,
      label-side: right,
    ),
    pause,
    node(
      (0, 2),
      shape: rect,
      corner-radius: 10pt,
      fill: red,
      name: "cipher-text",
      [Zašiforvaný text],
    ),
    pause,
    edge(
      <cipher-text>,
      <plain-text-deciphered>,
      "->",
      label-side: center,
      [Dešifrování],
    ),
    pause,
    edge(
      (1.05, 1),
      (1.05, 1.85),
      "->",
      [Soukromý klíč],
      label-pos: 100% - 40pt,
      label-side: left,
    ),
    pause,
    node(
      (2, 2),
      shape: rect,
      corner-radius: 10pt,
      fill: green,
      name: "plain-text-deciphered",
      [Text],
    ),
  ),
)
