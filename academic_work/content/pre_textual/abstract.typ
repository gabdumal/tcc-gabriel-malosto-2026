// # Abstract. Resumo.
// NBR 14724:2024 4.2.1.7, NBR 14724:2024 4.2.1.8

#import "../../components.typ": get_term, note_from_gabriel, note_from_igor
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

      // *Introdução:*
      O mercado de @jogo:pl autorais apresenta um crescimento contínuo, com milhares de @jogo:pl publicados ao ano nas maiores feiras do mundo.
      Esse crescimento cria uma demanda por melhorias nas ferramentas de apoio à fase de criação.
      Nessa fase, um protótipo passa por @playtest
      repetidamente a fim de identificar desbalanceamentos e estratégias dominantes, o que exige muito tempo e recursos humanos.
      // *Objetivos:*
      Esta pesquisa busca explorar meios para aliviar a necessidade da equipe de @playtest, ao explorar por exaustão os sistemas do @jogo usando @agint:pl.
      Dessa forma, espera-se que os humanos se concentrem nos aspectos da experiência de @jogo e não em testes de estresse.
      // *Métodos:*
      Esta é uma pesquisa exploratória na qual é avaliado o uso de @agint:pl treinados por métodos de @selfplay e reforço não supervisionado como usados pelo projeto @alphazero, que é baseado nos métodos de #glossarium.gls(first: true, "mcts") e de #glossarium.gls(first: true, plural: true, "resnet").
      Foi criado um sistema computacional de representação de @jogo_turno:pl, de geração e treinamento de @agint:pl e de simulação e avaliação de @partida:pl, que foi testado com o @jogo #get_term("ligue4").
      Dados colhidos durante e após o processo de treinamento são utilizados para levantar observações do comportamento emergente das regras do @jogo.
      // *Resultados:*
      Com as @partida:pl sintéticas, a equipe de desenvolvimento passa a ter um conjunto de milhares de @partida:pl para avaliar, em vez de algumas dezenas.
      Essa abordagem permitiu visualizar métricas acerca do @jogo e indicou a viabilidade de usar o método de @playtest automatizado como apoio ao projetista.
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
        // *Introduction:*
        The market for original #glossarium.gls(plural: true, "jogo", display: "games") shows continuous growth, with thousands of #glossarium.gls(plural: true, "jogo", display: "games") published annually at the world's largest fairs.
        This growth creates a demand for improvements in tools supporting the creation phase.
        In this phase, a prototype undergoes @playtest repeatedly to identify imbalances and dominant strategies, which requires significant time and human resources.
        // *Objectives:*
        This research seeks to explore ways to alleviate the need for a @playtest team by exhaustively exploring the #glossarium.gls("jogo", display: "game") systems using #glossarium.gls(plural: true, "agint", display: "intelligent agents").
        Thus, humans are expected to focus on aspects of the #glossarium.gls("jogo", display: "game") experience rather than on stress testing.
        // *Methods:*
        This is an exploratory research evaluating the use of #glossarium.gls(plural: true, "agint", display: "intelligent agents") trained by @selfplay methods and unsupervised reinforcement as used in the @alphazero project, which is based on #glossarium.gls("mcts", display: "Monte Carlo tree search (MCTS)") and #glossarium.gls(plural: true, "resnet", display: "residual neural networks (ResNets)") methods.
        A computer system was created for representing #glossarium.gls(plural: true, "jogo_turno", display: "turn-based games"), generating and training #glossarium.gls(plural: true, "agint", display: "intelligent agents"), and simulating and evaluating #glossarium.gls(plural: true, "partida", display: "matches"), which was tested with the #glossarium.gls("jogo", display: "game") #get_term(field: "custom", "ligue4").
        Data collected during and after the training process are used to raise observations about the emergent behavior of the #glossarium.gls("jogo", display: "game") rules.
        // *Results:*
        With synthetic #glossarium.gls(plural: true, "partida", display: "matches"), the development team now has a set of thousands of #glossarium.gls(plural: true, "partida", display: "matches") to evaluate, instead of just a few dozen.
        This approach allowed visualizing metrics about the #glossarium.gls("jogo", display: "game") and has indicated the viability of using the automated @playtest method as support for the designer.
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
