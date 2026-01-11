// Note. Nota.

#import "/template/common/components.typ": note_from_person

#let note_from_gabriel = (margin: false, it) => note_from_person(
  author: "Gabriel",
  color: oklch(75.97%, 0.143, 21deg),
  margin: margin,
  it,
)

#let note_from_igor = (margin: false, it) => note_from_person(
  author: "Igor",
  color: oklch(86.29%, 0.132, 141.76deg),
  margin: margin,
  it,
)

#let note_from_luciana = (margin: false, it) => note_from_person(
  author: "Luciana",
  color: oklch(71.06%, 0.152, 276.03deg),
  margin: margin,
  it,
)
