#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.5" as fletcher: node, edge, diagram
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
    show-notes-on-second-screen: right,
  ),
)

#set text(lang: "cs")
#set heading(numbering: "1.1")
#show heading.where(level: 1): set heading(numbering: "1.")

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

== Frekvenční analýza

== Enigma

= Hashování

= Symetrické šifry

= Asymetrické šifry
