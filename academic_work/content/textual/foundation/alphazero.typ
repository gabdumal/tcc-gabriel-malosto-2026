#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/equation.typ": equation
#import "/template/common/components/figure.typ": describe_figure
#import "/template/common/components/information_footer.typ": information_footer
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": equate, glossarium, subpar
#import "/template/common/style/style.typ": spacing_for_smaller_text
#import "/template/common/util/text_in_english.typ": text_in_english

== Modelo #glossarium.gls("alphazero") <section:alphazero>

Dentro da categoria de @jogo:pl de estratégia baseados em @turno:pl, destaca-se o Go, originado na China.
Ele é jogado por duas pessoas, sendo composto por um tabuleiro de 19 linhas verticais e horizontais, 180 peças brancas e 180 peças pretas.
Uma @partida se inicia com o tabuleiro vazio.
Em cada @turno, os @jogador:pl se alternam colocando uma de suas peças nas intersecções das linhas horizontais e verticais.

Qualquer intersecção não ocupada é válida para colocação das peças, que então não podem ser movidas.
O objetivo é cercar totalmente as peças adversárias pois, quando um grupo dessas é totalmente cercado, elas são removidas do tabuleiro.
O outro @jogador tenta evitar a captura ao posicionar peças em interseções não dominadas pelo oponente.
Vence o @jogador que, ao se esgotarem todos os @movimento:pl, tiver a maior quantidade de peças no tabuleiro @britannica:2023:go.

A fim de desenvolver um @jogador autônomo para o Go a nível competitivo, o laboratório DeepMind, braço de pesquisa em @ia da Google, desenvolveu o método de construção de modelos de @rn:pl chamado de #text_in_english[AlphaGo].
Essa versão gerava dados para treinar o modelo ao colocá-lo para jogar contra @jogador:pl humanos.

Foi então desenvolvida sua evolução, chamada de #text_in_english[AlphaGo Zero], que acumula dados de treinamento jogando contra si mesma, no que se define como @selfplay (#glossarium.gls-custom("selfplay")).
Um novo modelo construído é iniciado com @peso:pl (#glossarium.gls-custom("peso")) e @vies:pl (#glossarium.gls-custom("vies")) aleatórios, o que leva a @movimento:pl arbitrários.
Ainda assim, a massa de dados gerada permite identificar quais estados levaram a melhores avaliações pela função de @fitness @silver:2016:mastering_game_go.

Dessa forma, por meio de treinamentos e geração de dados sucessivos, o modelo tende a alcançar desempenho excepcional.
Esse processo de lapidação dos @peso:pl e @vies:pl por meio de @selfplay é compreendido como um método de aprendizado por reforço @silver:2017:mastering_chess_shogi.

O método foi então generalizado para permitir a criação de modelos capazes de aprender qualquer @jogo de tabuleiro dadas apenas as suas regras, ao que se denominou @alphazero.
Os principais destaques foram os @jogo:pl Go, Shogi e Xadrez @silver:2018:general_reinforcement_learning_algorithm.

#todo_note(note_from_gabriel[Citar referências para os parágrafos seguintes])

Um dos objetivos do método @alphazero é reduzir o custo computacional de @agint:pl que atuam como @jogador:pl.
Essa preocupação se torna mais evidente ao considerar a complexidade das árvores de busca para jogos que apresentam muitos @movimento:pl.
Com esse foco, os pesquisadores propuseram substituir as buscas por modelos de @ia:long baseados em @rn:pl.
Em vez de simular uma @partida para calcular a qualidade de cada @movimento, o @agint pode solicitar uma predição a um modelo de @resnet previamente treinado para aquele @jogo.

#todo_note(note_from_gabriel[Explicar melhor a função de cada camada e colocar as referências])

A arquitetura da @resnet aplicada no @alphazero é representada na @figure:resnet.
Ela se inicia pela recepção do @estado do @jogo cujos @movimento:pl viáveis se deseja analisar.
Esse @estado passa por uma camada de adaptação, que transforma a entrada em um formato adequado para realizar as sucessivas convoluções.
Em seguida, inicia-se a construção da cadeia profunda de blocos residuais, ao que se denomina #text_in_english[backbone].
Por fim, a @rn duplica o tensor em processamento para gerar duas saídas.

#describe_figure(
  placement: auto,
  sticky: true,
  [#figure(
    caption: [Arquitetura de uma @resnet:long composta por uma camada de adaptação da entrada, uma #text_in_english[backbone] e camadas de saída #text_in_english[policy head] e #text_in_english[value head].],
    image(
      width: 80%,
      "/academic_work/assets/images/resnet.png",
    ),
  )<figure:resnet>],
)

A primeira saída é construída pela camada de #text_in_english[policy head], que retorna um vetor de números reais.
Esses valores representam a qualidade atribuída a cada um dos @movimento:pl válidos a partir do @estado fornecido.
Na verdade, devido à restrição de formato da saída da rede, o modelo atribuirá uma classificação para todos os movimentos possíveis de acordo com as regras do @jogo, sendo estes válidos ou não a partir do @estado atual.
Dessa forma, é necessário que o #text_in_english[designer] do @jogo simulado descreva previamente a lista de todos os @movimento:pl e os guarde em um vetor.
O algoritmo do @agint indexará as posições deste àquelas do vetor retornado pela rede.

A segunda saída da @resnet é construída pela camada de #text_in_english[value head].
Seu retorno é um valor escalar que representa a estimativa da qualidade do resultado da @partida a partir do @estado fornecido.
Esse valor será maior para quando houver uma expectativa de vitória e menor para quando a expectativa for de derrota.

Esses retornos são exemplificados pela @figure:predicao, que utiliza valores fictícios.
O exemplo considera um @estado vantajoso no Jogo da Velha para o @jogador `X` que será o próximo a jogar.
O primeiro retorno se refere às qualidades atribuídas pela #text_in_english[policy head]
#footnote[
  Para fins de melhor visualização consideramos que os valores de qualidade foram transformados em probabilidades.
  No algoritmo, isso seria realizado por uma função de @softmax.
].
As @casa:pl já preenchidas por peças têm qualidade $0$ atribuída, uma vez que nelas não são permitidos mais @movimento:pl.
A @casa no canto superior direito, que pode ser marcada pelo terceiro @movimento, apresenta uma qualidade de $0.9$, uma vez que sua marcação levaria à vitória imediata do @jogador `X`.
As demais casas apresentam qualidades pouco significativas.
Além disso, a figura também mostra a forma de retorno da estimativa de qualidade da @partida, dada pela #text_in_english[value head].
Uma vez que o @estado analisado está a $1$ @movimento de levar à vitória, a probabilidade de vitória se mostra alta.

#describe_figure(
  placement: auto,
  sticky: true,
  note: (
    [
      O @estado do Jogo da Velha elencado, ao ser informado para a @resnet, deve ser convertido para a representação em canais.
    ],
    [
      As predições de qualidade de cada @movimento são representadas como uma matriz de probabilidades para facilitar a visualização.
      Na verdade, o resultado gerado pelo modelo é um vetor de números reais, em que cada posição é referente a um @movimento na lista de @movimento:pl previamente definida pelo @jogo.
      Esses valores devem passar por uma função de @softmax para se tornarem probabilidades.
    ],
    [
      A estimativa de qualidade da @partida é mostrada como uma probabilidade para facilitar a visualização.
      Na verdade, o retorno se trata de um escalar similar aos retornados pela predição de qualidades de @movimento:pl.
    ],
  ),
  [#figure(
    caption: [Predição de um modelo de @resnet para as qualidades estimadas de cada @movimento do @jogo e para a expectativa de qualidade da @partida a partir de um @estado do tabuleiro no @turno do @jogador `X`.],
    image(
      width: 80%,
      "/academic_work/assets/images/prediction.png",
    ),
  )<figure:predicao>],
)

#todo_note(note_from_gabriel[Verificar se de fato estamos usando regressão linear])

O processo de treinamento de um modelo é feito em duas fases.
A primeira se denomina fase de geração de memória de treinamento, que utiliza a técnica de @selfplay.
Ela constrói um histórico de @partida:pl que guarda, para cada @partida, a @pontuacao final dos @jogador:pl e a sequência de @turno:pl e seus @estado:pl.
No caso de jogos sem cálculo de @pontuacao, como o Jogo da Velha ou Xadrez, o resultado final será de $1$ ponto para o vencedor e $0$ pontos para o perdedor @swiechowski:2022:monte_carlo_tree_search[p. 2533].

Segue-se então a fase de alinhamento do modelo, que utiliza @aprendizado_maquina (#glossarium.gls-custom("aprendizado_maquina")) para ajustar os @peso:pl e @vies:pl.
Para isso, o conjunto de dados gerado é convertido em conjuntos de entradas e de saídas esperadas, que são fornecidos para um algoritmo de treinamento por regressão linear.
Espera-se que o modelo resultante possa gerar uma memória de @partida:pl mais significativa que o anterior.
Assim, entende-se o treinamento como um ciclo, conforme demonstrado na @figure:treinamento.

#describe_figure(
  placement: auto,
  sticky: true,
  [#figure(
    caption: [Ciclo de treinamento de um modelo do @alphazero, constituído das fases de geração da memória de @partida:pl e de alinhamento do modelo de @resnet.],
    image(
      width: 50%,
      "/academic_work/assets/images/train.png",
    ),
  )<figure:treinamento>],
)

É interessante que, durante a fase de geração de memória de treinamento, o @agint tenha alguma orientação sobre quais @movimento:pl levam a melhores jogadas.
Para esse objetivo, o método de @mcts se mostrou útil.
Para otimizar sua aplicação, o método @alphazero removeu a etapa de simulação do ciclo de busca.
Em vez dela, a etapa de predição solicita à @resnet uma estimativa da qualidade dos @movimento:pl e da qualidade da @partida, como mostrado na @figure:agent_guided_mcts_cycle.

Outra alteração se dá na fase de expansão.
No método adaptado, em vez de expandir um único @movimento por iteração e avaliar seu resultado, a @mcts guiada por @agint expande todos os @movimento:pl viáveis a partir do @estado atual.
Para cada nó gerado, ela incrementa o contador de visitas e define um novo marcador de qualidade do @movimento, o qual é preenchido com a estimativa de qualidade dada pela rede para o @movimento que gera aquele nó.

Sem que haja uma simulação da partida, não seria possível realizar a retro-propagação, uma vez que ela depende da análise da @pontuacao final dos @jogador:pl.
Para adaptar essa questão, a retro-propagação é realizada a partir do nó selecionado e não mais a partir do filho expandido.
O valor de qualidade da @partida utilizado como referência é aquele fornecido pela rede.

Uma exceção a esse ciclo se dá quando o @estado selecionado pela iteração atual representa o fim do @jogo.
Nesse caso, não se realiza predição nem expansão.
Em vez disso, a @pontuacao dos @jogador:pl é utilizada para calcular a qualidade da @partida segundo a perspectiva do @jogador do turno atual.
Então, a retro-propagação é feita a partir desse nó terminal com base na qualidade calculada.

#describe_figure(
  placement: auto,
  sticky: true,
  [#figure(
    caption: [Ciclo da @mcts:long guiada por @agint:pl, conforme adaptação do @alphazero: suas quatro etapas são a seleção, a predição, a expansão e a retro-propagação.],
    image(
      width: 70%,
      "/academic_work/assets/images/agent_guided_mcts_cycle.png",
    ),
  )<figure:agent_guided_mcts_cycle>],
)

A definição do novo marcador de qualidade em cada nó é relevante para realizar o cálculo de uma diretriz de @fitness adaptada, como demonstrada na @equation:uct_adaptada.
A @uct passa a considerar como componente de @aproveitamento apenas a qualidade da @partida simulada pelas iterações.
Já como componente de @exploracao, a política alinha dois fatores: como numerador, a predição do modelo para o sucesso do @movimento representado; e como denominador, a quantidade de visitas realizadas ao nó resultante da aplicação do @movimento, que é somada ao número $1$ para garantir que o resultado não seja indefinido.

#equation(
  placement: auto,
)[
  #equate.equate(sub-numbering: true)[
    $
      m^* = max(m in M(s)) = Q(s,a) + X(s,a)\
      X(s,a) = C times
      P(s,a) / (V(s,a) + 1)
    $ <equation:uct_adaptada>

    Na qual:
    - $m^*$ é o nó que representa o @movimento ótimo selecionado pela diretriz;
    - $M(s)$ é o conjunto de nós que representam os @movimento:pl válidos a partir do @estado $s$, segundo as regras do @jogo;
    - $X(s,m)$ é o componente de @exploracao (#glossarium.gls-custom("exploracao")) calculado ao jogar o @movimento $m$ no @estado $s$;
    - $Q(s,m)$ é a qualidade da @partida calculada por meio de simulações ao jogar o @movimento $m$ no @estado $s$;
    - $V(s)$ é quantidade de vezes em que o nó que guarda o @estado $s$ foi visitado nas iterações anteriores;
    - $V(s,m)$ é a quantidade de vezes em que o nó que representa o @movimento $m$ foi visitado nas interações anteriores;
    - $P(s,m)$ é a qualidade previamente atribuída pelo modelo de @resnet para jogar o @movimento $m$ no estado $s$;
    - $C$ é o coeficiente que regula a relação entre @exploracao e @aproveitamento.
  ]

  #information_footer(
    source: [
      Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2505])#cite(<silver:2016:mastering_game_go>, form: "prose", supplement: [p. 486]).
    ],
  )
]

É relevante considerar como a @mcts utilizada pelo @alphazero representa um @estado do jogo.
Cada @casa do tabuleiro guarda a informação sobre a peça marcada em si e o @jogador que a posicionou.
O tabuleiro é salvo atribuindo um número a cada um dos @jogador:pl, que pode ser indexado pela lista de jogadores definida previamente pelo #text_in_english[designer] do @jogo.
A @figure:tabuleiro_jogo_da_velha_e_estado mostra como o estado do Jogo da Velha na @figure:tabuleiro_jogo_da_velha é codificado na @figure:estado_jogo_da_velha.
O primeiro @jogador, de símbolo `X`, é representado pelo número $0$, ao passo que o segundo @jogador, de símbolo `O`, é representado pelo número $1$.
As posições sem peças são definidas com o valor `null`.
Outra informação armazenada no @estado é um marcador de qual @jogador deve jogar no @turno atual.

#describe_figure(
  placement: auto,
  align(
    center,
    block(
      width: 10cm,
      sticky: true,
      subpar.super(
        label: <figure:tabuleiro_jogo_da_velha_e_estado>,
        caption: [Tabuleiro do Jogo da Velha e sua representação numérica.],
        grid(
          columns: (1fr, 1fr),
          row-gutter: spacing_for_smaller_text,
          column-gutter: spacing_for_smaller_text,

          grid.cell()[
            #figure(
              caption: [Tabuleiro do Jogo da Velha.],
              image(
                width: 3.5cm,
                "/academic_work/assets/images/tabletop.png",
              ),
            )<figure:tabuleiro_jogo_da_velha>
          ],

          grid.cell()[
            #figure(caption: [Tabuleiro do Jogo da Velha representado numericamente.], image(
              width: 3.5cm,
              "/academic_work/assets/images/state.png",
            ))<figure:estado_jogo_da_velha>
          ],
        ),
      ),
    ),
  ),
)

A entrada da @resnet utilizada pelo @agint requer que o @estado seja codificado como uma pilha de canais que contêm apenas valores binários ($0$ ou $1$).
Essa técnica busca aproximar a representação do tabuleiro daquela usada por imagens RGB, comumente fornecidas como entrada a @resnet:pl de reconhecimento de imagens.

No exemplo do Jogo da Velha, o tabuleiro representado na @figure:estado_jogo_da_velha se torna um conjunto de três canais, como disposto na @figure:estado_codificado.
O primeiro, associado à cor vermelha, tem uma posição ativada quando o primeiro @jogador (representado pelo símbolo `X`) posiciona nela uma peça, como mostrado na @figure:canal_vermelho.
Similarmente, o segundo canal, associado à cor verde, representa as @casa:pl marcadas pelo segundo @jogador (representado pelo símbolo `O`), como mostrado na @figure:canal_verde.
Por fim, as @casa:pl vazias são representadas no terceiro canal, associado à cor azul, como mostrado na @figure:canal_azul.

#describe_figure(
  placement: auto,
  block(
    sticky: true,
    subpar.super(
      label: <figure:estado_codificado>,
      caption: [Estado do Jogo da Velha representado como canais binários.],
      grid(
        columns: (1fr, 1fr, 1fr),
        row-gutter: spacing_for_smaller_text,
        column-gutter: spacing_for_smaller_text,

        grid.cell()[
          #figure(
            caption: [Canal do @jogador `X`.],
            image(
              width: 3.5cm,
              "/academic_work/assets/images/red_channel.png",
            ),
          )<figure:canal_vermelho>
        ],

        grid.cell()[
          #figure(caption: [Canal do @jogador `O`.], image(
            width: 3.5cm,
            "/academic_work/assets/images/green_channel.png",
          ))<figure:canal_verde>
        ],

        grid.cell()[
          #figure(caption: [Canal de @casa:pl vazias.], image(
            width: 3.5cm,
            "/academic_work/assets/images/blue_channel.png",
          ))<figure:canal_azul>
        ],
      ),
    ),
  ),
)

Caso necessário, outras informações podem ser representadas por meio da adição de novos canais à pilha.
Jogos de @jogo_tabuleiro:pl para dois @jogador:pl citados requerem a representação de qual @jogador deve executar um @movimento no @turno atual.
Isso é definido em um quarto canal, cujas posições são marcadas com o número atribuído ao @jogador.
Assim, um @estado do Jogo da Velha define todo esse canal como $0$ para o @jogador de símbolo `X`, e como $1$ para o @jogador de símbolo `O`.
