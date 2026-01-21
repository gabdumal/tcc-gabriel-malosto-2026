// # Pages. Páginas.


// ## External elements. Elementos externos.


// ### Cover. Capa.
// NBR 14724:2024 4.1.1

#import "../academic_work/components.typ": print_advisors
#import "../common/components.typ": (
  consider_only_odd_pages, not_count_page, not_number_page, not_start_on_new_page, print_people, print_title,
  should_count_this_page,
)
#import "../common/style/style.typ": font_family_sans
#import "components.typ": print_institutional_information

#let include_cover(
  organization: {
    (
      name: "Nome da organização",
      gender: "masculine",
    )
  },
  institution: {
    // (
    //   name: "Nome da instituição",
    //   gender: "masculine",
    // )
  },
  program: {
    // (
    //   name: "Nome do programa",
    //   gender: "masculine",
    // )
  },
  authors: {
    (
      (
        first_name: "Fulano",
        middle_name: none,
        last_name: "Fonseca",
        gender: "masculine",
      ),
    )
  },
  title: { "Título do trabalho" },
  subtitle: {
    // "Subtítulo do trabalho"
  },
  volume_number: {
    // "1"
  },
  address: { "Local" },
  year: { "Ano" },
) = context {
  not_number_page(
    not_count_page(
      not_start_on_new_page()[
        #page()[
          #set align(center)
          #set text(
            font: font_family_sans,
          )

          // Institutional information
          #text(
            weight: "bold",
          )[
            #print_institutional_information(
              organization: organization,
              program: program,
              institution: institution,
            )
          ]

          #v(0.5fr)

          // Authors
          #print_people(
            people: authors,
          )

          #v(0.5fr)

          // Title
          #print_title(
            title: title,
            subtitle: subtitle,
            with_weight: true,
          )

          #v(1fr)

          // Publishing information
          #if volume_number != none [
            Volume #volume_number
            #parbreak()
          ]
          #address
          #linebreak()
          #year
        ]

        #if not consider_only_odd_pages.get() {
          pagebreak(weak: true, to: "odd")
        }
      ],
    ),
  )
}



// ## Pre-textual elements. Elementos pré-textuais.
// NBR 14724:2024 4.2.1

#import "../common/components.typ": (
  consider_only_odd_pages, get_advisor_role, get_styling_for_heading, not_count_page, not_number_page,
  not_start_on_new_page, print_people, print_person, print_title,
)
#import "../common/style/style.typ": (
  font_family_sans, font_size_for_common_text, font_size_for_smaller_text, simple_leading_for_smaller_text,
  spacing_for_smaller_text,
)
#import "../common/util.typ": capitalize_first_letter, get_gender_ending
#import "components.typ": print_examiner, print_nature
print_institutional_information,


// ### Abstract. Resumo.
// NBR 14724:2024 4.2.1.7, NBR 14724:2024 4.2.1.8

#let include_abstract(
  keywords_title: { "Palavras-chave" },
  keywords: {
    (
      "primeira palavra-chave",
      "segunda palavra-chave",
      "terceira palavra-chave",
    )
  },
  title: { "Resumo" },
  body: { "Conteúdo do resumo." },
) = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #heading(
          numbering: none,
          outlined: false,
        )[
          #title
        ]

        #align(left)[
          #body

          // Following ABNTEX2
          #v(18pt)

          // NBR 6028:2021
          // Keywords are preceded by a title and colon.
          // Keywords are separated by semicolons and end with a period.
          // Keywords are not capitalized.
          #par(
            first-line-indent: 0em,
          )[
            #text(weight: "bold")[#keywords_title:]
            #keywords.join("; ").
          ]
        ]
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ### Acknowledgments. Agradecimentos.
// NBR 14724:2024 4.2.1.6

#let include_acknowledgments(
  body,
) = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #heading(
          numbering: none,
          outlined: false,
        )[
          Agradecimentos
        ]
        #body
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ### Approval page. Folha de aprovação.
// NBR 14724:2024 4.2.1.3, NBR 14724:2024 5.2.4

#let include_approval_page(
  authors: {
    (
      (
        first_name: "Fulano",
        middle_name: none,
        last_name: "Fonseca",
        gender: "masculine",
      ),
    )
  },
  title: { "Título do trabalho" },
  subtitle: {
    // "Subtítulo do trabalho"
  },
  volume_number: {
    // "1"
  },
  organization: {
    (
      name: "Nome da organização",
      gender: "masculine",
    )
  },
  program: {
    // (
    //   name: "Nome do programa",
    //   gender: "masculine",
    // )
  },
  type_of_work: {
    (
      name: "trabalho de conclusão de curso",
      gender: "masculine",
    )
  },
  degree: {
    // (
    //   name: "bacharelado",
    //   title: (
    //     masculine: "bacharel",
    //     feminine: "bacharela",
    //   ),
    // )
  },
  degree_topic: { "Tema do trabalho" },
  area_of_concentration: {
    // "Área de concentração"
  },
  advisors: {
    (
      (
        first_name: "Ciclana",
        middle_name: "de",
        last_name: "Castro",
        gender: "feminine",
        prefix: {
          // "Profª Drª"
        },
        organization: (
          name: "Nome da organização",
          gender: "feminine",
        ),
      ),
    )
  },
  examination_committee: {
    (
      (
        first_name: "Beltrano",
        middle_name: none,
        last_name: "Borges",
        gender: "masculine",
        prefix: {
          "Prof. Dr."
        },
        organization: (
          name: "Nome da organização",
          gender: "feminine",
        ),
      ),
    )
  },
  address: { "Local" },
  year: { "Ano" },
  custom_nature: {
    "Natureza do trabalho."
  },
  approval_date: {
    (
      day: [dia],
      month: [mês por extenso],
      year: [ano],
    )
  },
) = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        // Approval page should not have title or numbering.
        #set align(center)
        #set text(
          font: font_family_sans,
        )

        // Authors
        #print_people(
          people: authors,
        )

        #v(0.25fr)

        // Title
        #print_title(
          title: title,
          subtitle: subtitle,
          with_weight: true,
        )

        #if volume_number != none [
          Volume #volume_number
          #parbreak()
        ]

        #v(0.25fr)

        #align(end)[
          #box(width: 50%)[
            #set align(start)
            #set text(
              size: font_size_for_smaller_text,
            )
            #set par(
              leading: simple_leading_for_smaller_text,
              spacing: spacing_for_smaller_text,
            )
            #if custom_nature != none [
              #custom_nature
            ] else [
              #print_nature(
                authors: authors,
                organization: organization,
                program: program,
                type_of_work: type_of_work,
                degree: degree,
                degree_topic: degree_topic,
                area_of_concentration: area_of_concentration,
              )
            ]
          ]
        ]

        #v(0.25fr)

        #align(start)[
          Aprovad#get_gender_ending(type_of_work.gender) em
          #approval_date.day
          de #approval_date.month
          de #approval_date.year
        ]

        #v(0.25fr)

        // Examination committee
        #text(weight: "bold")[
          Banca examinadora
        ]

        #let is_first_advisor = true
        #for advisor in advisors {
          print_examiner(examiner: advisor, role: get_advisor_role(
            gender: advisor.gender,
            is_co_advisor: not is_first_advisor,
          ))
          is_first_advisor = false
        }
        #for examiner in examination_committee {
          print_examiner(
            examiner: examiner,
            role: none,
          )
        }
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ### Cataloging-in-publication. Ficha catalográfica.
// NBR 14724:2024 4.2.1.1.2

#let parameters = (
  authors: {
    (
      (
        first_name: "Fulano",
        middle_name: none,
        last_name: "Fonseca",
        gender: "masculine",
      ),
    )
  },
  title: { "Título do trabalho" },
  subtitle: {
    // "Subtítulo do trabalho"
  },
  volume_number: {
    // "1"
  },
  address: { "Local" },
  year: { "Ano" },
  advisors: {
    (
      (
        first_name: "Ciclana",
        middle_name: "de",
        last_name: "Castro",
        gender: "feminine",
      ),
    )
  },
  type_of_work: {
    (
      name: "trabalho de conclusão de curso",
      gender: "masculine",
    )
  },
  degree: {
    (
      name: "bacharelado",
      title: (
        masculine: "bacharel",
        feminine: "bacharela",
      ),
    )
  },
  organization: {
    (
      name: "Nome da organização",
      gender: "masculine",
    )
  },
  institution: {
    // (
    //   name: "Nome da instituição",
    //   gender: "masculine",
    // )
  },
  program: {
    // (
    //   name: "Nome do programa",
    //   gender: "masculine",
    // )
  },
  keywords_in_main_language: {
    (
      "primeira palavra-chave",
      "segunda palavra-chave",
      "terceira palavra-chave",
    )
  },
)

#let page_definitions(
  authors: parameters.authors,
  title: parameters.title,
  subtitle: parameters.subtitle,
  volume_number: parameters.volume_number,
  address: parameters.address,
  year: parameters.year,
  advisors: parameters.advisors,
  type_of_work: parameters.type_of_work,
  degree: parameters.degree,
  organization: parameters.organization,
  institution: parameters.institution,
  program: parameters.program,
  keywords_in_main_language: parameters.keywords_in_main_language,
) = page()[
  #set align(center + bottom)
  #set text(font: font_family_sans, size: font_size_for_smaller_text)
  #set par(first-line-indent: 0.5cm, leading: simple_leading_for_smaller_text, spacing: simple_leading_for_smaller_text)

  #box(
    stroke: (thickness: auto),
    width: 14.5cm,
    height: 10.2cm,
    inset: (
      x: 1.1cm,
      y: 0.5cm,
    ),
  )[
    #set align(start + horizon)

    #print_person(person: authors.at(0), last_name_first: true).
    #parbreak()

    #print_title(title: title, subtitle: subtitle, with_weight: false)
    #sym.slash
    #print_people(people: authors).
    #sym.dash.en
    #if volume_number != none { "v. " + volume_number + sym.space + sym.dash.en }
    #address,
    #year.

    #context { counter(page).final().at(0) }
    #if consider_only_odd_pages.get() [f.] else [p.]
    #if (counter(figure.where(kind: image)).final().first() > 0) [: il.]
    #parbreak()#linebreak()

    #let is_first_advisor = true
    #for advisor in advisors {
      [
        #capitalize_first_letter(get_advisor_role(gender: advisor.gender, is_co_advisor: not is_first_advisor)):
        #print_person(person: advisor)
        #parbreak()
      ]
      is_first_advisor = false
    }

    #if (
      type_of_work.name == "trabalho de conclusão de curso"
    ) [Trabalho de Conclusão de Curso] else [#capitalize_first_letter(type_of_work.name)]
    (#degree.name)
    #sym.dash.en
    #organization.name#if institution != none { [, #institution.name] }.
    #if program != none { [#program.name,] }
    #if volume_number != none { "v. " + volume_number + sym.comma }
    #year.
    #parbreak()#linebreak()

    #let keywords_counter = 1
    #for keyword in keywords_in_main_language {
      numbering("1. ", keywords_counter)
      [#capitalize_first_letter(keyword). ]
      keywords_counter += 1
    }
    #let notes_counter = 1
    #for advisor in advisors {
      numbering("I. ", notes_counter)
      [#print_person(person: advisor, last_name_first: true),
        #if notes_counter > 1 { "co" }orient.
      ]
      notes_counter += 1
    }
    #if institution != none {
      numbering("I. ", notes_counter)
      [#institution.name.]
      notes_counter += 1
    }
    #{
      numbering("I. ", notes_counter)
      [Título.]
    }
  ]
]

#let include_cataloging_in_publication(
  authors: parameters.authors,
  title: parameters.title,
  subtitle: parameters.subtitle,
  volume_number: parameters.volume_number,
  address: parameters.address,
  year: parameters.year,
  advisors: parameters.advisors,
  type_of_work: parameters.type_of_work,
  degree: parameters.degree,
  organization: parameters.organization,
  institution: parameters.institution,
  program: parameters.program,
  keywords_in_main_language: parameters.keywords_in_main_language,
) = context {
  not_number_page(
    not_start_on_new_page()[
      #if consider_only_odd_pages.get() {
        not_count_page(
          page_definitions(
            authors: authors,
            title: title,
            subtitle: subtitle,
            volume_number: volume_number,
            address: address,
            year: year,
            advisors: advisors,
            type_of_work: type_of_work,
            degree: degree,
            organization: organization,
            institution: institution,
            program: program,
            keywords_in_main_language: keywords_in_main_language,
          ),
        )
      } else {
        page_definitions(
          authors: authors,
          title: title,
          subtitle: subtitle,
          volume_number: volume_number,
          address: address,
          year: year,
          advisors: advisors,
          type_of_work: type_of_work,
          degree: degree,
          organization: organization,
          institution: institution,
          program: program,
          keywords_in_main_language: keywords_in_main_language,
        )
      }
    ],
  )
}


// ### Custom cataloging-in-publication. Ficha catalográfica customizada.
// NBR 14724:2024 4.2.1.1.2

#let include_custom_cataloging_in_publication(
  body,
) = context {
  set page(margin: 0em)
  set text(font: font_family_sans)
  not_number_page(
    not_start_on_new_page()[
      #if consider_only_odd_pages.get() {
        not_count_page(
          body,
        )
      } else {
        body
      }
    ],
  )
}


// ### Dedication. Dedicatória.
// NBR 14724:2024 4.2.1.4, NBR 14724:2024 5.2.4

#let include_dedication(
  body,
) = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        // Dedication should not have title or numbering.
        // Dedication should start from the middle of the page to the right, and aligned to the bottom.
        #align(end + bottom)[
          #box(width: 50%)[
            #set align(start)
            #body
          ]
        ]
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ### Errata. Errata.
// NBR 14724:2024 4.2.1.2

#let include_errata(
  body,
) = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #heading(
          numbering: none,
          outlined: false,
        )[
          Errata
        ]
        #body
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ## Outline. Sumário.
// NBR 6027:2012, NBR 14724:2024 4.2.1.13

#let include_outline() = context {
  set text(
    font: font_family_sans,
  )
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #show outline.entry: it => {
          let (
            font_size,
            leading_around,
            spacing_around,
            font_weight,
            text_style,
          ) = get_styling_for_heading(it)

          set text(
            font: font_family_sans,
            size: font_size,
            weight: font_weight,
            style: text_style,
          )

          let prefix = it.prefix()
          if it.element.supplement == [Apêndice] {
            prefix = [APÊNDICE #prefix ---]
          }
          if it.element.supplement == [Anexo] {
            prefix = [ANEXO #prefix ---]
          }

          block(
            below: spacing_around,
          )[
            #link(it.element.location(), it.indented([#prefix], it.inner()))
          ]
        }

        #outline(
          depth: 5,
          indent: 0em,
        )
      ]

      #if not consider_only_odd_pages.get() {
        pagebreak(weak: true, to: "odd")
      }
    ],
  )
}


// ## Title page. Folha de rosto.
// NBR 14724:2024 4.2.1.1.1

#let include_title_page(
  authors: {
    (
      (
        first_name: "Fulano",
        middle_name: none,
        last_name: "Fonseca",
        gender: "masculine",
      ),
    )
  },
  title: { "Título do trabalho" },
  subtitle: {
    // "Subtítulo do trabalho"
  },
  volume_number: {
    // "1"
  },
  organization: {
    (
      name: "Nome da organização",
      gender: "masculine",
    )
  },
  program: {
    // (
    //   name: "Nome do programa",
    //   gender: "masculine",
    // )
  },
  type_of_work: {
    // (
    //   name: "trabalho de conclusão de curso",
    //   gender: "masculine",
    // )
  },
  degree: {
    // (
    //   name: "bacharelado",
    //   title: (
    //     masculine: "bacharel",
    //     feminine: "bacharela",
    //   ),
    // )
  },
  degree_topic: { "Tema do trabalho" },
  area_of_concentration: {
    // "Área de concentração"
  },
  advisors: {
    (
      (
        first_name: "Ciclana",
        middle_name: "de",
        last_name: "Castro",
        gender: "feminine",
        prefix: {
          // "Profª Drª"
        },
      ),
    )
  },
  address: { "Local" },
  year: { "Ano" },
  custom_nature: {
    "Natureza do trabalho."
  },
) = context {
  not_number_page(
    not_start_on_new_page()[
      #page()[
        #set align(center)
        #set text(font: font_family_sans)

        // Authors
        #print_people(people: authors)

        #v(1fr)

        // Title
        #print_title(title: title, subtitle: subtitle, with_weight: true)

        #if volume_number != none [
          Volume #volume_number
          #parbreak()
        ]

        #v(1fr)

        #align(end)[
          #box(width: 50%)[
            #set align(start)
            #set text(size: font_size_for_smaller_text)
            #set par(leading: simple_leading_for_smaller_text, spacing: spacing_for_smaller_text)
            #if custom_nature != none [
              #custom_nature
            ] else [
              #print_nature(
                authors: authors,
                organization: organization,
                program: program,
                type_of_work: type_of_work,
                degree: degree,
                degree_topic: degree_topic,
                area_of_concentration: area_of_concentration,
              )
            ]
          ]
        ]

        #v(1fr)

        // Advisors
        #print_advisors(advisors: advisors)

        #v(1fr)

        // Publishing information
        #address
        #linebreak()
        #year
      ]
    ],
  )
}
