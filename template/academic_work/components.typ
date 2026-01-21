// # Components. Componentes.

#import "../common/components.typ": print_person, get_advisor_role
#import "../common/style/style.typ": leading_for_common_text
#import "../common/util.typ": capitalize_first_letter, get_gender_ending


// ## Annex. Anexo.
// NBR 14724:2024 4.2.3.4

#let annex(body, title: "", label: none) = {
  // Annexes must be numbered with letters
  set heading(numbering: "A.1.1")

  [
    // When referenced, annexes must have the supplement "Anexo"
    #heading(supplement: "Anexo", title)#label
    #body
  ]
}


// ## Appendix. Apêndice.
// NBR 14724:2024 4.2.3.3

#let appendix(body, title: "", label: none) = {
  // Appendixes must be numbered with letters
  set heading(numbering: "A.1.1")

  [
    // When referenced, appendixes must have the supplement "Apêndice"
    #heading(supplement: "Apêndice", title)#label
    #body
  ]
}


// ## Examiner signature. Assinatura do examinador.
// NBR 14724:2024 4.2.1.3

#let print_examiner(
  examiner: (
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
  role: {
    "orientador"
  },
) = {
  block(
    above: 1.5cm,
  )[
    #block(below: leading_for_common_text)[
      #line(length: 100%)
    ]
    #par()[
      #examiner.prefix
      #print_person(person: examiner)
      #if role != none [
        #sym.dash.en
        #capitalize_first_letter(role)
      ]
      #linebreak()
      #examiner.organization.name
    ]
  ]
}


// ## Institutional information. Informações institucionais.
// NBR 14724:2024 4.2.1.3

#let print_institutional_information(
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
  department: {
    // (
    //   name: "Nome do departamento",
    //   gender: "masculine",
    // )
  },
  program: {
    // (
    //   name: "Nome do programa",
    //   gender: "masculine",
    // )
  },
  joiner: {
    linebreak()
  },
) = {
  [
    #organization.name
    #if institution != none [
      #joiner
      #institution.name
    ]
    #if department != none [
      #joiner
      #department.name
    ]
    #if program != none [
      #joiner
      #program.name
    ]
  ]
}


// ## Nature of the work. Natureza do trabalho.
// NBR 14724:2024 4.2.1.1.1, NBR 14724:2024 4.2.1.3

#let print_nature(
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
  organization: {
    (
      name: "Nome da organização",
      gender: "masculine",
    )
  },
  program: {
    (
      name: "Nome do programa",
      gender: "masculine",
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
  degree_topic: { "Tema do trabalho" },
  area_of_concentration: {
    // "Área de concentração"
  },
) = {
  let gender_ending_of_type_of_work = get_gender_ending(type_of_work.gender)

  let preposition_of_program = "à"
  if program.gender == "masculine" {
    preposition_of_program = "ao"
  }

  let degree_title = degree.title.feminine
  for author in authors {
    if author.gender == "masculine" {
      degree_title = degree.title.masculine
      break
    }
  }

  [
    #capitalize_first_letter(type_of_work.name)
    apresentad#gender_ending_of_type_of_work
    #preposition_of_program
    #program.name
    d#get_gender_ending(organization.gender)
    #organization.name
    como requisito parcial
    à obtenção do título de
    #capitalize_first_letter(degree_title) em
    #degree_topic.
    #if area_of_concentration != none [
      Área de concentração: #area_of_concentration.
    ]
  ]
}

#let print_advisors = (
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
) => {        
  // Advisors
  let is_first_advisor = true
  for advisor in advisors {
    [
      #capitalize_first_letter(get_advisor_role(gender: advisor.gender, is_co_advisor: not is_first_advisor)):
      #advisor.prefix
      #print_person(person: advisor)
      #linebreak()
    ]
    is_first_advisor = false
  }
}