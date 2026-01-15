// # Components. Componentes.

#import "./data/glossary/terms.typ": terms_entries
#import "/template/common/components.typ": note_from_person

// ## Note. Nota.

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

// ## Terms. Termos.

#let get_term(term_key, field: "short") = {
  let entry = terms_entries.find(e => e.key == term_key)

  if entry == none {
    panic("Termo não encontrado: " + term_key + ".")
  }

  if field == "short" {
    entry.at("short", default: none)
  } else if field == "long" {
    entry.at("long", default: entry.at("short", default: none))
  } else if field == "custom" {
    entry.at("custom", default: entry.at("short", default: none))
  } else {
    panic("Campo inválido: " + field + ". Use 'short', 'long' ou 'custom'.")
  }
}
