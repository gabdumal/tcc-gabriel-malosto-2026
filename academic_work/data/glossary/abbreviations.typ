// # Abbreviations. Abreviaturas.
// NBR 14724:2024 4.2.1.11

#import "/template/common/util/text_in_english.typ": text_in_english

#let abbreviations_entries = (
  (
    key: "ia",
    short: "IA",
    plural: "IAs",
    long: "inteligência artificial",
    longplural: "inteligências artificiais",
    description: "Campo da computação dedicado a criar sistemas capazes de perceber, aprender e agir de forma autônoma.",
    group: "Computação",
  ),
  (
    key: "mcts",
    short: "MCTS",
    long: "busca em árvore de Monte Carlo",
    description: [Em inglês, #text_in_english[Monte Carlo tree search]. Algoritmo de busca por simulação usado para explorar espaços de decisão em jogos.],
    group: "Computação",
  ),
  (
    key: "uct",
    short: "UCT",
    long: "limite superior de confiança aplicado a árvores",
    longplural: "limites superiores de confiança aplicados a árvores",
    description: [Em inglês, #text_in_english[Upper Confidence bounds applied to Trees]. Critério de seleção do MCTS que equilibra exploração e aproveitamento ao escolher nós com base na média de recompensas e em um termo de confiança (UCB).],
    group: "Computação",
  ),
  (
    key: "resnet",
    short: "ResNet",
    plural: "ResNets",
    long: "rede neural residual",
    longplural: "redes neurais residuais",
    description: [Em inglês, #text_in_english[residual neural network]. Arquitetura de rede neural profunda com conexões de atalho para facilitar o treinamento de camadas muito profundas.],
    group: "Computação",
  ),
  (
    key: "cnn",
    short: "CNN",
    plural: "CNNs",
    long: "rede neural convolucional",
    longplural: "redes neurais convolucionais",
    description: [Em inglês, #text_in_english[convolutional neural network]. Arquitetura de rede neural especializada em processar dados com estrutura de grade, como imagens, usando camadas convolucionais para extrair características.],
    group: "Computação",
  ),
  (
    key: "tic",
    short: "TIC",
    plural: "TICs",
    long: "tecnologia de informação e comunicação",
    longplural: "tecnologias de informação e comunicação",
    group: "Computação",
  ),
  (
    key: "ibge",
    short: "IBGE",
    long: "Instituto Brasileiro de Geografia e Estatística",
    group: "Normatização",
  ),
  (
    key: "abnt",
    short: "ABNT",
    long: "Associação Brasileira de Normas Técnicas",
    group: "Normatização",
  ),
  (
    key: "nbr",
    short: "NBR",
    plural: "NBRs",
    long: "Norma Brasileira",
    longplural: "Normas Brasileiras",
    group: "Normatização",
  ),
)
