// # Abstract. Resumo.
// NBR 14724:2024 4.2.1.7, NBR 14724:2024 4.2.1.8

#import "/academic_work/components/note.typ": note_from_gabriel, note_from_igor
#import "/template/academic_work/pages.typ": include_abstract
#import "/template/common/components.typ": done_note, progress_note, todo_note
#import "/template/packages.typ": glossarium

#let abstract_in_main_language = {
  (
    keywords_title: "Palavras-chave",
    keywords: (
      "game design",
      "play-test automático",
      "AlphaZero",
      "redes neurais artificiais",
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
      "game design",
      "automated play-test",
      "AlphaZero",
      "artificial neural networks",
    ),
    title: "Abstract",
    body: [
      #text(
        lang: "en",
        region: "us",
      )[

        *Introduction:* The market for original board games shows continuous growth, with thousands of games published annually at the world's largest fairs.
        This growth creates a demand for improvements in tools supporting the creation phase.
        In this phase, a prototype undergoes play-test repeatedly to identify imbalances and dominant strategies, which requires significant time and human resources.
        *Objectives:* This research seeks to explore ways to alleviate the need for the play-test team to exhaustively explore the game's systems using intelligent agents.
        Thus, it is expected that humans focus on the aspects of the game experience rather than stress testing.
        *Methods:* This is an exploratory research in which the use of intelligent agents trained by self-play methods and unsupervised reinforcement is evaluated, inspired by the AlphaZero project, which is based on MCTS and ResNet methods.
        A set of turn-based games was implemented, as well as the training and evaluation environment for states.
        Data collected during and after the training process are used to raise observations about the emerging behavior of the game rules.
        *Results:* With synthetic matches, the development team now has a set of thousands of matches to evaluate, instead of a few dozen.
        The approach allowed visualization of intermediate states evaluated by the trained agents, which can serve as support for the designer during game development.

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
