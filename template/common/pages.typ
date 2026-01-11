// # Pages. Páginas.

#import "components.typ": (
  consider_only_odd_pages, epigraph, glossary, list_of_figures, list_of_tables, not_count_page, not_number_page,
  not_start_on_new_page,
)


// ## Epigraph. Epígrafe.
// NBR 14724:2024 4.2.1.6

// NBR 14724:2024 4.2.1.6, NBR 14724:2024 5.2.4, NBR 14724:2024 5.5
// Epigraph on pre-textual elements can present a quote without following long quote formatting, as determined by NBR 14724:2024 4.2.1.6.
#let include_epigraph(
  indent: false,
  smaller_text: false,
  body,
) = context {
  not_number_page(
    not_start_on_new_page()[
      #page(
        // Epigraph should not have title or numbering.
        // Epigraph should start from the middle of the page to the right, and aligned to the bottom.
        align(end + bottom, {
          box(width: 50%, {
            epigraph(
              indent: indent,
              smaller_text: smaller_text,
              body,
            )
          })
        }),
      )

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ## List of tables. Lista de tabelas.
// NBR 14724:2024 4.2.1.10

#let include_list_of_tables() = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #list_of_tables()
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ## List of figures. Lista de ilustrações.
// NBR 14724:2024 4.2.1.9

#let include_list_of_figures() = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #list_of_figures()
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ## Glossary. Glossário.
// NBR 14724:2024 4.2.3.2

#let include_glossary(title: "Glossário", entries) = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #glossary(
          title: title,
          entries,
        )
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ## Abbreviations. Lista de abreviaturas e siglas.
// NBR 14724:2024 4.2.1.11

#let include_list_of_abbreviations(
  abbreviations_entries,
) = {
  include_glossary(
    title: "Lista de abreviaturas e siglas",
    abbreviations_entries,
  )
}


// ## Symbols. Lista de símbolos.
// NBR 14724:2024 4.2.1.12

#let include_list_of_symbols(
  symbols_entries,
) = {
  include_glossary(
    title: "Lista de símbolos",
    symbols_entries,
  )
}
