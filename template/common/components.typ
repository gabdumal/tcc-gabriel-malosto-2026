// # Components. Componentes.

#import "../common/style/style.typ": (
  font_family_math_text, font_family_sans, font_family_serif, font_size_for_common_text, font_size_for_level_1_headings,
  font_size_for_level_2_headings, font_size_for_level_3_and_beyond_headings, font_size_for_smaller_text,
  leading_for_bibliography, leading_for_common_text, leading_for_level_1_headings, leading_for_level_2_headings,
  leading_for_level_3_and_beyond_headings, simple_leading_for_smaller_text, simple_spacing_for_smaller_text,
  spacing_for_bibliography, spacing_for_common_text, spacing_for_level_1_headings, spacing_for_level_2_headings,
  spacing_for_level_3_and_beyond_headings, spacing_for_smaller_text,
)
#import "../common/util.typ": get_gender_ending
#import "../packages.typ": drafting, glossarium


// ## Advisors. Orientadores.

#let get_advisor_role(
  gender: "masculine",
  is_co_advisor: false,
) = {
  if is_co_advisor {
    "co"
  }
  "orientador"
  if gender == "feminine" {
    "a"
  }
}


// ## Bibliography. Referências.
// NBR 6023:2025 6, NBR 14724:2024 4.2.3.1

#let format_bibliography(body) = {
  set par(leading: leading_for_bibliography, spacing: spacing_for_bibliography)
  body
}


// ## Quotes. Citações.
// NBR 14724:2024 5.5, NBR 10520:2023 7.1.1

#let format_quote(
  indent: true,
  smaller_text: true,
  body,
) = {
  let font_size = font_size_for_common_text
  let leading = leading_for_common_text
  let spacing = spacing_for_common_text

  // Long quotes should have a smaller font size than the main text.
  if smaller_text {
    font_size = font_size_for_smaller_text
    leading = simple_leading_for_smaller_text
    spacing = spacing_for_smaller_text
  }

  set text(
    size: font_size,
  )
  set par(
    leading: leading,
    spacing: spacing,
  )

  pad(
    // Long quotes should have a 4cm space on the left side.
    left: if indent { 4cm } else { 0cm },
  )[
    #block()[
      #body.body
      #if body.attribution != none [#body.attribution]
    ]
  ]
}


// ## Epigraph. Epígrafe.
// NBR 14724:2024 4.2.1.6

// NBR 14724:2024 4.2.1.6, NBR 14724:2024 5.2.4, NBR 14724:2024 5.5
#let epigraph(
  indent: true,
  smaller_text: true,
  body,
) = context {
  // Align text to the right
  set align(end)
  show quote: it => format_quote(
    indent: indent,
    smaller_text: smaller_text,
  )[#it]
  body
}


// ## Equation. Equação.
// NBR 14724:2024 5.7

#let equation(
  placement: none,
  width: auto,
  body,
) = {
  set text(
    font: font_family_math_text,
  )
  set math.equation(numbering: "(1.1)")

  let equation_block = align(
    center,
    block(
      sticky: true,
      width: width,
      align(
        start,
        body,
      ),
    ),
  )

  if placement == none {
    equation_block
  } else {
    let alignment = if (
      placement == auto
    ) {
      auto
    } else if (placement == top or placement == bottom) {
      placement + center
    } else {
      panic("Placement should be one of the following options: none, auto, top, bottom")
    }
    place(
      alignment,
      float: true,
      equation_block,
    )
  }
}


// ## Source. Fonte.
// NBR 14724:2024 5.8,NBR 14724:2024 5.9

#let print_source_for_content_created_by_authors(
  start_with_uppercase: false,
) = {
  [#if start_with_uppercase { "E" } else { "e" }laboração própria]
}


// ## Information footer. Rodapé de informação.

#let information_footer(
  note: none,
  source: none,
) = [
  // Figures must have a source
  Fonte:
  #if source == none {
    [#print_source_for_content_created_by_authors().]
  } else {
    source
  }
  #linebreak()
  #if note != none {
    if type(note) == array {
      for (index, item) in note.enumerate() {
        [Nota #(index + 1): #item]
        linebreak()
      }
    } else {
      [Nota: #note]
    }
  }
]


// ## Figures. Figuras.
// NBR 14724:2024 5.8, NBR 14724:2024 5.9

#let format_caption_of_figure(
  width: auto,
  caption,
) = {
  // NBR 14724:2024 5.8
  // The caption of a figure should be in a smaller font size
  set text(
    size: font_size_for_smaller_text,
  )
  // The caption of a figure should have a smaller leading and spacing
  set par(
    leading: simple_leading_for_smaller_text,
    spacing: spacing_for_smaller_text,
  )
  caption
}

#let format_information_of_figure(
  note: none,
  source: none,
) = context {
  // NBR 14724:2024 5.8
  // Source and notes should be in a smaller font size
  set par(
    first-line-indent: 0em,
    leading: simple_leading_for_smaller_text,
    spacing: spacing_for_smaller_text,
  )
  set text(
    size: font_size_for_smaller_text,
  )
  // Source and notes should be aligned to the left
  set align(start)

  block(
    above: spacing_for_smaller_text,
    below: spacing_for_smaller_text,
  )[
    #set par(
      leading: simple_leading_for_smaller_text,
      spacing: simple_spacing_for_smaller_text,
    )
    #information_footer(note: note, source: source)
  ]
}

#let include_information_of_figure(
  note: none,
  source: none,
  width: auto,
) = {
  set align(center)
  block(
    above: spacing_for_smaller_text,
    below: spacing_for_smaller_text,
    width: width,
  )[
    #format_information_of_figure(
      source: source,
      note: note,
    )
  ]
}

#let format_figure(
  include_information: false,
  note: none,
  source: none,
  sticky: false,
  it,
) = {
  layout(size => {
    let width_of_figure_body = measure(
      width: size.width,
      it.body,
    ).width

    block(
      breakable: true,
      sticky: sticky,
      width: 100%,
    )[
      #block(
        sticky: true,
        width: width_of_figure_body,
        below: spacing_for_smaller_text,
        format_caption_of_figure(it.caption),
      )
      #show figure: it => {
        align(
          bottom,
          format_figure(it),
        )
      }
      #it.body
      #if include_information {
        include_information_of_figure(
          source: source,
          note: note,
          width: width_of_figure_body,
        )
      }
    ]
  })
}

#let describe_figure(
  note: none,
  placement: none,
  source: none,
  sticky: false,
  body,
) = {
  set block(breakable: true)

  show figure: it => {
    set block(breakable: true)
    if placement == none {
      format_figure(
        include_information: true,
        note: note,
        source: source,
        sticky: sticky,
        it,
      )
    } else {
      let alignment = if (
        placement == auto
      ) {
        auto
      } else if (placement == top or placement == bottom) {
        placement + center
      } else {
        panic("Placement should be one of the following options: none, auto, top, bottom")
      }

      set block(breakable: true)
      place(
        clearance: spacing_for_smaller_text,
        float: true,
        alignment,
        format_figure(
          include_information: true,
          note: note,
          source: source,
          it,
        ),
      )
    }
  }

  body
}


// ## Footnotes. Notas de rodapé.
// NBR 14724:2024 5.2.1

#let format_footnote_entry(body) = context {
  set text(size: font_size_for_smaller_text)

  // TODO: This is broken on Typst version 0.13.1. Reinclude this when editing notes does not break the link functionality.
  // grid(
  //   columns: 2,
  //   gutter: 0.25em,
  //   body.note, body.note.body,
  // )

  // TODO: Remove this when editing notes does not break the link functionality.
  par(
    leading: simple_leading_for_smaller_text,
    spacing: simple_spacing_for_smaller_text,
    first-line-indent: 0em,
    hanging-indent: measure(body.note).width,
  )[
    #body
  ]
}


// ## Glossary. Glossário.
// NBR 14724:2024 4.2.1.11, 4.2.1.12, 4.2.3.2

#let glossary(
  invisible: false,
  title: "Glossário",
  entries,
) = {
  let print_glossary = () => glossarium.print-glossary(
    deduplicate-back-references: true,
    description-separator: ". ",
    invisible: invisible,
    entries,
  )

  if invisible == false {
    set text(
      font: font_family_sans,
    )
    set heading(
      numbering: none,
      outlined: false,
    )
    heading(level: 1, title)
    print_glossary()
  } else {
    print_glossary()
  }
}


// ## Page. Página.

#let should_number_this_page = state("should_number_this_page", true)
#let should_count_this_page = state("should_count_this_page", true)

#let consider_only_odd_pages = state("consider_only_odd_pages", true)

#let not_number_page(
  body,
) = {
  should_number_this_page.update(false)
  body
  should_number_this_page.update(true)
}

#let not_count_page(
  body,
) = {
  should_count_this_page.update(false)
  body
  should_count_this_page.update(true)
}

#let format_header(number_pages) = context {
  // Regress page counter if this page should not be counted
  let actual_page_number = here().page()
  let page_number_to_display = counter(page).get().at(0)

  if should_count_this_page.get() == false {
    counter(page).update(n => calc.max(n - 1, 0))
    page_number_to_display += -1
  }

  // NBR 14724:2024 5.3
  // Numbering should be on the right for odd pages and on the left for even pages.
  let alignment = if consider_only_odd_pages.get() {
    end
  } else {
    if calc.rem(actual_page_number, 2) == 1 {
      end
    } else {
      start
    }
  }

  if number_pages {
    // Display page number in the header
    if should_number_this_page.get() {
      align(alignment)[
        #text(
          font: font_family_serif,
          size: font_size_for_smaller_text,
        )[
          #page_number_to_display
        ]
      ]
    }
  }
}


// ## Headings. Títulos.

#let should_start_on_new_page = state(
  "should_start_on_new_page",
  true,
)

#let get_styling_for_heading(body) = {
  let font_size = font_size_for_common_text
  let leading_around = leading_for_level_3_and_beyond_headings
  let spacing_around = spacing_for_level_3_and_beyond_headings
  let font_weight = "bold"
  let text_style = "normal"

  if body.level == 1 {
    font_size = font_size_for_level_1_headings
    leading_around = leading_for_level_1_headings
    spacing_around = spacing_for_level_1_headings
  } else if body.level == 2 {
    font_size = font_size_for_level_2_headings
    leading_around = leading_for_level_2_headings
    spacing_around = spacing_for_level_2_headings
  } else if body.level == 3 {
    font_size = font_size_for_level_3_and_beyond_headings
  } else if body.level == 4 {
    font_weight = "regular"
  } else if body.level == 5 {
    font_weight = "regular"
    text_style = "italic"
  }

  return (font_size, leading_around, spacing_around, font_weight, text_style)
}

#let not_start_on_new_page(
  body,
) = {
  should_start_on_new_page.update(false)
  body
  should_start_on_new_page.update(true)
}

#let format_heading(
  body,
) = {
  // NBR 6024:2012 4.1
  // The format of headings should represent their hierarchical level
  // As done by abnTEX2, we use different font sizes for different heading levels

  // Styling
  let (
    font_size,
    leading_around,
    spacing_around,
    font_weight,
    text_style,
  ) = get_styling_for_heading(body)
  let text_before_numbering = none
  let text_after_numbering = none
  let column_gutter = measure(sym.dash).width

  // NBR 14724:2024 5.2.2
  // Headings should have 1.5x of spacing above and below
  set par(
    leading: leading_around,
    spacing: spacing_around,
    first-line-indent: 0em,
  )
  set text(
    font: font_family_sans,
    size: font_size,
    weight: font_weight,
    style: text_style,
  )

  // Level 1 headings should start on a new page
  if body.level == 1 {
    if should_start_on_new_page.get() {
      // NBR 14724:2024 5.2.2
      // If considering odd/even pages, sections should start on odd pages
      if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
      pagebreak(weak: true)
    }
    if body.supplement == [Apêndice] {
      // NBR 14724:2024 4.2.3.3
      // Appendixes must have the supplement "APÊNDICE" before its numbering and an em-dash after it
      text_before_numbering = "APÊNDICE"
      text_after_numbering = sym.dash.em
      column_gutter = measure(sym.space).width
    }
    if body.supplement == [Anexo] {
      // NBR 14724:2024 4.2.3.4
      // Annexes must have the supplement "ANEXO" before its numbering and an em-dash after it
      text_before_numbering = "ANEXO"
      text_after_numbering = sym.dash.em
      column_gutter = measure(sym.space).width
    }
  }

  if body.numbering == none {
    // NBR 6024:2012 4.1
    // Headings without numbering should be aligned to the center
    align(center)[
      #block(
        above: spacing_around,
        below: spacing_around,
      )[#body.body]
    ]
  } else {
    block(
      above: spacing_around,
      below: spacing_around,
      // NBR 6024:2012 4.1
      // For headings with multiple lines, each subsequent line should be aligned with the first one
      grid(
        columns: 2,
        rows: 1,
        // Numbering indicator should be separated from the title by a single space
        column-gutter: column_gutter,
        [
          #text_before_numbering
          #counter(heading).display(body.numbering)       #text_after_numbering
        ],
        [#body.body],
      ),
    )
  }
}


// ## List of figures. Lista de ilustrações.
// NBR 14724:2024 4.2.1.9


#let list_of_figures() = {
  set text(
    font: font_family_sans,
  )

  // TODO: there should be an em-dash between the numbering and the caption
  show outline.entry: it => {
    let kind = it.element.kind
    if kind != table {
      it
    }
  }

  outline(
    title: "Lista de ilustrações",
    target: figure,
  )
}


// ## List of tables. Lista de tabelas.
// NBR 14724:2024 4.2.1.10

#let list_of_tables() = {
  set text(
    font: font_family_sans,
  )

  // TODO: there should be an em-dash between the numbering and the caption

  outline(
    title: "Lista de tabelas",
    target: figure.where(kind: table),
  )
}


// ## Note. Nota.


#let color_of_stroke_of_notes = oklch(80.78%, 0, 0deg)
#let thickness_of_stroke_of_notes = 0.125em

#let inline_note = drafting.inline-note
#let margin_note = drafting.margin-note

#let box_of_note(
  color_of_stroke: none,
  fill: none,
  width: auto,
  it,
) = {
  set text(
    font: font_family_sans,
  )
  block(
    clip: true,
    fill: fill,
    inset: 0.5em,
    radius: 0.5em,
    stroke: stroke(
      paint: color_of_stroke.paint,
      thickness: thickness_of_stroke_of_notes,
    ),
    width: width,
    it,
  )
}

#let set_default_notes = {
  drafting.set-margin-note-defaults(
    fill: color.white,
    rect: (
      fill: none,
      stroke: none,
      width: auto,
      it,
    ) => box_of_note(
      fill: fill,
      color_of_stroke: stroke,
      width: width,
      it,
    ),
    stroke: stroke(
      paint: color_of_stroke_of_notes,
    ),
  )
}

#let display_prefix = (
  fill: none,
  it,
) => {
  let space = 0.44em
  box(
    inset: (
      right: space,
    ),
    box(
      fill: fill,
      outset: space,
      text(
        weight: "bold",
        it,
      ),
    ),
  )
}

#let note_with_prefix = (
  color: none,
  prefix: none,
  it,
) => {
  drafting.set-margin-note-defaults(
    fill: color.desaturate(80%),
    rect: (
      fill: none,
      stroke: none,
      width: auto,
      it,
    ) => box_of_note(
      fill: fill,
      color_of_stroke: stroke,
      width: width,
      {
        display_prefix(
          fill: color,
          prefix,
        )
        sym.space
        it
      },
    ),
  )
  it
  set_default_notes
}

#let todo_note = it => note_with_prefix(
  color: oklch(90%, 0.16, 63deg),
  prefix: "TODO",
  it,
)

#let progress_note = it => note_with_prefix(
  color: oklch(86.15%, 0.191, 123.56deg),
  prefix: "PROG",
  it,
)

#let done_note = it => note_with_prefix(
  color: oklch(74.73%, 0.136, 248.74deg),
  prefix: "DONE",
  it,
)

#let note_from_person = (
  author: "author",
  color: none,
  margin: false,
  it,
) => {
  let stroke = stroke(
    paint: color,
  )
  let content = {
    text(
      weight: "bold",
      [#author: ],
    )
    it
  }
  if margin == true {
    margin_note(
      stroke: stroke,
      content,
    )
  } else {
    inline_note(
      stroke: stroke,
      content,
    )
  }
}


// ## People. Pessoas.

#let print_person(
  person: (
    first_name: "Fulano",
    middle_name: none,
    last_name: "Fonseca",
    gender: "masculine",
  ),
  last_name_first: false,
) = {
  if last_name_first {
    person.last_name + ", "
    person.first_name
    if person.middle_name != none { " " + person.middle_name }
  } else {
    person.first_name + sym.space
    if person.middle_name != none { person.middle_name + sym.space }
    person.last_name
  }
}

#let print_people(
  people: (),
  joiner: ", ",
) = {
  (
    people
      .map(person => print_person(
        person: person,
        last_name_first: false,
      ))
      .join(joiner)
  )
}


// ## Tables. Tabelas.
// NBR 14724:2024 5.9, IBGE Apresentação tabular 1993

#let format_table(body) = {
  // IBGE Apresentação tabular 1993 4.3.3
  // Tables should not have vertical lines
  // Tables should have horizontal lines only around header and at bottom of the table
  set table(stroke: (x, y) => (
    top: if y <= 1 { 1pt } else { 0pt },
    bottom: 1pt,
  ))

  // Table header should be bold
  show table.cell.where(y: 0): strong

  // The first column should be left-aligned, and the following columns should be right-aligned
  set table(
    align: (x, y) => {
      if y == 0 { center } else if x == 0 { left } else { right }
    },
  )

  // The content of a table should be in a smaller font size
  set text(
    size: font_size_for_smaller_text,
  )
  set par(
    leading: simple_leading_for_smaller_text,
    spacing: spacing_for_smaller_text,
  )
  body
}


// ## Title. Título do trabalho.

#let print_title(
  title: "Título do trabalho",
  subtitle: none,
  with_weight: true,
) = {
  let weight = if with_weight { "bold" } else { "regular" }
  text(
    weight: weight,
  )[
    #title#if subtitle != none [:
      #text(
        weight: "regular",
      )[
        #subtitle
      ]
    ]
  ]
}
