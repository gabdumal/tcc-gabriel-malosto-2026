// # Glossary. Glossário.
// NBR 14724:2024 4.2.3.2

#import "/template/common/util/text_in_english.typ": text_in_english

#let glossary_entries = (
  (
    key: "pt",
    short: text_in_english[play-testing],
    plural: text_in_english[play-testing],
    long: "teste de jogabilidade",
    longplural: "testes de jogabilidade",
    description: "Avaliação prática de um jogo com participantes para observar a experiência e coletar feedback de melhoria.",
    group: "Jogos",
  ),
  (
    key: "sp",
    short: text_in_english[self-play],
    long: "autoaprendizado por simulação de partidas",
    description: [Técnica em que um @intag treina jogando contra versões de si mesmo para aprender estratégias por reforço sem dados externos.],
    group: "Computação",
  ),
  (
    key: "az",
    short: text_in_english[AlphaZero],
    description: [Algoritmo de autoaprendizado por reforço que combina @mcts e @resnet:pl profundas para dominar jogos de tabuleiro, desenvolvido pela DeepMind.],
    group: "Computação",
  ),
  (
    key: "intag",
    short: "agente inteligente",
    plural: "agentes inteligentes",
    description: "Sistema capaz de interpretar um estado, tomar decisões autônomas e agir para atingir objetivos definidos, aprendendo a adaptar seu comportamento.",
    group: "Computação",
  ),
)
