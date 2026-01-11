// # Abbreviations. Abreviaturas.
// NBR 14724:2024 4.2.1.11

#import "/template/common/util.typ": text_in_english

#let abbreviations_entries_about_computing = (
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
    custom: text_in_english[Upper Confidence bounds applied to Trees],
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
    key: "relu",
    short: "ReLU",
    long: "unidade linear retificada",
    longplural: "unidades lineares retificadas",
    description: [Em inglês, #text_in_english[rectified linear unit]. Função de ativação não-linear que retorna o valor de entrada se positivo, ou zero caso contrário.],
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
    key: "sdk",
    short: "SDK",
    plural: "SDKs",
    long: "kit de desenvolvimento de software",
    longplural: "kits de desenvolvimento de software",
    description: [Em inglês, #text_in_english[software development kit]. Conjunto de ferramentas, bibliotecas e documentação que facilita o desenvolvimento de aplicações para uma plataforma específica.],
    group: "Computação",
  ),
  (
    key: "json",
    short: "JSON",
    long: "notação de objetos do JavaScript",
    description: [Em inglês, #text_in_english[JavaScript object notation]. Formato simples de intercâmbio de dados baseado em texto. É fácil de ler e escrever para humanos e de analisar e gerar para máquinas.],
    group: "Computação",
  ),
)

#let abbreviations_entries = (
  ..abbreviations_entries_about_computing,
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
  (
    key: "apts",
    short: [APTS],
    long: [Sistema de Teste de Jogabilidade Automatizado],
    description: [Em inglês, #text_in_english[Auto Play-test System]. Sistema desenvolvido pelos autores que permite a modelagem de protótipos de @jogo:pl e cria @agint:pl que simulem @partida:pl.],
  ),
)
