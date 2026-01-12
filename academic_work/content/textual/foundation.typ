#import "../../components/note.typ": note_from_gabriel, note_from_igor
#import "/template/common/components.typ": describe_figure, done_note, equation, information_footer, todo_note
#import "/template/packages.typ": equate, glossarium, subpar
#import "/template/common/style/style.typ": spacing_for_smaller_text
#import "/template/common/util.typ": text_in_english

= Fundamentação teórica <chapter:fundamentacao>

A fim de atingir os objetivos propostos, o presente trabalho investiga duas técnicas para a construção de @jogador:pl digitais autônomos para @jogo:pl de mesa, sendo elas a @mcts e as @resnet:pl, de acordo com os usos que o @alphazero faz delas.
Este capítulo faz a revisão desses métodos, bem como elenca os trabalhos relacionados a uso de @agint:pl como ferramentas de @playtest.


== #glossarium.Gls(long: true, "mcts") <section:mcts>

O método de @mcts:long (@mcts:short) é um algoritmo de decisão em que cada nó de uma árvore representa dado @estado de um @jogo @kocsis:2006:bandit_based_mcts_planning@coulom:2006:efficient_selectivity_backup_operators.
Além disso, cada nó guarda um contador de visitas e um marcador referente à qualidade daquele nó para a @partida.
Os nós se relacionam por arestas entre nó pai e nó filho.
Uma dada aresta representa um @movimento tomado por um @jogador, que conduz uma transição entre os @estado:pl representados.

O nó raiz da árvore representa o primeiro @turno, em que está disposto o @estado inicial do @jogo.
O @jogador inicial escolhe um dentre todos os @movimento:pl disponíveis, segundo as regras do @jogo.
Essa jogada leva à criação de um novo @estado, que é colocado no segundo nível da árvore.
Para o caso de um @jogo entre dois @jogador:pl, o segundo @jogador escolherá um dentre os @movimento:pl possíveis, o que levará novamente ao @turno do primeiro @jogador, posicionado no terceiro nível da árvore.

Os níveis irão alternadamente representar as jogadas de cada um dos @jogador:pl.
Essa estrutura possibilita ao algoritmo jogar como cada um dos @jogador:pl, de forma a explorar o próximo @movimento realizado pelo oponente.
Dessa forma, o método busca prever a melhor ação futura segundo o histórico disponível a cada iteração @swiechowski:2022:monte_carlo_tree_search.

O processo de @mcts:long tem o objetivo de encontrar as melhores sequências de jogadas, que conduzam a uma vitória do @jogador.
Ele é formado por quatro etapas: seleção, expansão, simulação, e retro-propagação, as quais são representas na @figure:ciclo_mcts @swiechowski:2022:monte_carlo_tree_search[p. 2504].

#describe_figure(
  placement: auto,
  source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2504]).],
  sticky: true,
  [#figure(
    caption: [Ciclo da @mcts:long: suas quatro etapas são a seleção, a expansão, a simulação e a retro-propagação.],
    image(
      width: 70%,
      "../../assets/images/mcts/mcts_cycle.png",
    ),
  )<figure:ciclo_mcts>],
)

#done_note[#note_from_igor[É bom colocar aqui a expansão do UCT para não obrigar o leitor a ir no glossário ter que ler o termo em inglês de onde a sigla veio]]

A etapa de seleção procura, a partir do nó raiz, o ramo com o melhor nó folha a explorar, orientada por uma diretriz de busca.
A mais frequentemente utilizada nas implementações de referência é chamada de @uct --- ou #glossarium.gls-custom("uct"), em inglês --- @kocsis:2006:bandit_based_mcts_planning.
Essa política atribui contadores de visita e de vitória a cada nó.
Com base nesses dados, ela calcula uma equação cujo resultado alinha @exploracao (#glossarium.gls-custom("exploracao")) e @aproveitamento (#glossarium.gls-custom("aproveitamento")) do espaço de busca.
A @equation:uct_teorica apresenta essa diretriz utilizada para  escolher uma ação, que será detalhada no restante desta seção.

#todo_note[#note_from_igor[Tive que alterar a frase final  do parágrafo acima com a referência à Equação 1 porque ficou parecendo que ela chegou muito cedo e ficou no ar. Pode ser interessante reforçar a sua relação com os próximos parágrafos fazendo menções a ela novamente.]]

#equation(
  placement: auto,
)[
  $
    m^* = max_(m in M(s))
    (
      Q(s, m) +
      C * sqrt(
        (ln(V(s)))
        /
        (V(s,m))
      )
    )
  $ <equation:uct_teorica>

  Na qual:
  - $m^*$ é o nó que representa o @movimento ótimo selecionado pela diretriz;
  - $M(s)$ é o conjunto de nós que representam os @movimento:pl válidos a partir do @estado $s$, segundo as regras do @jogo;
  - $Q(s,m)$ é a qualidade da @partida calculada por meio de simulações ao jogar o @movimento $m$ no @estado $s$;
  - $V(s)$ é quantidade de vezes em que o nó que guarda o @estado $s$ foi visitado nas iterações anteriores;
  - $V(s,a)$ é a quantidade de vezes em que o nó que representa o @movimento $m$ foi visitado nas interações anteriores;
  - $C$ é o coeficiente que regula a relação entre @exploracao e @aproveitamento.

  #information_footer(
    source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2505]).],
  )
]

Havendo sido selecionado um nó folha e não sendo este um nó que represente o fim do @jogo, então se executa a fase de expansão.
Ela escolhe aleatoriamente um @movimento dentre aqueles disponíveis para o @estado atual segundo as regras do @jogo.
Então o @estado resultante é criado, o qual é armazenado em um novo nó, definido como filho daquele que fora selecionado.

A partir do nó criado, realiza-se a fase de simulação.
Nela se sucedem @turno:pl entre os @jogador:pl, em que os @movimento:pl são aleatoriamente selecionados.
A simulação se encerra quando é atingido um @estado que represente o fim da @partida.
Uma função de @fitness (#glossarium.gls-custom("fitness")) quantifica a qualidade da @partida com o objetivo de aferir a influência do @movimento escolhido na @pontuacao dos @jogador:pl.

Por fim, na fase de retro-propagação, os nós do ramo selecionado são atualizados com os dados gerados.
O contador de visitas é aumentado em $1$, ao passo em que o marcador de qualidade é incrementado pelo valor de @fitness calculado.

#todo_note(note_from_gabriel[Conferir as referências para citá-las mais frequentemente nesses parágrafos])

Para executar o ciclo de busca, deve-se definir o número de iterações desejado.
Cada iteração levará à expansão de um único novo nó.
Ao final de todos os ciclos, os filhos diretos do nó raiz terão os marcadores de visitas e de qualidade atualizados segundo o andamento das partidas.
A partir desses dados, uma função deve calcular a probabilidade de jogar cada um dos @movimento:pl.
Um exemplo de função que utiliza somente o contador de visitas a cada ramo para calcular as probabilidades é demonstrado na @figure:probabilidades_mcts.
Dispondo do @vetor de probabilidades, o método da seleção aleatória por roleta escolhe um dos @movimento:pl.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [Neste exemplo, o cálculo das probabilidades dos três @movimento:pl válidos a partir do @estado inicial utilizou apenas a quantidade de visitas a cada um dos ramos iniciados pelo respectivo movimento.],
  source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2505]).],
  [#figure(
    caption: [Uso da @mcts para calcular as probabilidades de jogar cada um dos @movimento:pl válidos a partir de um @estado inicial.],
    image(
      width: 50%,
      "../../assets/images/mcts/mcts_probabilities.png",
    ),
  )<figure:probabilidades_mcts>],
)

#todo_note(
  note_from_gabriel[Deve-se descrever nos resultados as experiências de utilizar diferentes funções de cálculo de probabilidade. Por exemplo, uma função que usa apenas a quantidade de visitas tende a ser boa na exploração da árvore, mas ela tende a nunca selecionar estados próximos do estado terminal, uma vez que não se pode visitar um estado terminal mais de uma vez],
)

A descrição do método de @mcts permite concluir que apresenta boas soluções para problemas nos quais o espaço de busca não pode ser percorrido completamente em tempo hábil.
Isso se dá porque a política de seleção (@uct) privilegia os ramos com maior relevância e deixa de gastar recursos explorando aqueles que não tendem a gerar dados relevantes.
O método também diminui a necessidade de uma heurística prévia sobre o domínio para operar, embora existam trabalhos que buscam defini-la para melhora o desempenho.
#todo_note[#note_from_igor[Se menciona trabalhos que trazem a especialização do MCTS, tem que ter referência para eles.]]


== #glossarium.gls(capitalize: true, long: true, plural: true, "resnet") <section:resnet>

As #glossarium.gls(long: true, plural: true, "cnn") são uma classe de @rn:pl profundas especialmente projetadas para processar dados estruturados em grade.
Seus usos se destacam na áreas de visão computacional, sobretudo para o reconhecimento de imagens.
Aprimorando as @rn:pl tradicionais totalmente conectadas, as @cnn:pl utilizam operações de convolução que permitem capturar padrões espaciais e hierárquicos nos dados de entrada sem definição prévia dos elementos de interesse @li:2022:survey_convolutional_neural_networks.

A arquitetura típica de uma @cnn consiste em camadas convolucionais, camadas de @pooling (#glossarium.gls-custom("pooling")) e camadas totalmente conectadas.
As camadas convolucionais aplicam filtros que detectam características locais, como bordas e texturas, enquanto as camadas de @pooling reduzem a dimensionalidade espacial (#text_in_english[downsampling]), preservando as informações mais relevantes @li:2022:survey_convolutional_neural_networks.
Dessa forma, essa classe de @rn:pl balanceia a precisão dos detalhes com a rapidez de convergência pelo processo de #text_in_english[downsampling].

Seguindo os trabalhos na área, #cite(form: "prose", <he:2015:deep_residual_learning>) introduziram as #glossarium.gls(long: true, plural: true, "resnet") como uma evolução importante das @cnn:pl.
Seu principal objetivo era resolver o problema de degradação em redes muito profundas.
Quando @rn:pl convencionais se tornam excessivamente profundas, sua acurácia tende a saturar e depois degradar, não devido ao @overfitting (#glossarium.gls-custom("overfitting")), mas à dificuldade de otimização @he:2015:deep_residual_learning.

A inovação fundamental das @resnet:pl é a introdução de conexões residuais (#text_in_english[shortcut connections]), que permitem que o gradiente flua diretamente através da rede durante o treinamento @he:2015:deep_residual_learning@liang:2020:image_classification_resnet.

Tais conexões são incorporadas em uma estrutura padrão chamada bloco residual, como se pode observar na @figure:residual_block.
Em vez de aprender uma transformação direta $H(x)$, cada bloco aprende uma função residual $F(x) = H(x) - x$, onde $x$ é a entrada do bloco.
A saída final do bloco é então $F(x) + x$, combinando a transformação aprendida com a entrada original @he:2015:deep_residual_learning.
Essa estrutura permite que a rede aprenda transformações incrementais enquanto preserva informações da entrada @liang:2020:image_classification_resnet.

#describe_figure(
  placement: auto,
  source: [#cite(<he:2015:deep_residual_learning>, form: "prose").],
  sticky: true,
  [#figure(
    caption: [Estrutura de um bloco residual usado em uma @resnet.],
    image(
      width: 45%,
      "../../assets/images/resnet/residual_block.webp",
    ),
  )<figure:residual_block>],
)

O formato de uma @resnet consiste de sucessivos blocos residuais, cada um composto por camadas convolucionais e normalizações, nas quais a função de ativação utilizada é a @relu, detalhada nos trabalhos de #cite(form: "prose", <nair:2010:rectified_linear_units>).
Essa arquitetura possibilita a construção de redes extremamente profundas mantendo alta precisão e facilitando o treinamento @he:2015:deep_residual_learning.


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
      "../../assets/images/resnet/resnet.png",
    ),
  )<figure:resnet>],
)

A primeira saída é construída pela camada de #text_in_english[policy head], que retorna um @vetor de números reais.
Esses valores representam a qualidade atribuída a cada um dos @movimento:pl válidos a partir do @estado fornecido.
Na verdade, devido à restrição de formato da saída da rede, o modelo atribuirá uma classificação para todos os movimentos possíveis de acordo com as regras do @jogo, sendo estes válidos ou não a partir do @estado atual.
Dessa forma, é necessário que o #text_in_english[designer] do @jogo simulado descreva previamente a lista de todos os @movimento:pl e os guarde em um @vetor.
O algoritmo do @agint indexará as posições deste àquelas do @vetor retornado pela rede.

A segunda saída da @resnet é construída pela camada de #text_in_english[value head].
Seu retorno é um valor escalar que representa a estimativa da qualidade do resultado da @partida a partir do @estado fornecido.
Esse valor será maior para quando houver uma expectativa de vitória e menor para quando a expectativa for de derrota.

Esses retornos são exemplificados pela @figure:predicao, que utiliza valores fictícios.
O exemplo considera um @estado vantajoso no @jogo_velha para o @jogador "X" que será o próximo a jogar.
O primeiro retorno se refere às qualidades atribuídas pela #text_in_english[policy head]
#footnote[
  Para fins de melhor visualização consideramos que os valores de qualidade foram transformados em probabilidades.
  O retorno da @rn na verdade é composto por valores reais não normalizados.
  No algoritmo, eles devem passar por uma função de @softmax para poderem ser sorteados pelo método da roleta.
].
As @casa:pl já preenchidas por peças têm qualidade $0$ atribuída, uma vez que nelas não são permitidos mais @movimento:pl.
A @casa no canto superior direito, que pode ser marcada pelo terceiro @movimento, apresenta uma qualidade de $0.9$, uma vez que sua marcação levaria à vitória imediata do @jogador "X".
As demais casas apresentam qualidades pouco significativas.
Além disso, a figura também mostra a forma de retorno da estimativa de qualidade da @partida, dada pela #text_in_english[value head].
Uma vez que o @estado analisado está a um @movimento de levar à vitória, a probabilidade de vitória se mostra alta.


#done_note[#note_from_igor[A série de notas na Figura 5 está exagerada. Essa informação deveria vir no texto em parágrafo próprio e ali um compilado.]]

#describe_figure(
  placement: auto,
  sticky: true,
  note: [
    As predições de qualidade são representadas como probabilidades para facilitar a visualização, mas seus valores são números reais sem normalização.
  ],
  [#figure(
    caption: [Predição de um modelo de @resnet para as qualidades estimadas de cada @movimento do @jogo e para a expectativa de qualidade da @partida a partir de um @estado do tabuleiro no @turno do @jogador "X".],
    image(
      width: 80%,
      "../../assets/images/resnet/prediction.png",
    ),
  )<figure:predicao>],
)

#todo_note(note_from_gabriel[Verificar se de fato estamos usando regressão linear])
#todo_note[#note_from_igor[Creio que sim, pois não é um caso de classificação.]]

O processo de treinamento de um modelo é feito em duas fases.
A primeira se denomina fase de geração de memória de treinamento, que utiliza a técnica de @selfplay.
Ela constrói um histórico de @partida:pl que guarda, para cada @partida, a @pontuacao final dos @jogador:pl e a sequência de @turno:pl e seus @estado:pl.
No caso de jogos sem cálculo de @pontuacao, como o @jogo_velha ou Xadrez, o resultado final será de $1$ ponto para o vencedor e $0$ pontos para o perdedor @swiechowski:2022:monte_carlo_tree_search[p. 2533].

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
      "../../assets/images/resnet/train.png",
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
      "../../assets/images/mcts/agent_guided_mcts_cycle.png",
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
A @figure:tabuleiro_jogo_da_velha_e_estado mostra como o estado do @jogo_velha na @figure:tabuleiro_jogo_da_velha é codificado na @figure:estado_jogo_da_velha.
O primeiro @jogador, de símbolo "X", é representado pelo número $0$, ao passo que o segundo @jogador, de símbolo "O", é representado pelo número $1$.
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
        caption: [Tabuleiro do @jogo_velha e sua representação numérica.],
        grid(
          columns: (1fr, 1fr),
          row-gutter: spacing_for_smaller_text,
          column-gutter: spacing_for_smaller_text,

          grid.cell()[
            #figure(
              caption: [Tabuleiro do @jogo_velha.],
              image(
                width: 3.5cm,
                "../../assets/images/state/tabletop.png",
              ),
            )<figure:tabuleiro_jogo_da_velha>
          ],

          grid.cell()[
            #figure(caption: [Tabuleiro do @jogo_velha representado numericamente.], image(
              width: 3.5cm,
              "../../assets/images/state/state.png",
            ))<figure:estado_jogo_da_velha>
          ],
        ),
      ),
    ),
  ),
)

A entrada da @resnet utilizada pelo @agint requer que o @estado seja codificado como uma pilha de canais que contêm apenas valores binários ($0$ ou $1$).
Essa técnica busca aproximar a representação do tabuleiro daquela usada por imagens RGB, comumente fornecidas como entrada a @resnet:pl de reconhecimento de imagens.

No exemplo do @jogo_velha, o tabuleiro representado na @figure:estado_jogo_da_velha se torna um conjunto de três canais, como disposto na @figure:estado_codificado.
O primeiro, associado à cor vermelha, tem uma posição ativada quando o primeiro @jogador (representado pelo símbolo "X") posiciona nela uma peça, como mostrado na @figure:canal_vermelho.
Similarmente, o segundo canal, associado à cor verde, representa as @casa:pl marcadas pelo segundo @jogador (representado pelo símbolo "O"), como mostrado na @figure:canal_verde.
Por fim, as @casa:pl vazias são representadas no terceiro canal, associado à cor azul, como mostrado na @figure:canal_azul.

#describe_figure(
  placement: auto,
  block(
    sticky: true,
    subpar.super(
      label: <figure:estado_codificado>,
      caption: [Estado do @jogo_velha representado como canais binários.],
      grid(
        columns: (1fr, 1fr, 1fr),
        row-gutter: spacing_for_smaller_text,
        column-gutter: spacing_for_smaller_text,

        grid.cell()[
          #figure(
            caption: [Canal do @jogador "X".],
            block(
              width: 4cm,
              align(
                center + horizon,
                image(
                  width: 3.5cm,
                  "../../assets/images/state/red_channel.png",
                ),
              ),
            ),
          )<figure:canal_vermelho>
        ],

        grid.cell()[
          #figure(
            caption: [Canal do @jogador "O".],
            block(
              width: 4cm,
              align(
                center + horizon,
                image(
                  width: 3.5cm,
                  "../../assets/images/state/green_channel.png",
                ),
              ),
            ),
          )<figure:canal_verde>
        ],

        grid.cell()[
          #figure(
            caption: [Canal de @casa:pl vazias.],
            block(
              width: 4cm,
              align(
                center + horizon,
                image(
                  width: 3.5cm,
                  "../../assets/images/state/blue_channel.png",
                ),
              ),
            ),
          )<figure:canal_azul>
        ],
      ),
    ),
  ),
)

Caso necessário, outras informações podem ser representadas por meio da adição de novos canais à pilha.
@Jogo_tabuleiro:pl para dois @jogador:pl citados requerem a representação de qual @jogador deve executar um @movimento no @turno atual.
Isso é definido em um quarto canal, cujas posições são marcadas com o número atribuído ao @jogador.
Assim, um @estado do @jogo_velha define todo esse canal como $0$ para o @jogador de símbolo "X", e como $1$ para o @jogador de símbolo "O".


== Trabalhos relacionados <section:related_works>

#cite(form: "prose", <zook:2019:automatic_playtesting>) reforçam as vantagens da substituição de @jogador:pl humanos em partes bem específicas do processo de @playtest.
O principal destaque é no ajuste de parâmetros e de dificuldade quando os sistemas do @jogo já estão definidos mas se busca uma melhor experiência para o público alvo do @jogo.

Ademais, os autores desenvolvem um estudo combinando técnicas de regressão e classificação para realizar uma aprendizagem ativa @cohn:1994:improving_generalization_with_active_learning de um @jogo #text_in_english[shoot'em up].
A mecânica desse @jogo é bem definida, mas os parâmetros --- como velocidades de jogador, inimigos e tiros --- são ajustados através de testes exaustivos.
Nesse trabalho, eles foram substituídos pelo @playtest automatizado.

Nos trabalhos de #cite(form: "prose", <gudmundsson:2018:human_like_playtesting>)#cite(form: "prose", <zook:2019:automatic_playtesting>), a @mcts é utilizada junto a #glossarium.gls(plural: true, long: true, "cnn").
Elas são treinadas através de um massivo conjunto de dados de @jogador:pl reais para prever a dificuldade de missões em @jogo:pl digitais #text_in_english[match-3] --- respectivamente #text_in_english[Candy Crush] e #text_in_english[Jewels Star Story].
Neste tipo de @jogo, o @jogador deve mover figuras em uma grade, buscando colocar três ou mais figuras iguais adjacentes, que são retiradas do tabuleiro e podem gerar outras remoções em cadeia.
Os trabalhos conseguem reproduzir comportamentos de @jogador:pl humanos e avaliar a dificuldade do nível proposto pelo #text_in_english[game designer] para uma melhor experiência de @jogo.

Sob a ótica de comunicação dos dados gerados ao #text_in_english[designer], #cite(form: "prose", <wallner:2019:aggregated_visualization_playtesting_data>) desenvolveram um sistema para traçar, em @jogo:pl digitais de plataforma, a trajetória de dados de partidas colhidas diretamente sobre os mapas do @jogo.
Ele integra dados de fontes diferentes em uma única visualização capaz de representar o #text_in_english[feedback] dado pelos @jogador:pl, medidas fisiológicas colhidas e a rastreabilidade dos @movimento:pl em @jogo.


Os dados fisiológicos relacionados ao estímulo do @jogador são representados por mapas de cor ao dividir o espaço do @jogo em regiões; a movimentação por linhas que conectam essas regiões, com sua opacidade e espessura relacionadas à frequência; e os eventos discretos agrupados em ícones com o tamanho relacionado à sua frequência, relatando observações de comportamentos durante a partida.
A abordagem diminui a poluição visual, compila um grande conjunto de de informações e provê um grande valor para avaliar um cenário em desenvolvimento.
#todo_note(note_from_gabriel(margin: true)[Reescrever este parágrafo])

Similarmente, #cite(form: "prose", <stahlke:2020:artificial_players_in_the_design_process>) investigam técnicas similares em @jogo:pl em três dimensões, apresentando os caminhos sobre superfícies para auxiliar no processo de projeto dos níveis.
Registra-se também o uso de agentes para o projeto ou validação da economia interna dos @jogo:pl, mostrado nos resultados iniciais de #cite(form: "prose", <ranandeh:2023:beyond_equilibrium>).

Apesar de os trabalhos de testes serem em sua maioria referentes a @jogo:pl digitais --- normalmente modelados sistemas em tempo contínuo ---, acreditamos que as mesmas técnicas podem ser aplicadas a @jogo:pl físicos e modelados por sistemas discretos.
A escassez de trabalhos nesta indústria nos motiva a realizar esta investigação, buscando avaliar as limitações ou ajustes necessários para sua implantação.
