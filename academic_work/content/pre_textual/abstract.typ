// # Abstract. Resumo.
// NBR 14724:2024 4.2.1.7, NBR 14724:2024 4.2.1.8

#import "../../components/note.typ": note_from_gabriel, note_from_igor
#import "/template/academic_work/pages/pre_textual/abstract.typ": include_abstract
#import "/template/common/components/note.typ": done_note, progress_note, todo_note
#import "/template/common/packages.typ": glossarium

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

      #todo_note(note_from_gabriel[Atualizar no sistema de monografia])

      #progress_note(
        note_from_igor[O resumo estava muito curto. Realmente foi algo dos artigos. Adicionei uma sugestão de resumo estruturado para tentarmos fechar.],
      )

      *Introdução:* O mercado de @jogo:pl autorais apresenta um crescimento contínuo, com milhares de @jogo:pl publicados ao ano nas maiores feiras do mundo.
      Esse crescimento cria uma demanda por melhorias nas ferramentas de apoio à fase de criação.
      Nessa fase, um protótipo passa por @playtest
      repetidamente a fim de identificar desbalanceamentos e estratégias dominantes, o que exige muito tempo e recursos humanos.
      *Objetivos:* Esta pesquisa busca explorar meios para aliviar a necessidade da equipe de @playtest explorar por exaustão os sistemas do @jogo usando @agint:pl.
      Dessa forma, espera-se que os humanos se concentrem nos aspectos da experiência de @jogo e não em testes de estresse.
      *Métodos:* Esta é uma pesquisa exploratória na qual é avaliado o uso de @agint:pl treinados por métodos de @selfplay e reforço não supervisionado inspirada pelo projeto @alphazero, que é baseado nos métodos de @mcts e de @resnet:pl.
      Um conjunto de @jogo:pl por @turno:pl foi implementado, bem como o ambiente de treinamento e avaliação de @estado:pl.
      Dados colhidos durante e após o processo de treinamento são utilizados para levantar observações do comportamento emergente das regras do @jogo.
      *Resultados:* Com as @partida:pl sintéticas, a equipe de desenvolvimento passa a ter um conjunto de milhares de @partida:pl para avaliar, ao invés de algumas dezenas.
      A abordagem permitiu visualizar @estado:pl intermediários avaliados pelos agentes treinados, que podem servir como apoio ao projetista durante o desenvolvimento dos jogos.
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
