#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/pinit:0.2.2": pin, pinit-arrow
#import fletcher.shapes: brace, ellipse
#import themes.university: *

#let to-binary(number) = {
  let result = ()

  while (number > 0) {
    if calc.rem(number, 2) == 1 {
      result.push(1)
    } else {
      result.push(0)
    }
    number = calc.floor(number / 2)
  }
  let res-str = ""

  result = result.rev()

  for i in result {
    res-str + str(i)
  }

  res-str
}

#let to-binary-padded(number, size) = {
  let binary-number = to-binary(number)
  for _ in range(size - binary-number.len()) {
    binary-number = "0" + binary-number
  }

  binary-number
}

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

= Kódování textu

== Motivace

#pause
*Rýmuje se každé slovo se sebou samotným?*#pause
- Rýmuje se každé slovo se sebou samotným?#pause
- Rýmuje se "každé slovo" se sebou samotným?#pause
- Rýmuje se každé slovo se "sebou samotným"?#pause
- Rýmuje se "každé slovo" se "sebou samotným"?

#line(length: 100%)#pause

*`01000001`*#pause
- $1000001 = 10^6 dot 1 + 10^0 dot 1$ (desítkově)#pause
- $65 = 2^6 dot 1 + 2^0 dot 1$ (binárně)#pause
- `A` (v ASCII)

== ASCII

#slide(align(center + horizon, table(
  columns: 3,
  align: center,
  [*Desítkově*], [*Binárně*], [*Popis*],
  [#sym.dots.v], [#sym.dots.v], [#sym.dots.v],
  $3$, $00000011$, [End of Text],
  $4$, $00000100$, [End of Transmission],
  $5$, $00000101$, [Enquiry],
  $6$, $00000110$, [Acknowledge],
  $7$, $00000111$, [Bell, Alert],
  $8$, $00001000$, [Backspace],
  $9$, $00001001$, [Horizontal Tab],
  $10$, $00001010$, [Line Feed],
  $11$, $00001011$, [Vertical Tabulation],
  $12$, $00001100$, [Form Feed],
  $13$, $00001101$, [Carriage Return],
  [#sym.dots.v], [#sym.dots.v], [#sym.dots.v],
)))

#slide(
  align(
    center,
    grid(
      columns: 2,
      align: horizon,
      inset: 10pt,
      figure(
        image("images/teleprinter.jpg", height: 60%),
        caption: [Teleprinter #footnote[Převzato z #link("https://commons.wikimedia.org/wiki/File:ASR-33_at_CHM.agr.jpg")]],
      ),
      figure(
        image("images/punchcard.jpg", height: 40%),
        caption: [Děrný štítek #footnote[Převzato z #link("https://commons.wikimedia.org/wiki/File:Used_Punchcard_(5151286161).jpg")]],
      ),
    ),
  ),
)

#slide(align(center + horizon, table(
  columns: 3,
  [*Desítkově*], [*Binárně*], [*Znak*],
  ..range(32, 44)
    .map(i => ($#i$, $#to-binary-padded(i, 8)$, raw(str.from-unicode(i))))
    .flatten()
    .map(i => [ #i ]),
  [#sym.dots.v], [#sym.dots.v], [#sym.dots.v]
)))

#slide(
  align(
    horizon + center,
    table(
      columns: 3,
      [*Desítkově*], [*Binárně*], [*Znak*],
      ..range(48, 58)
        .map(i => (
          $#i$,
          $#to-binary-padded(i, 8).slice(0, 4)#text(fill: red, to-binary-padded(i, 8).slice(4, none))$,
          raw(str.from-unicode(i)),
        ))
        .flatten()
        .map(i => [ #i ]),
      [#sym.dots.v], [#sym.dots.v], [#sym.dots.v]
    ),
  ),
)

#slide(
  align(
    center + horizon,
    columns(
      2,
      gutter: 5pt,
      text()[
        #let number-of-letters = 12
        #table(
          columns: 3,
          [*Desítkově*], [*Binárně*], [*Znak*],
          ..range(65, 65 + number-of-letters)
            .map(i => (
              $#i$,
              $#to-binary-padded(i, 8).slice(0, 2)#text(fill: blue, to-binary-padded(i, 8).slice(2, 3))#text(fill: red, to-binary-padded(i, 8).slice(3, none))$,
              raw(str.from-unicode(i)),
            ))
            .flatten()
            .map(i => [ #i ]),
          [#sym.dots.v], [#sym.dots.v], [#sym.dots.v]
        )
        #colbreak()
        #table(
          columns: 3,
          [*Desítkově*], [*Binárně*], [*Znak*],
          ..range(97, 97 + number-of-letters)
            .map(i => (
              $#i$,
              $#to-binary-padded(i, 8).slice(0, 2)#text(fill: blue, to-binary-padded(i, 8).slice(2, 3))#text(fill: red, to-binary-padded(i, 8).slice(3, none))$,
              raw(str.from-unicode(i)),
            ))
            .flatten()
            .map(i => [ #i ]),
          [#sym.dots.v], [#sym.dots.v], [#sym.dots.v]
        )
      ],
    ),
  ),
)

== Codepage

#align(center, figure(
  image("images/codepage.png", height: 80%),
  caption: [Codepage 437],
))

== Harry Potter

#slide(
  align(
    horizon + center,
    columns(2)[
      #pause
      #figure(
        align(
          left,
          rect(
            inset: 20pt,
            raw(
              "Россия, Москва, 119415\nпр. Вернадского, 37,\nк. 1817-1,\nПлетневой Светлане",
            ),
          ),
        ),
        kind: image,
        caption: [Adresa\ v~ruském kódování#footnote[Převzato z #link("https://unicodebook.readthedocs.io/definitions.html#mojibake")]],
      )
      #pause
      #colbreak()
      #figure(
        align(
          left,
          rect(
            inset: 20pt,
            raw(
              "òÏÓÓÉÑ, ìÎÓË×Á, 119415\nÐÒ.÷ÅÒÎÁÄÓËÏÇÏ, 37,\nË.1817-1,\nðÌÅÔÎÅ×ÏÊ ó×ÅÔÌÁÎÅ",
            ),
          ),
        ),
        kind: image,
        caption: [Adresa ve~francouzském kódování#footnote[Převzato z #link("https://unicodebook.readthedocs.io/definitions.html#mojibake")]],
      )
    ],
  ),
)

#slide(
  align(
    center,
    figure(
      image("images/letter_to_russia.jpg", height: 75%),
      caption: [Balíček #footnote[Převzato z #link("https://unicodebook.readthedocs.io/definitions.html#mojibake")]],
    ),
  ),
)


== Kohuept

#slide(align(center + horizon, text(size: 100pt)[Kohuept]))

#slide(
  align(
    center,
    figure(
      image("images/kohuept.jpg", height: 70%),
      caption: [Billy Joel -- Kohuept #footnote[Převzato z #link("https://en.wikipedia.org/wiki/Kontsert#/media/File:Billy_Joel_-_KOHUEPT.jpg")]],
    ),
  ),
)

== Unicode

#slide(
  align(
    center + horizon,
    text(size: 50pt)[
      "Provide a single, consistent way to~represent each letter and symbol needed for all human languages across all computers and devices."
    ],
  ),
)

#slide(
  align(horizon)[
    #let pad-binary(string) = {
      let padding = ""
      for _ in range(8 - string.len()) {
        padding += "X"
      }
      return [#text(size: 30pt)[#raw(string)#text(fill: red, raw(padding))]]
    }

    #pause
    - 1bytový znak: #pad-binary("0") (ASCII)#pause
    - 2bytový znak: #pad-binary("110") #pad-binary("10")#pause
    - 3bytový znak: #pad-binary("1110") #pad-binary("10") #pad-binary("10")#pause
    - 4bytový znak: #pad-binary("11110") #pad-binary("10") #pad-binary("10") #pad-binary("10")#pause

    #align(center, text(size: 50pt)[
      🚀❤️😀🎉👍🇨🇿👾
    ])
  ],
)

== Plain Text -- Dylan Beattie

#slide(
  align(
    center,
    figure(
      image("images/plain_text-dylan_beattie.png", height: 75%),
      caption: [Plain Text -- Dylan Beattie -- NDC Copenhagen 2022#footnote[Převzato z #link("https://www.youtube.com/watch?v=gd5uJ7Nlvvo")]],
    ),
  ),
)

= Počítání modulo

#slide[
  #let number-line(start, end) = {
    let gap = 1.75em

    align(center)[
      #line(length: (calc.abs(start) + calc.abs(end) + 1 + 2) * gap)#h(-1em)
      #for i in range(start, end + 1) {
        box()[
          #v(-1.2em)
          #align(center)[
            #rotate(90deg, line(length: 0.5em))
            #v(-0.8em)
            #i
          ]
          #h(gap)
        ]
      }
    ]
  }

  #number-line(-7, 7)
  #circle(radius: 2em)
]

= Dělení kryptologie

#slide(
  align(
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
  ),
)

= Historie

== Caesarova šifra

#let letters = ("Y", "Z", "A", "B", "C", "D")

#let alphabet(prefix) = {
  table(
    columns: 8,
    $dots.c$,
    ..letters
      .enumerate()
      .map(e => {
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
#align(center + horizon, table(
  columns: 6,
  [], [*1*], [*2*], [*3*], [*4*], [*5*],
  [*1*], [A], [B], [C], [D], [E],
  [*2*], [F], [G], [H], [I/J], [K],
  [*3*], [L], [M], [N], [O], [P],
  [*4*], [Q], [R], [S], [T], [U],
  [*5*], [V], [W], [X], [Y], [Z],
))
#pause

Příklad:

- $\""H\"" -> (3, 2)$


== Frekvenční analýza

#pause
#align(center, figure(
  image("images/frequency_analysis.png", height: 90%),
  caption: [Typická distribuce výskytu písmen v anglickém textu.],
))

#speaker-note[
  - Lze i pro větší celky slabiky/morfémy/slova
  - Zipfův zákon
  - Substituce písmen nebo jiných celků nestačí
  - Arab al-Kindi
]

== Vigenèrova šifra

#let tabula-recta(subslide, plain-text, key) = figure(
  text(
    size: 11pt,
    table(
      inset: 3pt,
      columns: 26,
      align: center + horizon,
      fill: (x, y) => {
        let letter-and-key-to-color(letter, key) = {
          letter = letter.to-unicode() - 65
          key = key.to-unicode() - 65

          if x == letter and y == key { return red }
          if x == letter and y == 0 { return green }
          if y == key and x == 0 { return blue }
          if y == key and x < letter { return orange }
          if x == letter and y < key { return orange }
        }

        if subslide >= 5 {
          let i = subslide - 5
          letter-and-key-to-color(plain-text.at(i), key.at(
            calc.rem(i, key.len()),
          ))
        }
      },
      ..range(0, 26)
        .map(shift => range(0, 26).map(l => calc.rem(l + shift, 26) + 65))
        .flatten()
        .map(l => [ #str.from-unicode(l) ]),
    ),
  ),
  kind: image,
  caption: [Tabula recta],
)

#slide(self => columns(
  2,
  [
    #pause
    #let plain-text = "UTOCTE ZA TMY"
    #let key = "MRAK"
    #let plain-text-without-spaces = plain-text.split(" ").join()

    Zašifrovaný text $c$ je dán jako $ c_i = (t_i + k_(i mod abs(k))) mod 26, $ kde $t$ je nezašifrovaný text,\ $k$ je klíč a $i = 0..(abs(t)-1)$.

    *Příklad*: Klíčem `MRAK` zašifrujte `UTOCTE ZA TMY`.#pause

    #let to-array(string) = { range(string.len()).map(i => string.at(i)) }
    #align(center, table(
      fill: (x, y) => {
        if self.subslide >= 5 and x == self.subslide - 4 {
          if y == 0 { green } else if y == 1 { blue } else if y == 2 { red }
        }
      },
      columns: plain-text-without-spaces.len() + 1,
      [*$t$*], ..to-array(plain-text-without-spaces).map(l => raw(l)),
      [*$k$*], ..range(plain-text-without-spaces.len())
        .map(i => to-array(key).at(calc.rem(i, key.len())))
        .map(l => raw(l)),
      [*$c$*], ..range(plain-text-without-spaces.len()).map(i => uncover(
        str(i + 5) + "-",
        raw(str.from-unicode(
          calc.rem(
            (plain-text-without-spaces.at(i).to-unicode() - 65)
              + (key.at(calc.rem(i, key.len())).to-unicode() - 65),
            26,
          )
            + 65,
        )),
      ))
    ))
    #pause
    #tabula-recta(self.subslide, plain-text-without-spaces, key)
  ],
))

== One-time pads (Vernamova šifra)

#pause
$t_n + k_n mod 26$ pro $n in {1, dots, l}$, kde $l$ je délka $t$, což je šifrovaný text, a $k$ je klíč.#pause

*Příklad*: Zašifrujte $t = \""HELLO\""$#pause, jestliže klíč $k = (6, 10, 19, 0, 20)$.#pause

$
  \""H\""#pause ->& (7 + 6) &mod 26 #pause&= 13 mod 26 #pause&=& 13 #pause&-> \""R\""#pause\
  \""E\""#pause ->& (4 + 10) &mod 26 #pause&= 14 mod 26 #pause&=& 14 #pause&-> \""O\""#pause\
  \""L\""#pause ->& (11 + 19) &mod 26 #pause&= 30 mod 26 #pause&=& 6 #pause&-> \""G\""#pause\
  \""L\""#pause ->& (11 + 0) &mod 26 #pause&= 11 mod 26 #pause&=& 11 #pause&-> \""L\""#pause\
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

#slide[
  #figure(
    image("images/bombe.jpg", height: 90%),
    caption: [Bomba (anglicky _bombe_)],
  )
]

#slide[
  #figure(image("images/colossus.jpg", height: 90%), caption: [Colossus])
]

= Hashovácí funkce

== Problém ukládání hesel

#align(horizon, touying-fletcher-diagram(
  node-shape: rect,
  node-corner-radius: 10pt,
  node-stroke: black,
  pause,
  edge((0, 0), <login-info>, "->", align(center)[Žádost o\ registraci]),
  pause,
  node((1.5, 0), name: "login-info", [Zpracování\ žádosti]),
  pause,
  edge(
    <login-info>,
    (1.5, -1.5),
    (3.75, -1.5),
    <database>,
    "->",
    label-side: center,
    [Uživatelské jméno],
  ),
  pause,
  edge(
    <login-info>,
    (1.5, 1.5),
    (3.75, 1.5),
    <database>,
    "->",
    label-side: center,
    align(center)[Heslo],
  ),
  pause,
  edge(
    <login-info>,
    (1.5, 1.5),
    (3.75, 1.5),
    <database>,
    "->",
    label-side: center,
    align(center)[Heslo],
  ),
  node((3.75, 0), name: "database", [Databáze]),
  pause,
  edge(<database>, (7, 0), "->", label-side: center, align(center)[Únik dat]),
))

== Neexistence inverze

#align(
  center + horizon,
  touying-fletcher-diagram(
    pause,
    node((0, -0.5), shape: rect, stroke: black, name: "hash", [Hashovací funkce]),
    pause,
    node((-1, -0.5), shape: rect, name: "input", [Vstup]),
    edge(<input>, <hash>, "->"),
    pause,
    edge(<hash>, <output>, "->"),
    node((1, -0.5), shape: rect, name: "output", [Výstup]),
    pause,
    node(
      (0, 0.5),
      shape: rect,
      stroke: black,
      name: "inverse",
      [Inverzní funkce],
    ),
    pause,
    edge(<output>, <inverse>, corner: right, "->"),
    pause,
    edge(<inverse>, <input>, corner: right, "->"),
    pause,
    edge((-0.5, 0.75), (0.5, 0.25), "-", stroke: 5pt + red),
    edge((-0.5, 0.25), (0.5, 0.75), "-", stroke: 5pt + red),
  ),
)

== Nízká pravděpodobnost kolizí

#align(center + horizon, touying-fletcher-diagram(
  pause,
  node((-1.5, -0.5), name: "inputs", [Vstupy]),
  node((-1.5, 0.3), shape: circle, stroke: black, radius: 5em),
  pause,
  node((1.5, -0.5), name: "outputs", [Výstupy]),
  node((1.5, 0.3), shape: circle, stroke: black, radius: 5em),
  pause,
  edge(<inputs>, <outputs>, "->", [Hashovací funkce]),
  pause,
  node(
    (-1.5, -0.2),
    shape: circle,
    fill: black,
    radius: 2pt,
    outset: 3pt,
    name: "collision-a",
  ),
  node(
    (-1.5, 0.8),
    shape: circle,
    fill: black,
    radius: 2pt,
    outset: 3pt,
    name: "collision-b",
  ),
  pause,
  node(
    (1.5, 0.3),
    shape: circle,
    fill: black,
    radius: 2pt,
    outset: 3pt,
    name: "collision-end",
  ),
  edge(<collision-a>, <collision-end>, "|->", bend: 30deg),
  edge(<collision-b>, <collision-end>, "|->", bend: -30deg),
  pause,
  edge((1.2, 0.6), (1.8, 0), "-", stroke: 5pt + red, layer: 10, snap-to: none),
  edge((1.2, 0), (1.8, 0.6), "-", stroke: 5pt + red, layer: 10, snap-to: none),
))

== Podobnost vstupů a výstupů

#align(center + horizon, touying-fletcher-diagram(
  pause,
  node((-1.5, -0.7), name: "inputs", [Vstupy]),
  node((-1.5, 0), shape: circle, stroke: black, radius: 5em),
  node((1.5, -0.7), name: "outputs", [Výstupy]),
  node((1.5, 0), shape: circle, stroke: black, radius: 5em),
  pause,
  edge(<inputs>, <outputs>, "->", [Hashovací funkce]),
  pause,
  node(
    (-1.5, -0.1),
    shape: circle,
    fill: black,
    radius: 2pt,
    outset: 3pt,
    name: "start-a",
  ),
  node(
    (-1.5, 0.1),
    shape: circle,
    fill: black,
    radius: 2pt,
    outset: 3pt,
    name: "start-b",
  ),
  pause,
  node(enclose: (<start-a>, <start-b>), shape: brace.with(
    dir: left,
    sep: -5pt,
    label: [Podobné],
  )),
  pause,
  node(
    (1.5, -0.5),
    shape: circle,
    fill: black,
    radius: 2pt,
    outset: 3pt,
    name: "end-a",
  ),
  edge(<start-a>, <end-a>, "|->", bend: 30deg),
  node(
    (1.5, 0.5),
    shape: circle,
    fill: black,
    radius: 2pt,
    outset: 3pt,
    name: "end-b",
  ),
  edge(<start-b>, <end-b>, "|->", bend: -30deg),
  pause,
  node(enclose: (<end-a>, <end-b>), shape: brace.with(
    dir: right,
    sep: -5pt,
    label: [Rozdílné],
  )),
))

/*
- (nejde o hashovací funkce používané pro rozpylové/hash tabulky/mapy/slovníky)#pause
- (nejde o hashovací funkce používané pro kontrolní součty)#pause
- Najít inverzi je velice náročné (až nemožné)#pause
- Malá změna ve vstupu způsobí velkou změnu ve výstupu#pause
- Kolize jsou vysoce nepravděpodobné
*/

== Využití při registraci

#let registration-diagram-before-salt-content = (
  pause,
  edge((0, 0), <login-info>, "->", align(center)[Žádost o\ registraci]),
  pause,
  node((1.5, 0), name: "login-info", [Zpracování\ žádosti]),
  pause,
  edge(
    <login-info>,
    (1.5, -1.5),
    (3.75, -1.5),
    <database>,
    "->",
    label-side: center,
    [Uživatelské jméno],
  ),
  pause,
  edge(
    <login-info>,
    (1.5, 1.5),
    <hash>,
    "->",
    label-side: center,
    label-pos: 40pt,
    align(center)[Heslo],
  ),
)
#let registration-diagram-after-salt-content = (
  pause,
  node((2.75, 1.5), name: "hash", [Hashovací\ funkce]),
  pause,
  edge(
    <hash>,
    (3.75, 1.5),
    <database>,
    "->",
    label-side: center,
    label-pos: 100% - 40pt,
    [Zahashované heslo],
  ),
  pause,
  node((3.75, 0), name: "database", [Uložení do\ databáze]),
  pause,
  node((4.85, 0), name: "registered", [Uživatel\ registrován]),
  edge(<database>, <registered>, "->"),
)

#align(center + horizon, touying-fletcher-diagram(
  node-shape: rect,
  node-corner-radius: 10pt,
  node-stroke: black,
  registration-diagram-before-salt-content,
  registration-diagram-after-salt-content,
))

== Využití pri přihlašování

#let login-diagram-before-salt-content = (
  pause,
  edge((-3.5, 0), <login-info>, "->", align(center)[Žádost o\ přihlášení]),
  pause,
  node((-2, 0), name: "login-info", [Zpracování\ žádosti]),
  pause,
  edge(
    <login-info>,
    (-2, -1.25),
    <database>,
    "->",
    label-side: center,
    label-pos: 0.25,
    label-anchor: "center",
    label-fill: true,
    align(center)[Uživatelské\ jméno],
  ),
  pause,
  node((-1, -1.25), name: "database", align(center)[Prohledávání\ databáze]),
  pause,
  edge(
    <database>,
    (0, -1.25),
    <comparison>,
    "->",
    label-side: center,
    label-pos: 0.75,
    label-anchor: "center",
    label-fill: true,
    align(center)[Zahashované\ heslo],
  ),
)

#let login-diagram-after-salt-content = (
  pause,
  edge(
    <login-info>,
    (-2, 1.25),
    <hash>,
    "->",
    label-side: center,
    label-pos: 0.25,
    label-anchor: "center",
    label-fill: true,
    align(center)[Heslo],
  ),
  pause,
  node((-1, 1.25), name: "hash", [Hashovací\ funkce]),
  pause,
  edge(
    <hash>,
    (0, 1.25),
    <comparison>,
    "->",
    label-side: center,
    label-pos: 0.75,
    label-anchor: "center",
    label-fill: true,
    align(center)[Zahashované\ heslo],
  ),
  pause,
  node((0, 0), name: "comparison", [Stejné?]),
  pause,
  edge(
    <comparison>,
    (1.25, 0),
    <logged-in>,
    "->",
    label-pos: 0.75,
    label-side: center,
    [Ano],
  ),
  pause,
  node((1.25, -0.75), name: "logged-in", align(center)[Uživatel\ přihlášen]),
  pause,
  edge(
    <comparison>,
    (1.25, 0),
    <login-failed>,
    "->",
    label-pos: 0.75,
    label-side: center,
    [Ne],
  ),
  pause,
  node((1.25, 0.75), name: "login-failed", align(center)[Smůla]),
)

#align(center + horizon, touying-fletcher-diagram(
  node-shape: rect,
  node-corner-radius: 10pt,
  node-stroke: black,
  ..login-diagram-before-salt-content,
  ..login-diagram-after-salt-content,
))

== Útoky hrubou silou

- Rock you dictionary

== Registrace se saltem

#align(center + horizon, touying-fletcher-diagram(
  node-shape: rect,
  node-corner-radius: 10pt,
  node-stroke: black,
  registration-diagram-before-salt-content,
  pause,
  node((2.75, -0.75), name: "rng", [Generátor\ náhodných čísel]),
  pause,
  edge(<rng>, <hash>, "->"),
  edge(
    <rng>,
    (2.75, 0),
    <database>,
    "->",
    label-pos: 0.25,
    label-side: center,
    [Salt],
  ),
  registration-diagram-after-salt-content,
))

== Přihlášení se saltem

#align(center + horizon, touying-fletcher-diagram(
  node-shape: rect,
  node-corner-radius: 10pt,
  node-stroke: black,
  ..login-diagram-before-salt-content,
  pause,
  edge(<database>, <hash>, "->", label-side: center, [Salt]),
  ..login-diagram-after-salt-content,
))


= Symetrické šifry

== Advanced Encryption Standard

#slide[
  #align(horizon + center, touying-fletcher-diagram(
    node-shape: rect,
    node-corner-radius: 10pt,
    node-stroke: black,

    pause,
    node((1.9, 0), name: "key", [Klíč]),
    node((1, 0), name: "plain-text", [Text]),
    pause,

    edge(<plain-text>, <split>, "->"),
    node((1, 0.35), name: "split", [Rozdělení do bloků po 16 bytech]),
    pause,

    edge(<key>, <round-keys>, "->"),
    node((1.9, 0.35), name: "round-keys", [Podklíče pro $n$ kol]),
    pause,

    edge(<split>, <first-round>, "->"),
    edge(<round-keys>, (1.9, 0.7), <first-round>, "->"),

    node((1, 0.7), name: "first-round", [Přidání klíče]),
    node(enclose: (<first-round>), shape: brace.with(
      dir: left,
      label: [Kolo $1$],
    )),
    pause,

    edge(<first-round>, <middle-rounds>, "->"),
    edge(<round-keys>, (1.9, 1.75), (1, 1.75), "->"),

    node((1, 1.4), name: "middle-rounds", inset: 0pt, [
      #let line-space() = [
        #v(-15pt)
        #line(length: 100%)
        #v(-15pt)
      ]
      #v(6pt)
      Substituce
      #line-space()
      Posun řádků
      #line-space()
      Míchání sloupců
      #line-space()
      #h(5pt)Přidání klíče#h(5pt)
      #v(6pt)
    ]),
    node(enclose: (<middle-rounds>), shape: brace.with(
      dir: left,
      label: [Kola $2$ až $n - 1$],
    )),
    pause,

    edge(<middle-rounds>, <last-round>, "->"),
    edge(<round-keys>, (1.9, 2.6), (1, 2.6), "->"),

    node((1, 2.35), name: "last-round", inset: 0pt, [
      #let line-space() = [
        #v(-15pt)
        #line(length: 100%)
        #v(-15pt)
      ]
      #v(6pt)
      Substituce
      #line-space()
      Posun řádků
      #line-space()
      #h(5pt)Přidání klíče#h(5pt)
      #v(6pt)
    ]),
    node(
      enclose: (<last-round>),
      shape: brace.with(dir: left, label: [Kolo $n$]),
    ),
    pause,

    edge(<last-round>, <cipher-text>, "->"),
    node((1, 3), name: "cipher-text", [Zašifrovaný text]),
  ))
]
#slide(align(horizon + center, [
  #image("images/aes-add_round_key.png")
  #place(bottom + right, dx: -125pt, table(
    columns: 3,
    align: center,
    $a$, $k$, $a xor k = b$,
    $0$, $0$, $0$,
    $0$, $1$, $1$,
    $1$, $0$, $1$,
    $1$, $1$, $0$,
  ))
]))
#slide(align(horizon + center, image("images/aes-sub_bytes.png")))
#slide(align(horizon + center, image("images/aes-shift_rows.png")))
#slide(align(horizon + center, image("images/aes-mix_columns.png")))

= Asymetrické šifry

== Princip

#let tint(c) = (
  stroke: c,
  fill: rgb(..c.components().slice(0, 3), 15%),
  inset: 8pt,
)

#align(center + horizon, touying-fletcher-diagram(
  pause,
  node(enclose: ((-2.5, 0), (-0.6, 4)), corner-radius: 1em, ..tint(blue), align(
    top,
  )[Odesílatel]),
  pause,
  node(enclose: ((2.5, 0), (0.6, 4)), corner-radius: 1em, ..tint(red), align(
    top,
  )[Příjemce]),
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
))
