// # Pre-textual elements. Elementos pré-textuais.
// NBR 14724:2024 4.2.1

#import "../../data/main.typ": (
  address, advisors, approval_date, area_of_concentration, authors, custom_nature, degree, degree_topic,
  examination_committee, organization, institution, program, subtitle, title, type_of_work, volume_number, year,
)
#import "/template/academic_work/pages.typ": include_cataloging_in_publication, include_errata, include_custom_cataloging_in_publication, include_title_page, include_approval_page
#import "abstract.typ": abstract_in_main_language

// ## Title page. Folha de rosto.
// NBR 14724:2024 4.2.1.1.1

#include_title_page(
  address: address,
  advisors: advisors,
  area_of_concentration: area_of_concentration,
  authors: authors,
  custom_nature: custom_nature,
  degree_topic: degree_topic,
  degree: degree,
  organization: organization,
  program: program,
  subtitle: subtitle,
  title: title,
  type_of_work: type_of_work,
  volume_number: volume_number,
  year: year,
)


// ## Cataloging-in-publication. Ficha catalográfica.
// NBR 14724:2024 4.2.1.1.2

#let keywords_in_main_language = abstract_in_main_language.keywords

// This is just an example for the cataloging in publication. When your institution provides you with the final file, you must use the command `include_custom_cataloging_in_publication`, filling it with the command `image` and with the path to the file.
// Este é apenas um exemplo para a ficha catalográfica. Quando sua instituição fornecer o arquivo final, você deve usar o comando `include_custom_cataloging_in_publication`, preenchendo-o com o comando `image` e com caminho para o arquivo.

#include_cataloging_in_publication(
  address: address,
  advisors: advisors,
  authors: authors,
  degree: degree,
  institution: institution,
  keywords_in_main_language: keywords_in_main_language,
  organization: organization,
  program: program,
  subtitle: subtitle,
  title: title,
  type_of_work: type_of_work,
  volume_number: volume_number,
  year: year,
)

// If you have a file to import, use the command below.
// Se você tem um arquivo para importar, use o comando abaixo.

// #include_custom_cataloging_in_publication(image("../../assets/documents/ficha_catalografica.svg"))


// ## Errata. Errata.
// NBR 14724:2024 4.2.1.2

// #include_errata()[
//   #lorem(50)
// ]


// # Approval page. Folha de aprovação.
// NBR 14724:2024 4.2.1.3

#include_approval_page(
  address: address,
  advisors: advisors,
  approval_date: approval_date,
  area_of_concentration: area_of_concentration,
  authors: authors,
  custom_nature: custom_nature,
  degree_topic: degree_topic,
  degree: degree,
  examination_committee: examination_committee,
  organization: organization,
  program: program,
  subtitle: subtitle,
  title: title,
  type_of_work: type_of_work,
  volume_number: volume_number,
  year: year,
)


#include "dedication.typ"
#include "acknowledgments.typ"
#include "epigraph.typ"
#include "abstract.typ"
#include "list_of_figures.typ"
#include "list_of_tables.typ"
#include "list_of_abbreviations.typ"
#include "list_of_symbols.typ"
#include "outline.typ"
