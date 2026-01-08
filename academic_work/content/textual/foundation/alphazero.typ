#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/figure.typ": describe_figure
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": glossarium, subpar
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

A @mcts utilizada pelo @alphazero representa um @estado do jogo como um tabuleiro composto de @casa:pl.
Cada @casa guarda a informação sobre a peça marcada em si, e o @jogador que a posicionou.
O tabuleiro é salvo numericamente, atribuindo um número a cada um dos @jogador:pl. A @figure:tabuleiro_jogo_da_velha_e_estado mostra como o estado do Jogo da Velha na @figure:tabuleiro_jogo_da_velha é codificado na @figure:estado_jogo_da_velha.
As posições sem peças são definidas com o valor `null`.
Outra informação armazenada é um marcador de qual @jogador deve jogar no @turno atual.

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
                width: 4.5cm,
                "/academic_work/assets/images/tabletop.png",
              ),
            )<figure:tabuleiro_jogo_da_velha>
          ],

          grid.cell()[
            #figure(caption: [Tabuleiro do Jogo da Velha representado numericamente.], image(
              width: 4.5cm,
              "/academic_work/assets/images/state.png",
            ))<figure:estado_jogo_da_velha>
          ],
        ),
      ),
    ),
  ),
)

O método @alphazero alinha a @mcts ao uso de uma @resnet, o que requer uma segunda codificação dos @estado:pl.
Um determinado @estado deve ser representado como uma pilha de canais que contenham apenas valores binários ($0$ ou $1$).
Esse método busca aproximar a representação daquela usada por imagens RGB, comumente fornecidas como entrada a @resnet:pl de reconhecimento de imagens.

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
      caption: [Tabuleiro do Jogo da Velha e sua representação numérica.],
      grid(
        columns: (1fr, 1fr, 1fr),
        row-gutter: spacing_for_smaller_text,
        column-gutter: spacing_for_smaller_text,

        grid.cell()[
          #figure(
            caption: [Tabuleiro do Jogo da Velha.],
            image(
              width: 4.5cm,
              "/academic_work/assets/images/red_channel.png",
            ),
          )<figure:canal_vermelho>
        ],

        grid.cell()[
          #figure(caption: [Tabuleiro do Jogo da Velha representado numericamente.], image(
            width: 4.5cm,
            "/academic_work/assets/images/green_channel.png",
          ))<figure:canal_verde>
        ],

        grid.cell()[
          #figure(caption: [Tabuleiro do Jogo da Velha representado numericamente.], image(
            width: 4.5cm,
            "/academic_work/assets/images/blue_channel.png",
          ))<figure:canal_azul>
        ],
      ),
    ),
  ),
)

A utilização do modelo requer como entrada um dado @estado do tabuleiro.
A @rn processa a entrada e retorna como saída dois valores: (1) um vetor que representa a qualidade atribuída a cada um dos @movimento:pl válidos naquele @estado; e (2) um escalar que representa a qualidade do resultado estimado para aquela @partida, sendo maior para uma expectativa de vitória e menor para uma de derrota.

#describe_figure(
  placement: auto,
  sticky: true,
  [#figure(
    caption: [Ciclo da @mcts:long adaptada pelo @alphazero: suas quatro etapas são a seleção, a predição, a expansão e a retro-propagação.],
    image(
      width: 80%,
      "/academic_work/assets/images/agent_guided_mcts_cycle.png",
    ),
  )<figure:agent_guided_mcts_cycle>],
)
