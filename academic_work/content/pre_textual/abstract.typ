// # Abstract. Resumo.
// NBR 14724:2024 4.2.1.7, NBR 14724:2024 4.2.1.8

#import "../../components/note.typ": note_from_gabriel
#import "/template/academic_work/pages/pre_textual/abstract.typ": include_abstract
#import "/template/common/components/note.typ": progress_note, todo_note

#let abstract_in_main_language = {
  (
    keywords_title: "Palavras-chave",
    keywords: (
      "agentes inteligentes",
      "AlphaZero",
      "play-test",
      "self-play",
    ),
    title: "Resumo",
    body: [

      #progress_note(note_from_gabriel[Aprimorar resumo e atualizar no sistema de monografia])

      O mercado em ascensão de @jogo:pl autorais requer métodos de apoio no processo de criação.
      Nessa fase, um protótipo passa por @pt:pl repetidos a fim de identificar desbalanços, o que exige tempo e recursos humanos.
      Por meio desta pesquisa exploratória, avaliamos o uso de @agint:pl treinados por métodos de @sp e reforço não supervisionado.
      Este processo é inspirado pelo projeto @az que utiliza os métodos de @mcts e de @resnet:pl.

      #todo_note(
        note_from_gabriel[Trocar palavra chave "play-test" para "play-testing", e atualizar no sistema de monografias],
      )

    ],
  )
}

#let first_abstract_in_secondary_language = {
  (
    keywords_title: "Keywords",
    keywords: (
      "intelligent agents",
      "AlphaZero",
      "play-test",
      "self-play",
    ),
    title: "Abstract",
    body: [
      #text(
        lang: "en",
        region: "us",
      )[

        #todo_note(note_from_gabriel[Traduzir resumo])

      ]
    ],
  )
}

// Include in this list all abstracts in the order they should appear.
#let abstracts = (
  abstract_in_main_language,
  first_abstract_in_secondary_language,
)

#for abstract in abstracts {
  include_abstract(
    body: abstract.body,
    keywords_title: abstract.keywords_title,
    keywords: abstract.keywords,
    title: abstract.title,
  )
}
