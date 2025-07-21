#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/pinit:0.2.2": pin, pinit-arrow
#import "@preview/cetz-plot:0.1.2": plot
#import "@preview/cetz:0.4.0"
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

#let to-array(string) = { range(string.len()).map(i => string.at(i)) }

#let touying-fletcher-diagram = touying-reducer.with(
  reduce: fletcher.diagram,
  cover: fletcher.hide,
)
#let touying-cetz-canvas = touying-reducer.with(
  reduce: cetz.canvas,
  cover: cetz.draw.hide.with(bounds: true),
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
#set figure(numbering: none) // FIXME: Somehow numbering is broken
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
    text(size: 40pt)[
      "Provide a single, consistent way\ to~represent each letter and symbol\ needed for all human languages\ across all computers and devices."
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

== Naše kódování textu

#let simple-encoding-table(start, stop, heading) = table(
  columns: (130pt, 75pt),
  align: center,
  ..(if heading { ([*Desítkově*], [*Znak*]) } else { () }),
  ..range(start, stop)
    .map(i => (
      $#i$,
      raw(str.from-unicode(i + 65)),
    ))
    .flatten()
    .map(i => [ #i ]),
)


#align(horizon, columns(3, [
  #simple-encoding-table(0, 8, true)
  #colbreak()
  #simple-encoding-table(8, 17, false)
  #colbreak()
  #simple-encoding-table(17, 26, false)
]))

= Modulární aritmetika

#slide[
  #let radius = 4.5em
  #let prime = 5
  #let number-line(start, end) = {
    let gap = 1.75em

    align(center)[
      #line(length: (calc.abs(start) + calc.abs(end) + 1 + 2) * gap)#h(-1em)
      #for i in range(start, end + 1) {
        box()[
          #v(-0.9em)
          #align(center)[
            #rotate(90deg, line(length: 0.5em))
            #v(-0.4em)
            #i
          ]
          #h(gap)
        ]
      }
    ]
  }

  #pause

  #number-line(-7, 7)
  #pause

  #grid(
    columns: (70%, 30%),
    [
      #place(dx: 5em, circle(radius: radius, align(
        center + horizon,
        for i in range(prime) {
          let is-left = i < ((prime + 1) / 2)
          let horizontal-shift = if is-left { 2em } else { -5em }
          let alpha = (2 * calc.pi / prime) * i - calc.pi / 2
          let x = radius * calc.cos(alpha)
          let y = radius * calc.sin(alpha)

          let text = $dots,$
          for j in range(-1, 2) {
            text += $#str(i + prime * j),$
          }
          text += $dots$

          let dot = circle(radius: 5pt, fill: black)

          place(center + horizon, dx: x, dy: y, place(
            horizon + if is-left { left } else { right },
            dx: if is-left { -5pt } else { 5pt },
            grid(
              align: horizon + center,
              columns: 2,
              ..(
                if is-left { (dot, h(10pt) + text) } else {
                  (text + h(10pt), dot)
                }
              ),
            ),
          ))
        },
      )))
      #pause

      #v(10em)
      Zbytku po dělení čísla $m$ číslem $n$ budeme říkat $m mod n$.
      #pause
    ],
    [
      - $1 mod 5 = 1$#pause
      - $6 mod 5 = 1$#pause
      - $11 mod 5 = 1$#pause
      - $9 mod 5 = 4$
    ],
  )
]

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

Zašifrovaný text $c$ je dán jako
$
  c_i = (t_i + k) mod 26,
$
kde $t$ je šifrovaný text, $k$ je klíč (posun) a $i in {1, dots, abs(t)}$.
#pause

*Příklad:* Klíčem $k = 2$ zašifrujte #raw("BZ").#pause
- $"'B'" ->#pause ("'B'" + 2) mod 26 =#pause (1 + 2) mod 26 =#pause 3 mod 26 =#pause 3#pause -> "'D'"$#pause
- $"'Z'" ->#pause ("'Z'" + 2) mod 26 =#pause (25 + 2) mod 26 =#pause 27 mod 26 =#pause 1#pause -> "'B'"$

#speaker-note[
  - Hodiny
  - 26 je počet znaků
  - Uvozovky pro odlišení
]

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

#let tabula-recta(subslide, start, plain-text, key) = figure(
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

        if subslide >= start {
          let i = subslide - start
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
#let enciphering-table(subslide, start, plain-text, key) = table(
  fill: (x, y) => {
    if subslide >= start and x == subslide - (start - 1) {
      if y == 0 { green } else if y == 1 { blue } else if y == 2 { red }
    }
  },
  columns: plain-text.len() + 1,
  [*$t$*], ..to-array(plain-text).map(l => raw(l)),
  [*$k$*], ..range(plain-text.len())
    .map(i => to-array(key).at(calc.rem(i, key.len())))
    .map(l => raw(l)),
  [*$c$*], ..range(plain-text.len()).map(i => uncover(str(i + start) + "-", raw(
    str.from-unicode(
      calc.rem(
        (plain-text.at(i).to-unicode() - 65)
          + (key.at(calc.rem(i, key.len())).to-unicode() - 65),
        26,
      )
        + 65,
    ),
  )))
)

#slide(self => columns(2)[
  #let plain-text = "UTOCTE ZA TMY"
  #let key = "MRAK"
  #let plain-text-without-spaces = plain-text.split(" ").join()
  #let start = 6

  #pause

  Zašifrovaný text $c$ je dán jako
  $
    c_i = (t_i + k_(i mod abs(k))) mod 26,
  $
  kde $t$ je šifrovaný text, $k$ je klíč a $i in {1, dots, abs(t)}$.
  #pause

  *Příklad*: Klíčem #raw(key) zašifrujte #raw(plain-text).
  #pause

  #align(center, enciphering-table(
    self.subslide,
    start,
    plain-text-without-spaces,
    key,
  ))
  #pause

  #tabula-recta(self.subslide, start, plain-text-without-spaces, key)
])

== One-time pads (Vernamova šifra)

#slide(self => columns(2)[
  #let plain-text = "HELLO"
  #let key = "HOJOJ"
  #let start = 6
  #pause
  Zašifrovaný text $c$ je dán
  $ c_i = (t_i + k_i) mod 26, $ kde $t$ je šifrovaný text, $k$ je klíč, $abs(t) = abs(k)$ a $i in {1, dots, abs(t)}$.#pause

  *Příklad*: Zašifrujte klíčem #raw(key) text #raw(plain-text).#pause

  #align(center, enciphering-table(self.subslide, start, plain-text, key))
  #pause

  #tabula-recta(self.subslide, start, plain-text, key)

  #speaker-note[
    - Frank Miller v roce 1882 pro telegrafii
    - Neprolomitelná šifra, pokud se klíč udrží v tajnosti
    - Klíč musí být skutečně náhodný, aby nebyl uhodnutelný
    - Klíč musí být alespoň tak dlouhý jako je šifrovaný text (nesmí se použít vícekrát)
  ]
])

== Enigma

#slide(
  columns(
    2,
    [
      #pause
      #figure(
        image("images/enigma.jpg", height: 60%),
        caption: [Stroj Enigma\ (jeden z modelů)#footnote[Převzato z #link("https://en.wikipedia.org/wiki/Enigma_machine#/media/File:Enigma_(crittografia)_-_Museo_scienza_e_tecnologia_Milano.jpg")]],
      )
      #pause
      #colbreak()
      #align(center + horizon, touying-fletcher-diagram(
        node-shape: rect,
        node-corner-radius: 10pt,
        node-stroke: black,

        node((0, -1), name: "input", [Vstup]),
        pause,
        edge(<input>, (0, -0.1), (1, -0.1), "->"),
        node((0.75, 0), name: "plugboard", height: 3em, [Plugboard]),
        pause,
        edge((1, -0.1), (2, -0.1), "->"),
        node((1.75, 0), name: "rotors", height: 3em, [Rotory]),
        pause,
        edge((2, -0.1), (2.25, -0.1), (2.25, 0.1), (2, 0.1), "->"),
        pause,
        edge((2, 0.1), (1, 0.1), "->"),
        pause,
        edge((1, 0.1), (0, 0.1), <output>, "->"),
        node((0, 1), name: "output", [Výstup]),
      ))
    ],
  ),
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

#let enigma-diagram(
  input,
  before-rotors,
  rotor-index,
  after-rotors,
  output,
  fill-color,
  insert-pauses: false,
) = text(
  fill: fill-color,
  $#raw(input) -->^P #raw(before-rotors)#if insert-pauses { pause }
  -->^(R_(#rotor-index)) #raw(after-rotors)#if insert-pauses { pause }
  -->^P #raw(output)$,
)

#slide(
  repeat: 17,
  self => [
    #let cipher-text = "JXATGBGGYWCRYBGDT"
    #let phrase = "WETTERBERICHT"
    #let start = 2

    #text(size: 5pt, [#self.subslide])

    #pause
    #align(center, table(
      columns: range(cipher-text.len() + 2).fold((), (arr, i) => {
        arr.push(35pt)
        arr
      }),
      align: center,
      fill: (x, y) => {
        if self.subslide > 1 and self.subslide <= 4 {
          let i = self.subslide - start + 1
          if x == 0 or x > cipher-text.len() - 1 {
            none
          } else if (
            i < phrase.len() - 1 and cipher-text.at(x - 1) == phrase.at(i)
          ) {
            red
          }
        } else if self.subslide >= 5 + start and x == 4 {
          return green
        } else if self.subslide > 7 + start and x == 5 {
          return teal
        } else if self.subslide > 10 + start and x == 6 {
          return purple
        } else if self.subslide > 11 + start and x == 14 {
          return eastern
        }
      },
      $dots.c$,
      ..range(cipher-text.len()).map(i => $#(i)$),
      $dots.c$,
      $dots.c$,
      ..to-array(cipher-text).map(l => raw(l)),
      $dots.c$,
      ..range(if self.subslide <= start + 1 { 1 } else if self.subslide < 5 {
        self.subslide - start
      } else {
        3
      }).map(i => []),
      ..to-array(phrase).map(l => raw(l))
    ))


    #for _ in range(4) {
      pause
    }

    Předpokládejme, že $#raw("T") ->^P #raw("A")$:#pause

    #align(center)[
      #enigma-diagram("T", "A", 3, "P", "E", green, insert-pauses: true),#pause\
      #enigma-diagram("T", "A", 4, "K", "G", teal, insert-pauses: true),#pause\
      #enigma-diagram("T", "A", 5, "X", "B", purple), #pause\
      #enigma-diagram("T", "A", 14, "T", "G", eastern).#pause
    ]

    Nemůže ale nastat $#raw("T") -->^P #raw("G")$ a $#raw("T") -->^P #raw("A")$, tedy $#raw("T") -->^P #raw("A")$ neplatí.#pause Vyzkoušíme $#raw("T") -->^P #raw("B") dots #raw("T") -->^P #raw("Z")$.#pause Pokud vždy dojde ke sporu, pootočíme rotory.
  ],
)

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

== Eliptické křivky

#let below-sqrt(x) = calc.pow(x, 3) - x + 1
#let elliptic-curve(x) = if below-sqrt(x) > 0 {
  calc.sqrt(below-sqrt(x))
} else { 0 }
#let domain = (-1.32471, 3)
#let samples = 1000
#let sample-at = range(samples).map(i => (
  domain.at(0) + (domain.at(1) - domain.at(0)) / samples * i
))
#let transparent = rgb(0, 0, 0, 0)

#align(center + horizon, touying-cetz-canvas({
  import cetz.draw: *

  set-style(axes: (
    shared-zero: false,
  ))

  plot.plot(
    size: (20, 12),
    y-equal: "x",
    axis-style: "school-book",
    stroke: teal,
    x-tick-step: none,
    y-tick-step: none,
    {
      plot.add(((-3, 0), (3, 0)), style: (stroke: transparent))
      plot.add(sample-at.map(x => (x, elliptic-curve(x))), style: (stroke: red))
      plot.add(sample-at.map(x => (x, -elliptic-curve(x))), style: (
        stroke: red,
      ))
    },
  )
}))
