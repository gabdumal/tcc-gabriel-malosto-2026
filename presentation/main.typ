#import "/template/academic_work/components.typ": print_advisors
#import "/academic_work/components.typ": get_term
#import "/academic_work/data/glossary/main.typ": abbreviations_entries, glossary_entries, symbols_entries
#import "/academic_work/data/main.typ": (
  advisors, approval_date, authors, degree_topic, organization, subtitle, title, type_of_work,
)
#import "/template/common/components.typ": glossary, print_people, information_footer, equation
#import "/template/common/util.typ": capitalize_first_letter, text_in_english
#import "/template/packages.typ": glossarium, equate

// ## Layout configuration. Configuração de leiaute.
#let name_of_work = [#capitalize_first_letter(type_of_work.name) em #degree_topic]
#let theme_color = red.darken(30%)
#let aspect_ratio = 16 / 9
#let height = 10.5cm
#let margin = 24pt
#let font_size = 14pt

#set text(
  lang: "pt",
  region: "br",
  hyphenate: true,
  font: "Atkinson Hyperlegible Next",
  size: font_size,
  weight: "regular",
)

#set heading(
  numbering: none,
)
#let format_heading_of_level_2 = it => {
  text(
    size: font_size * 125%,
    fill: theme_color,
    weight: "semibold",
  )[#it]
}
#show heading: it => {
  if (it.level == 1) {
    set page(header: none, footer: none, margin: 0pt)
    set align(center + horizon)
    block(
      height: 100%,
      width: 100%,
      fill: theme_color,
    )[
      #text(
        size: font_size * 150%,
        weight: "extrabold",
        fill: white,
      )[#it]
    ]
  } else if (it.level == 2) {
    format_heading_of_level_2(it)
  } else {
    text(
      fill: theme_color,
      weight: "regular",
    )[#it]
  }
}

#show list: set list(marker: (
  text(fill: theme_color)[•],
  text(fill: theme_color)[‣],
  text(fill: theme_color)[-],
))

#let stress = it => {
  set text(fill: theme_color)
  strong(it)
}

#set page(
  height: height,
  width: aspect_ratio * height,
  margin: margin,
)

#let slide_counter = counter("slide_counter")
#let slide_page(title: "Title", body) = {
  pagebreak(weak: true)

  let slide_id = context {
    slide_counter.step()
    slide_counter.get().first()
  }

  let slide_state = state("slide_" + repr(title) + repr(body))

  // Mark the first page of this slide
  context {
    if slide_state.get() == none {
      slide_state.update(here().page())
    }
  }

  let header_content = context {
    let current_page = here().page()
    let first_page = slide_state.final()

    pad(
      bottom: font_size,
      if first_page != none and current_page == first_page {
        heading(
          level: 2,
          title,
        )
      } else {
        format_heading_of_level_2(
          [#title],
        )
      },
    )
  }

  grid(
    columns: (1fr),
    grid.header(header_content),
    body,
  )
}

#set figure.caption(position: top)
#let describe_figure(
  note: none,
  source: none,
  sticky: true,
  body,
) = {
  set text(
    size: font_size * 75%
  )
  set par(
    spacing: font_size * 50%
  )
  set align(center + horizon)
  block(
    sticky: sticky,
  )[
    #body.caption
    #body.body
    #information_footer(
      note: note,
      source: source
    )
  ]
}

// ## Tables. Tabelas.
// NBR 14724:2024 5.9, IBGE Apresentação tabular 1993
#let format_table(body) = {
  // IBGE Apresentação tabular 1993 4.3.3
  // Tables should not have vertical lines
  // Tables should have horizontal lines only around header and at bottom of the table
  set table(stroke: (x, y) => (
    top: if y <= 1 { 1pt } else { 0pt },
    bottom: 1pt,
  ))

  // Table header should be bold
  show table.cell.where(y: 0): strong

  // The first column should be left-aligned, and the following columns should be right-aligned
  set table(
    align: (x, y) => {
      if y == 0 { center + horizon } else if x == 0 { left + horizon } else { right + horizon }
    },
  )

  body
}

// ## Glossary. Glossário.
#show: glossarium.make-glossary
#glossarium.register-glossary(abbreviations_entries)
#glossarium.register-glossary(symbols_entries)
#glossarium.register-glossary(glossary_entries)
#glossary(invisible: true, abbreviations_entries)
#glossary(invisible: true, glossary_entries)
#glossary(invisible: true, symbols_entries)

// ## Cover page. Página de capa.
#page(
  margin: 0em,
)[
  #set block(
    width: 100%,
  )
  #grid(
    block(
      fill: theme_color,
      inset: (x: margin, top: margin * 2, bottom: margin),
    )[
      #set text(
        fill: white,
        size: 1.5em,
      )
      #text(weight: "bold", title)#if (subtitle != none) [: #text(weight: "medium", subtitle)]
    ],

    block(
      inset: (x: margin, top: margin),
      grid(
        row-gutter: 0.75em,
        text(
          size: 1.25em,
          name_of_work,
        ),
        text(
          size: 1em,
          fill: theme_color,
        )[
          #organization.name,
          #approval_date.day de #approval_date.month de #approval_date.year
        ],
      ),
    ),
  )

  #align(
    bottom,
    block(
      inset: (x: margin, bottom: margin),
      text(
        size: 0.875em,
      )[
        #print_people(people: authors)\
        #print_advisors(advisors: advisors)
      ],
    ),
  )
]

// ## Pages. Páginas.

= Introdução

#slide_page(
  title: [O que são @jogo:pl?]
)[
  #grid(
    columns: (3fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      #stress[@Jogo:pl] são atividades com propósito bem definido, o qual comumente é vencer um desafio seguindo #stress[regras] pré-definidas @suits:1967:what_is_a_game.
      
      - Pessoas participantes são chamadas de #stress[@jogador:pl].
      - Em #stress[@jogo_turno:pl], elas se reúnem até atingir o propósito em uma #stress[@partida].
        - Ela é dividida em #stress[rodadas].
          - Cada @jogador pode jogar em seu #stress[@turno].
          - Os @turno:pl se alternam entre todos os @jogador:pl.
        - As regras do @jogo podem alterar a ordem padrão.
          - Um @jogador pode perder seu @turno, ou pode jogar no @turno de outra pessoa.
    ],

    describe_figure(
      source: [#cite(form: "prose", <ardivan:2023:playing_chess>).],
      figure(
        caption: [@Partida de Xadrez.], 
        image("/presentation/assets/images/playing_chess.jpg")
      )
    )
  )

  #colbreak()

  #grid(
    rows: (1fr),
    columns: (3fr, 1fr),
    column-gutter: font_size,
    align: (left, right),

    [
      - Dentro de um #stress[@turno], as informações que fazem avançar a @partida são entendidas como um #stress[@estado].
        - Guarda o conteúdo das #stress[@casa:pl] do tabuleiro.
        - Marca de qual #stress[@jogador] é o @turno atual.
        - Pode salvar outros dados, como a #stress[@pontuacao].
      
      - O @jogador #stress[atual] escolhe um #stress[@movimento] válido.
        - Ele efetua a ação e gera um #stress[novo] @estado.
        - As regras descrevem como atualizar as informações.
        - Também verificam se chegou ao #stress[fim] da @partida.
    ],

    block[
      #describe_figure(
        source: [Elaboração\ própria.],
        figure(
          caption: [@Jogador #get_term("alice") jogando o 3º @movimento.],
          block(
          )[
            #image(
              width: 50%,
              "/presentation/assets/images/move.png"
            )
          ]
        )
      )
    ]
  )
]

#slide_page(
  title: [Mercado]
)[
  - #stress[Mercado] de @jogo:pl de mesa aquecido @boardgamegeek:2025:spiel25_preview.
    - Marco cultural com #emph[Colonizadores de Catan] @teuber:1995:catan.
    - Acima de #stress[1000] novos @jogo:pl apresentados em convenções em 2025.
  - Formação de comunidades de criadores de @jogo:pl #stress[autorais] @woods:2012:eurogame_design_culture_play.
  // - A criação exige #stress[prototipagem]

  #describe_figure(
    source: [#cite(form: "prose", <spiel:2025:gallery>).],
    figure(
      caption: [Fotografias do evento SPIEL Essen 2025.],
      grid(
        columns: (1fr, 1fr, 1fr),
        column-gutter: font_size,
        image(
          "/presentation/assets/images/spiel_essen_2025_zoom_out.jpg"
        ),
        image(
          "/presentation/assets/images/spiel_essen_2025_prize.jpg"
        ),
        image(
          "/presentation/assets/images/spiel_essen_2025_cards.jpg"
        )
      )
    )
  )
]

#slide_page(
  title: [Problema]
)[
  - Criação de @jogo:pl exige desenvolver #stress[protótipos] @fullerton:2019:game_design_workshop.
    - Passam por testes de estresse e #stress[balanceamento] @becker:2020:what_is_game_balancing.
    
  - Humanos executam @movimento:pl #stress[repetidamente] @marcelo:2009:design_de_jogos.
    - Explorar comportamentos dos #stress[sistemas] @romero:2021:game_balance.
    - #stress[Não] envolve diversão ou emoções dos @jogador:pl @trzewiczek:2017:i_play_tested_it_100_times.
    - Testadores podem ser imprecisos ou se cansar rapidamente. 
    
  - Alto #stress[custo] em tempo e recursos humanos.
    - Criador muitas vezes testa #stress[sozinho].
    - Compromete o lançamento dos @jogo:pl no mercado.
]

#slide_page(
  title: [Objetivos]
)[
  - #stress[Geral:] oferecer perspectivas e #stress[ferramentas] inovadoras ao cenário de criação de @jogo_turno:pl, estabelecendo como foco a fase de #stress[@playtest].
    - Continuar pesquisa anterior @araki:2020:testes_de_software@malosto:2023:alphazero_como_ferramenta_de_playtest@malosto:2025:moving_towards.

  - #stress[Hipótese:] é viável substituir humanos por #stress[@agint:pl] que simulem @partida:pl sintéticas e ofereçam dados aos projetistas de @jogo:pl.

  - #stress[Específico:] desenvolver #stress[ambiente] de @playtest simulado para auxiliar projetistas de @jogo:pl a realizar as primeiras iterações do processo de teste.
    - Deve permitir #stress[representar] @jogo_turno:pl arbitrários.
    - Deve criar e treinar #stress[@agint:pl] para cada @jogo.
    - Deve gerar conjuntos de #stress[dados] que permitam análises estatísticas. 
]

= Fundamentação teórica

#slide_page(
  title: [@Jogo_turno:pl de destaque]
)[
  #grid(
    rows: (1fr),
    columns: (2fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      === #get_term("jogo_velha")

      - Entre #stress[dois] @jogador:pl.
        - Salvos no #stress[@estado] de acordo\ com a ordem de jogada.
        - Alternam-se @turno a @turno.
      - Tabuleiro de #stress[3x3] linhas e colunas.
      - Um #stress[@movimento] por #stress[@casa].
        - Espaço de #stress[9 @movimento:pl] possíveis.
      - #stress[Vitória] ao marcar três @casa:pl adjacentes em linha, coluna ou diagonais.
      - Fim #stress[sem ganhador] quando marcam todas as @casa:pl sem fechar os formatos especificados.
    ],

    block(
      width: 100%,
      describe_figure(
        figure(
          caption: [Tabuleiros do #get_term("jogo_velha") e seus @estado:pl numéricos.],
          grid(
            gutter: font_size * 50%,
            columns: (1fr, 1fr),
            
            [
              #image(
                "/academic_work/assets/images/state/tictactoe_board.png"
              )
            ],
            [
              #image(
                "/academic_work/assets/images/state/tictactoe_state.png"
              )
            ],
            [
              #image(
                "/presentation/assets/images/tictactoe_board_finished.png"
              )
            ],
            [
              #image(
                "/presentation/assets/images/tictactoe_state_finished.png"
              )
            ]
          )
        )
      )
    )
  )

  #colbreak()

  #grid(
    rows: (1fr),
    columns: (2fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      === #get_term("snowball")

      - #stress[Variante] do #get_term("jogo_velha").
      - @Estado:pl guardam a #stress[@pontuacao] de cada @jogador.
      - Quando @jogador #stress[coloca] uma peça, verifica se marcou um #stress[formato] com suas @casa:pl marcadas.
        - Linha, coluna ou diagonais de 5 @casa:pl, ou quadrados de ordem 2 ou 3.
        - Privilegia #stress[dominar] um espaço do tabuleiro para ganhar mais #stress[pontos] por jogada.
      - #stress[Fim] quando um @jogador faz #stress[15 pontos] ou quando #stress[49 @casa:pl] são preenchidas.
      - #stress[Vitória] para aquele com mais pontos.
    ],

    block(
      describe_figure(
        figure(
          caption: [Tabuleiro do #get_term("snowball")\ e sua @pontuacao.],
          grid(
            gutter: font_size * 50%,
            
            [
              #image(
                width: 75%,
                "/academic_work/assets/images/state/snowball_board.png"
              )
            ],
            [
              #image(
                width: 75%,
                "/academic_work/assets/images/state/snowball_points.png"
              )
            ],
          )
        )
      )
    )
  )

  #colbreak()

  #grid(
    rows: (1fr),
    columns: (2fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      === #get_term("ligue4")

      - #stress[Similar] ao #get_term("jogo_velha").
      - Tabuleiro #stress[vertical].
        - #stress[6] linhas e #stress[7] colunas #sym.arrow #stress[49 @casa:pl].
        - #stress[> 4.5 trilhões] de combinações @cahn:2024:connect4.
        - Apenas #stress[7 @movimento:pl] possíveis.
      - #stress[Vitória] ao marcar linha, coluna ou diagonal de #stress[5 @casa:pl] adjacentes.
        - Favorece impedir o oponente de marcar.
      - Fim #stress[sem ganhador] quando preenche todo o tabuleiro sem fechar um dos formatos.
    ],

    block(
      describe_figure(
        figure(
          caption: [Tabuleiro do #get_term("ligue4")\ e seu @estado numérico.],
          grid(
            gutter: font_size * 50%,
            
            [
              #image(
                width: 80%,
                "/academic_work/assets/images/state/connect_four_board.png"
              )
            ],
            [
              #image(
                width: 80%,
                "/academic_work/assets/images/state/connect_four_state.png"
              )
            ],
          )
        )
      )
    )
  )

  #colbreak()

  #stack(
    dir: ltr,
    [
      === Go
  
      - Tabuleiro de #stress[19x19] linhas e colunas #sym.arrow #stress[361] @casa:pl.
      - #stress[180] peças para cada @jogador (brancas e pretas).
      - Objetivo de #stress[cercar] as peças do oponente.
        - #stress[Remove] as peças adversárias do tabuleiro.
        - Dominar áreas e evitar ser cercado.
      - #stress[Vitória] para o @jogador com #stress[mais peças] no\ tabuleiro quando se esgotarem os @movimento:pl\ @britannica:2023:go.
    ],

    block()[
      #describe_figure(
        source: [#cite(form: "prose", <britannica:2023:go>).],
        figure(
          caption: [@Jogador #get_term("alice") jogando o 3º @movimento.],
          block(
          )[
            #image(
              width: 30%,
              "/presentation/assets/images/go_board.gif"
            )
          ]
        )
      )
    ]
  )
]

#slide_page(
  title: [
    #glossarium.gls("mcts", display: [Busca em árvore de Monte Carlo (MCTS)])
  ])[
  #grid(
    rows: (100% - font_size * 2),
    columns: (2fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      - Algoritmo de #stress[decisão] que monta uma árvore de busca para atribuir probabilidades de seleção aos #stress[@movimento:pl] disponíveis @kocsis:2006:bandit_based_mcts_planning@coulom:2006:efficient_selectivity_backup_operators.
      
      - Cada #stress[nó] representa um #stress[@estado] do @jogo.
        - Guarda um contador de #stress[visitas] e um marcador de #stress[qualidade].
        
      - Uma #stress[aresta] representa a transição entre o @estado atual e o próximo por meio de um #stress[@movimento] efetuado.
    ],

    align()[
      #describe_figure(
        source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2505]).],
        figure(
          caption: [Aferição das probabilidades de seleção dos @movimento:pl.],
          block(
          )[
            #image(
              "../academic_work/assets/images/mcts/mcts_probabilities.png"
            )
          ]
        )
      )
    ]
  )
  
  #colbreak()

  #block(
    height: 100%,
    width: 100%
  )[
    #describe_figure(
      source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2504]).],
      figure(
        caption: [Ciclo da @mcts:long.],
        block(
        )[
          #image(
            width: 75%,
            "/academic_work/assets/images/mcts/mcts_cycle.png"
          )
        ]
      )
    )
  ]

  #colbreak()
  
  - #stress[Quatro etapas]  @swiechowski:2022:monte_carlo_tree_search[p. 2504]
    - #stress[seleção] do melhor *nó folha* orientada pela diretriz de @uct;
    - #stress[expansão] de um *novo nó* por meio de um @movimento aleatório;
    - #stress[simulação] de uma @partida com @movimento:pl *aleatórios*;
    - #stress[retro-propagação] do resultado de *qualidade* da @partida.

  - O usuário do algoritmo define previamente:
    - A quantidade de #stress[ciclos];
    - O coeficiente de #stress[exploração];
    - Uma função de #stress[avaliação] de qualidade para o resultado final da @partida.

  #colbreak()

  #describe_figure(
    source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2505]).],
  )[#figure(
    supplement: "Equação",
    kind: "equation",
    caption: none,
  )[
    #set text(size: 1.1174em)
    #equation[
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
      - $V(s,m)$ é a quantidade de vezes em que o nó que representa o @movimento $m$ foi visitado nas interações anteriores;
      - $C$ é o coeficiente que regula a relação entre @exploracao e @aproveitamento.
    ]
  ]]
]

#slide_page(
  title: [
    #glossarium.gls("cnn", display: [Redes neurais convolucionais (CNN)])
  ]
)[
  #grid(
    rows: (100% - font_size * 2),
    columns: (2fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      - São #stress[@rn:pl] profundas especializadas @li:2022:survey_convolutional_neural_networks.
        - Entradas na forma de #stress[grade], como imagens.
        - Comuns para visão computacional.
        
      - Arquitetura baseada em camadas.
        - #stress[Convolucionais:] detectam características da entrada com filtros.
        - #stress[#text_in_english[Pooling]:] reduzem dimensionalidade para processar mais rapidamente.
        - #stress[Totalmente conectadas:] realizam a classificação ou a regressão.
    ],

    describe_figure(
      source: [#cite(<li:2022:survey_convolutional_neural_networks>, form: "prose", supplement: [p. 7000]).],
      figure(
        caption: [Arquitetura das camadas de uma @cnn:long.],
        block(
          height: 75%,
          rotate(
            90deg,
            image(
              "/academic_work/assets/images/resnet/cnn.png",
            ),
          )
        )
      ),
    )
  )
]

#slide_page(
  title: [
    #glossarium.gls("resnet", display: [Redes neurais residuais (ResNet)])
  ]
)[
  #grid(
    rows: (100% - font_size * 2),
    columns: (2fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      - Avanço nas @cnn:pl para reduzir #stress[degradação] das entradas @he:2015:deep_residual_learning.
      - Introdução de conexões #stress[residuais] (#text_in_english[shortcut connections]) @liang:2020:image_classification_resnet.
      - Estrutura em #stress[blocos] residuais.
        - Convolução #sym.arrow normalização #sym.arrow ativação #sym.arrow convolução #sym.arrow normalização #sym.arrow #stress[soma] com a saída do bloco anterior #sym.arrow ativação.
      - #stress[Ativação]: @relu.
        - Retorna a entrada se *positiva* ou *0* caso contrário @nair:2010:rectified_linear_units.
    ],

    describe_figure(
      source: [#cite(<he:2015:deep_residual_learning>, form: "prose").],
      figure(
        caption: [Estrutura de bloco residual\ usado em uma @resnet:short.],
        block(
          image(
            "../academic_work/assets/images/resnet/residual_block.webp",
          ),
        )
      ),
    )
  )
]

#slide_page(
  title: [Projeto @alphazero]
)[
  - Projeto do laboratório Google #stress[DeepMind] para criar #stress[@agint:pl] que jogassem Go, Xadrez e Shogi em nível profissional @silver:2016:mastering_game_go.
  
  - Usa uma #stress[@resnet] para interpretar o *@estado* de um @jogo.

  #describe_figure(
    figure(
      caption: [Arquitetura de uma @resnet:short.],
      image(
        width: 80%,
        "/academic_work/assets/images/resnet/resnet.png",
      ),
    )
  )

  #colbreak()

  - Arquitetura em camadas.
    - #stress[Adaptação] da entrada para o formato da rede.
    - #stress[#text_in_english[Backbone]:] entrada processada por uma série de *blocos residuais*.
    - #stress[#text_in_english[Policy head]:] atribui *qualidade* aos *@movimento:pl* possíveis.
    - #stress[#text_in_english[Value head]:] estima uma *qualidade* para o andamento da *@partida*.

  #describe_figure(
    note: [qualidades foram transformadas em probabilidades para facilitar visualização.],
    figure(
      caption: [Predição da @resnet:short para um @estado do #get_term("jogo_velha").],
      image(
        width: 75%,
        "/academic_work/assets/images/resnet/prediction.png",
      ),
    )
  )
    
  #colbreak()
  
  - Treinamento por #stress[@selfplay] (#glossarium.gls-custom("selfplay")).
    - Modelo de #stress[@resnet] gerado com @peso:pl e @vies:pl *aleatórios*.
    - Geração de #stress[histórico] de @turno:pl por simulação de #stress[@partida:pl sintéticas].
    - #stress[Alinhamento] do modelo de @resnet com os dados gerados.

  #describe_figure(
    figure(
      caption: [Ciclo de treinamento de um modelo do @alphazero.],
      image(
        width: 55%,
        "/academic_work/assets/images/resnet/train.png",
      ),
    )
  )

  #colbreak()

  - A *simulação* das @partida:pl usa #stress[@mcts adaptada] para escolher *@movimento:pl*.

  #describe_figure(
    figure(
      caption: [Arquitetura de uma @resnet:short.],
      image(
        width: 70%,
        "/academic_work/assets/images/mcts/agent_guided_mcts_cycle.png",
      ),
    )
  )

  #colbreak()

  - Adaptações @silver:2017:mastering_chess_shogi@silver:2018:general_reinforcement_learning_algorithm:
    - Substitui etapa de *simulação* por uma de #stress[predição].
    - Expande #stress[todos] os *@movimento:pl* disponíveis na mesma iteração.
      - Salva nos nós expandidos um novo *marcador*.
        - Qualidade atribuída ao @movimento pelo #stress[modelo].
    - Retro-propagação a partir do nó #stress[selecionado], não o *expandido*.
      - Como não faz simulação, propaga o valor da *#get_term("value_head")*.
      - Caso o @estado selecionado seja #stress[final], propaga a qualidade calculada a partir do *resultado* final da @partida.
    - Adaptação da diretriz de #stress[@uct] para usar o marcador de *qualidade* atribuído pelo modelo.

  #colbreak()

  #describe_figure(
    source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose", supplement: [p. 2505])#cite(<silver:2016:mastering_game_go>, form: "prose", supplement: [p. 486]).],
  )[#figure(
    supplement: "Equação",
    kind: "equation",
    caption: none,
  )[
    #set text(size: 0.9713em)
    #equation[
      #equate.equate(sub-numbering: true)[
        $
          m^* = max(m in M(s)) = Q(s,m) + X(s,m)\
          X(s,m) = C times
          P(s,m) / (V(s,m) + 1)
        $ <equation:uct_adaptada>
  
        Na qual:
        - $m^*$ é o nó que representa o @movimento ótimo selecionado pela diretriz;
        - $M(s)$ é o conjunto de nós que representam os @movimento:pl válidos a partir do @estado $s$, segundo as regras do @jogo;
        - $Q(s,m)$ é a qualidade da @partida calculada por meio de simulações ao jogar o @movimento $m$ no @estado $s$;
        - $X(s,m)$ é o componente de @exploracao (#glossarium.gls-custom("exploracao")) calculado ao jogar o @movimento $m$ no @estado $s$;
        - $V(s)$ é quantidade de vezes em que o nó que guarda o @estado $s$ foi visitado nas iterações anteriores;
        - $V(s,m)$ é a quantidade de vezes em que o nó que representa o @movimento $m$ foi visitado nas interações anteriores;
        - $P(s,m)$ é a qualidade previamente atribuída pelo modelo de @resnet para jogar o @movimento $m$ no estado $s$;
        - $C$ é o coeficiente que regula a relação entre @exploracao e @aproveitamento.
      ]
    ]
  ]]

  #colbreak()

  - Um @estado deve ser #stress[codificado] na forma de *canais* binários.
    - Canal *vermelho* representa @casa:pl preenchidas por peças do #stress[primeiro] @jogador. Canal *verde* representa #stress[segundo] @jogador. Canal *azul* marca casas #stress[vazias]. *Último* canal é preenchido pelo número relativo ao @jogador #stress[atual]. 

  #describe_figure(
    figure(
      caption: [Estado do #get_term("jogo_velha") representado como canais binários.],
      grid(
        columns: (1fr, 1fr, 1fr, 1fr),
        column-gutter: font_size * 50%,
        
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/tictactoe_red_channel.png",
              ),
            ),
          )
        ],
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/tictactoe_green_channel.png",
              ),
            ),
          )
        ],
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/tictactoe_blue_channel.png",
              ),
            ),
          )
        ],
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/tictactoe_player_channel.png",
              ),
            ),
          )
        ],
      )
    )
  )
]

#slide_page(
  title: [Trabalhos relacionados]
)[
  - #cite(form: "prose", <zook:2019:automatic_playtesting>) reforçam as vantagens da *substituição* de @jogador:pl #stress[humanos] em partes bem específicas do processo de *@playtest*.
  - #cite(form: "prose", <cohn:1994:improving_generalization_with_active_learning>) usam técnicas de regressão e classificação para realizar uma #stress[aprendizagem ativa] de um @jogo #text_in_english[shoot'em up].
  - #cite(form: "prose", <gudmundsson:2018:human_like_playtesting>)#cite(form: "prose", <zook:2019:automatic_playtesting>): @mcts usada junto a @cnn para prever a dificuldade de missões em @jogo:pl digitais #text_in_english[match-3].
  - #cite(form: "prose", <wallner:2019:aggregated_visualization_playtesting_data>): sistema para traçar a *trajetória de dados* de partidas colhidas sobre os mapas de @jogo:pl digitais de plataforma.
  - #cite(form: "prose", <stahlke:2020:artificial_players_in_the_design_process>) investigam técnicas similares em @jogo:pl em três dimensões, apresentando os caminhos sobre superfícies.
  - #cite(form: "prose", <ranandeh:2023:beyond_equilibrium>): uso de agentes para o projeto ou validação da economia interna dos @jogo:pl.
]

= Material e métodos

#slide_page(
  title: [Material]
)[
  - Desenvolvida aplicação de linha de comando chamada *@apts*.
    - Capaz de #stress[representar] protótipos de @jogo:pl discretos.
    - Capaz de #stress[gerar @agint:pl]
      - Simulam @partida:pl conforme o método de *@selfplay*.
    
  - Simulações coletam #stress[dados] sobre @partida:pl.
      - Proveem ao projetista *informações* estatísticas.
        - Usadas para orientar *testes* de estresse e de balanceamento.

  #colbreak()
  
  === Ambiente de execução

  - Uso de linguagem de programação #stress[#get_term("js")].
    - Expectativa de o sistema ser utilizado como CLI e como #text_in_english[Web app].
  - Aplicação CLI executada no ambiente #stress[#get_term("node")], otimizado com *motor V8*.

  === Ambiente de desenvolvimento

  - Gerenciador de pacotes #stress[#get_term("pnpm")] com o registro *#get_term("npm")*.
  - Uso do #stress[#get_term("ts")]: superset do *#get_term("js")* com tipagem estática.
  - Inspeção de código com o @linter *#get_term("eslint")* e extensão typescript-eslint.
  - Formatação de código com *#get_term("prettier")*.
  - Gerenciamento de módulos com #stress[#get_term("turborepo")].
  - Testes de unidade com #stress[#get_term("vitest")].

  #colbreak()
  
  === Dependências externas

  - #stress[#get_term("tensorflow"):] biblioteca de @aprendizado_maquina por @rn:pl.
    - Desenvolvida pela Google @tensorflow:2015:whitepaper.
    - Motor em C++ com #glossarium.gls(first: false, plural:true, "api") para Python e #get_term("js").
    - Usada para construir e treinar as @resnet:pl.
  - #stress[seedrandom:] biblioteca de geração de valores pseudo-aleatórios.
  - #stress[ts-graphviz:] @api do programa #get_term("graphviz"), que gera imagens de grafos.
    - Usada para mostrar ao usuário as árvores de busca geradas.
  - #stress[#get_term("commander"):] biblioteca de definição e tratamento de comandos e argumentos para programas de linha de comando.
  - #stress[#get_term("inquirer"):] biblioteca para seleção de opções dentro de programas CLI.
]

#slide_page(
  title: [Métodos]
)[
  #block(
    height: 1fr,
    width: 100%,
  )[
    #describe_figure(
      figure(
      caption: [Fluxograma dos métodos necessários e seus artefatos.],
      block(
        )[
          #image(
            width: 75%,
            "/academic_work/assets/images/methods.png",
          )
        ]
      )
    )
  ]

  #colbreak()

  - Foi selecionado o @jogo #stress[#get_term("ligue4")] para realizar o *experimento*.
    - #stress[Complexidade] suficiente: muitas *combinações* de posicionamento de peças, mas baixa quantidade de *@movimento:pl*.
  - Realizados *21 ciclos* de treinamento dos @agint:pl até a data limite para o experimento.
    - Selecionado o *melhor*, considerando acurácia do alinhamento de @peso:pl.
  - Simuladas *100 @partida:pl* sintéticas e exportados seus históricos de @turno:pl.
    - Extração de métricas acerca da:
      - *duração* das @partida:pl, medida em quantidade de @turno:pl;
      - distribuição de *@movimento:pl mais escolhidos* por cada @jogador; 
      - *contagem* de vitórias e derrotas dos cada @jogador, associada à faixa de *duração* da @partida.

  #colbreak()

  === Avaliação da solução proposta.
  
    - Realizada de forma #stress[qualitativa].
    
    - Discussão sobre a capacidade do *sistema*.
      - Espera-se que possa *representar* o #get_term("ligue4")
      - Espera-se que gere *@agint:pl* que o simulem.
      
    - Análise e discussão sobre a capacidade dos *artefatos* gerados.
      - Espera-se que expressem *conclusões* relevantes sobre o @jogo testado.
]

= Desenvolvimento

#slide_page(
  title: [Módulos]
)[
  #describe_figure(
    note: [Um módulo aponta para o pacote do qual ele depende.],
    [#figure(
      caption: [Dependências entre os módulos do sistema e com pacotes externos.],
      image(
        width: 55%,
        "/academic_work/assets/images/uml/modules_diagram.png",
      ),
    )],
  )
]

#slide_page(
  title: [Utilitários]
)[
  - @Alias:pl para tipos comuns, constantes úteis e funções de formatação.
  - Conversão e verificação de tipos de dados.
  - Codificação e decodificação da @json. 
  
  #describe_figure(
    [#figure(
      caption: [Tipos de dados comuns definidos pelo pacote `core`.],
      image(
        width: 55%,
        "/academic_work/assets/images/uml/core/types_diagram_of_package_core.png",
      ),
    )],
  )
]

#slide_page(
  title: [Descrição de @jogo:pl]
)[
  - Definimos *tipos* e *classes abstratas* para descrever componentes do @jogo.
  
  #describe_figure(
    [#figure(
      caption: [Tipos de dados comuns definidos pelo pacote `game`.],
      image(
        width: 50%,
        "/academic_work/assets/images/uml/game/types_diagram_of_package_game.png",
      ),
    )<figure:diagrama_pacote_game_tipos>],
  )

  #colbreak()

  #align(
    center + horizon,
    block(
      height: 100%,
    )[
      #describe_figure(
        figure(
          caption: [Classes definidas pelo pacote `game`.],
          image(
            "/academic_work/assets/images/uml/game/simplified_class_diagram_of_package_game.png",
          ),
        ),
      )
    ]
  )
]

#slide_page(
  title: [Implementação dos @jogo:pl]
)[
  #grid(
    rows: (100% - font_size * 2),
    columns: (1fr, 1fr),
    column-gutter: font_size,
    align: (left, right),
    
    [
      === Implementação do #get_term("ligue4") 
  
      - Tipo de objeto para marcar os #stress[formatos] que levam à *vitória*.
      
      - Uma #stress[@casa] guarda qual *@jogador* marcou nela uma peça.
      
      - Um #stress[@movimento] descreve em qual *coluna* colocar uma peça.
    ],

    describe_figure(
      [#figure(
        caption: [Classes concretas alteradas na implementação do #get_term("ligue4") e tipo utilitário nela definido.],
        image(
          // width: 40%,
          "/academic_work/assets/images/uml/games/simplified_class_diagram_of_package_games.png",
        ),
      )],
    )
  )

  #colbreak()

  - Um #stress[@estado] é codificado em quatro canais binários.
  
  - O formato do tabuleiro é define as dimensões do bloco de entrada.

  #describe_figure(
    figure(
      caption: [Estado do #get_term("ligue4") representado como canais binários.],
      grid(
        columns: (1fr, 1fr, 1fr, 1fr),
        column-gutter: font_size * 50%,
        
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/connect_four_red_channel.png",
              ),
            ),
          )
        ],
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/connect_four_green_channel.png",
              ),
            ),
          )
        ],
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/connect_four_blue_channel.png",
              ),
            ),
          )
        ],
        grid.cell()[
          #block(
            width: 4cm,
            align(
              center + horizon,
              image(
                width: 3.5cm,
                "/academic_work/assets/images/state/connect_four_player_channel.png",
              ),
            ),
          )
        ],
      )
    )
  )

  #colbreak()

  === #get_term("jogo_velha") e #get_term("snowball")

  - Uma #stress[@casa] também guarda o @jogador que nela posicionou uma peça.
  - Já um #stress[@movimento] guarda o índice da @casa do tabuleiro onde a peça deve ser marcada.
  - Para o #get_term("snowball"), o método `play` deve atualizar as #stress[@pontuacao:pl].
    - Elas devem ser acessadas pelo método `isFinal`.
  - Esses @jogo:pl #stress[não] tiveram a geração de @agint:pl testada.
    - O @apts permite a simulação de partidas usando a *@mcts clássica*.
  - Garantiram a abrangências dos *testes de unidade*.
  - Comprovaram que o sistema é capaz de #stress[representar] @jogo:pl *abstratos*, inclusive com *@pontuacao*. 
]

#slide_page(
  title: [Elaboração dos algoritmos de busca]
)[
  - Definimos *tipos* e *classes abstratas* para representar a @mcts, inspirados pela implementação de referência @forster:2023:alphazero.
  
  #describe_figure(
    figure(
      caption: [Tipos de dados comuns definidos pelo pacote `search`.],
      image(
        width: 70%,
        "/academic_work/assets/images/uml/search/types_diagram_of_package_search.png",
      ),
    )
  )

  #colbreak()

  #block(
    height: 100%
  )[
    #describe_figure(
      figure(
        caption: [Classe `TreeNode` definida no pacote `search`.],
        block(
          height: 95%,
          image("/presentation/assets/images/simplified_class_diagram_of_package_search_showing_class_tree_node.png")
        )
      )
    )
  ]

  #colbreak()

  - Após o fim da busca, o algoritmo afere a #stress[qualidade] dos *filhos* da *raiz*.
    - Comum usar apenas quantidade de *visitas*.
    - Problema ao selecionar nós próximos do fim da partida.
    - O @estado final não pode mais receber visitas.
    - Privilegia @estado:pl vizinhos piores.
  - Elaboramos função que #stress[alinha] qualidade da partida e contador de visitas.
  
  #describe_figure(
    figure(
      supplement: "Equação",
      kind: "equation",
      caption: none,
    )[
      #set text(size: 1.2em)
      #equation[
        $
          A(n) = Q(n) + root(4, V(n))
        $
    
        Na qual:
        - $A(n)$ é a qualidade do @movimento representado pelo nó $n$;
        - $Q(n)$ é a qualidade da @partida calculada por meio de simulações a partir do nó $n$;
        - $V(n)$ é quantidade de vezes em que o nó $n$ foi visitado nas iterações anteriores.
      ]
    ]
  )

  #colbreak()

  #grid(
    rows: (100% - font_size * 2),
    columns: (1fr, 1fr),
    column-gutter: font_size,
    align: (left, right),

    [
      - Gerencia a busca e recebe:
        - coeficiente de @exploracao;
        - quantidade de ciclos;
        - objeto auxiliar para gerar valores pseudo-aleatórios com seed.
      
      - Métodos.
        - Constrói toda a árvore.
        - Implementa fase de seleção.
        - Simula partida ou solicita predições para o modelo.
    ],
    
    describe_figure(
      figure(
        caption: [Classe `Search` definida no pacote `search`.],
        image(
          width: 100%,
          "/academic_work/assets/images/uml/search/simplified_class_diagram_of_package_search_showing_class_search.png",
        ),
      )
    ),
  )

  #colbreak()

  #grid(
    rows: (100%),
    columns: (1.39fr, 3fr),
    column-gutter: font_size,
    align: (left, right),

    [
      - @Mcts #stress[clássica] expande *um nó* por vez.

      - @Mcts #stress[adaptada] expande *todos os @movimento:pl* válidos.
        - Prediz qualidades pelo modelo.
        - Salva valor em novo marcador.
    ],

    describe_figure(
      figure(
        caption: [Classe `Search` definida no pacote `search`.],
        image(
          width: 100%,
          "/presentation/assets/images/simplified_class_diagram_of_package_search_showing_concrete_classes.png",
        ),
      )
    )
  )
]

#slide_page(
  title: [Construção da @resnet:long]
)[
  - Uso do sistema de construção em camadas do #get_term("tensorflow") (#text_in_english[LayersModel]).
  - Usuário define parâmetros #stress[estruturais].
    - Quantidade de *blocos* residuais concatenados.
    - *Largura* em canais da #get_term("backbone") da rede.
  - Funções de #stress[@perda] das camadas de saída @forster:2023:alphazero:
    - #get_term(capitalize:true, "policy_head"): @entropia_cruzada_categorica (#glossarium.gls("entropia_cruzada_categorica", display: glossarium.gls-custom("entropia_cruzada_categorica")));
    - #get_term(capitalize:true, "value_head"): @erro_quadratico_medio (#glossarium.gls("erro_quadratico_medio", display: glossarium.gls-custom("erro_quadratico_medio")));
  - Usuário define parâmetros de #stress[treino].
    - duração do treinamento em quantidade de *épocas*;
    - tamanho do conjunto (#text_in_english[*batch*]) de entradas fornecidas por passo.
  - Demais hiper-parâmetros são os padrões do #get_term("tensorflow").
]

#slide_page(
  title: [Geração de memórias de treinamento]
)[
  #grid(
    rows: (100% - font_size * 2),
    columns: (2fr, 1.5fr),
    column-gutter: font_size,
    align: (left, right),

    [
      #set enum(numbering: "1.a.")
      - Para cada #stress[@partida]:
        + Declara *@vetor* de memórias de @turno:pl.
        + Cria *@estado* inicial.
        + Obtém qualidades dos *@movimento:pl* com @mcts adaptada.
        + Calcula *probabilidades* (@softmax).
        + Seleciona um por *roleta*.
        + *Salva* dados no @vetor.
        + Gera próximo @estado. É *final*?
          + Sim: retorna memória da *@partida*.
          + Não: retorna ao *passo 3* usando o novo @estado.
    ],

    describe_figure(
      figure(
        caption: [Memórias de @partida:pl, definidas pelo pacote `search`.],
        image(
          width: 100%,
          "/presentation/assets/images/types_diagram_of_package_search_showing_file_memory_of_turns_and_match.png",
        ),
      )
    )
  )

  #colbreak()

  #grid(
    rows: (1fr),
    columns: (2.125fr, 1fr),
    column-gutter: font_size,
    align: (left, right),

    [
      - Geração de várias #stress[@partida:pl] sintéticas.
        - *Quantidade* de @partida:pl definida pelo usuário.
        - Exportação do *histórico* em um objeto @json.
        - Transformação em memórias de *treinamento*.
          - Cada #stress[@turno] é transformado no conjunto de uma entrada e duas saídas.
          - Predição da @mcts adaptada é usada como referência da *#get_term("policy_head")*.
          - @Pontuacao final convertida em valor de qualidade da @partida para o @jogador daquele turno. Usada para a *#get_term("value_head")*.
    ],

    describe_figure(
      figure(
        caption: [Memória de treinamento, definida pelo pacote `search`.],
        image(
          width: 100%,
          "/presentation/assets/images/types_diagram_of_package_search_showing_file_memory_of_training.png",
        ),
      )
    )
  )
]

#slide_page(
  title: [Interface com o usuário]
)[
  #describe_figure(
    figure(
      caption: [Interface do programa #glossarium.gls(first:true, "apts").],
      image(
        width: 100%,
        "/academic_work/assets/images/interface/apts_interface.png",
      ),
    )
  )

  #colbreak()

  === Buscar qualidade dos @movimento:pl
  
  #describe_figure(
    figure(
      caption: [Qualidades de @movimento:pl e probabilidades de  vitória a efetuá-los estimadas pela @mcts:short clássica.],
      grid(
        columns: (1fr, 1fr),
        column-gutter: font_size,
        image(
          "/academic_work/assets/images/interface/search/search_mcts_common_qualities.png"
        ),
        image(
          "/academic_work/assets/images/interface/search/search_mcts_common_probabilities.png"
        ),
      )
    )
  )

  #colbreak()

  #describe_figure(
    figure(
      caption: [Recorte da árvore de busca montada.],
      image(
        width: 70%,
        "/academic_work/assets/images/interface/search/search_tree_partial_state.png",
      ),
    )
  )

  #colbreak()

  === Ambiente de simulação de partidas

  #block(
    height: 85%
  )[#describe_figure(
    figure(
      caption: [Ambiente de jogatina entre dois @jogador:pl humanos.],
      align(
        top,
        grid(
          columns: (1fr, 1fr, 1fr),
          column-gutter: font_size,
          
          image(
            "/presentation/assets/images/connect_four_pvp_1.png"
          ),
          image(
            "/presentation/assets/images/connect_four_pvp_2.png"
          ),
          image(
            "/presentation/assets/images/connect_four_pvp_3.png"
          ),
        ) 
      )
    )
  )]

  #colbreak()

  === Geração de modelos de @resnet

  #grid(
    rows: (91%),
    columns: (1fr),

    [
      #stress[Retorna] arquivo @json com arquitetura da rede e arquivo de @peso:pl e @vies:pl.
    
      #describe_figure(
        figure(
          caption: none,
          image(
            height: 95%,
            "/academic_work/assets/images/interface/resnet.png",
          ),
        )
      )
    ]
  )
]

#slide_page(
  title: [Geração de @agint:pl]
)[
  #grid(
    columns: (1fr, 1fr),
    gutter: font_size,

    [
      1. #stress[Criação] de uma @resnet com\ @peso:pl e @vies:pl aleatórios.
        - @Jogo #stress[#get_term("ligue4")].
        - #stress[1] de valor de *@seed*.
        - #stress[8] *blocos* residuais.
        - #stress[128] *canais* de largura.
    
      2. Geração de #stress[memórias].
        - #stress[1] de valor de *@seed*.
        - *@Mcts* adaptada pelo @alphazero.
          - #stress[512] *ciclos* de expansão.
          - #stress[1.4] de coefic. de *@exploracao*.
        - #stress[1] de coeficiente de *@softmax*.
    ],

    [
      3. #stress[Alinhamento] de @peso:pl.
        - #stress[128] *blocos* de entrada e saídas por passo (#text_in_english[batch size]).
        - #stress[16] *épocas* de duração.
        - #stress[15%] para *validação*.
        - Valores para @movimento:pl *inválidos* definidos como #stress[0].

      4. Ciclos de *treinamento--alinhamento* repetidos até o prazo final para o experimento.
        - Resultou em #stress[21] gerações de modelos.
    ]
  )

  #colbreak()

  - Melhores modelos convergiram cedo (4º ciclo).
    - Pequena redução de acurácia nos próximos ciclos.
    - Nenhuma melhoria depois do 7º ciclo.
  - Pouca variação de acurácia da #get_term("value_head").

  #grid(
    columns: 2,
    [#describe_figure(
      [#figure(
        caption: [Melhores modelos por acurácia da #get_term("policy_head").],
        block(
          width: 90%,
          format_table(
            table(
              columns: (2fr, 3fr, 3fr),
              table.header([Ciclo], [#get_term(capitalize:true, "policy_head")], [#get_term(capitalize:true, "value_head")]),
              [4º], [*$0.667935$*], [$0.557322$],
              [7º], [$0.571429$], [$0.571429$],
              [8º], [$0.571429$], [$0.571429$],
              [13º], [$0.571429$], [$0.571429$],
              [15º], [$0.571429$], [$0.571429$],
            ),
          ),
        ),
      )<table:acuracia_policy_head>],
    )],
    [#describe_figure(
      [#figure(
        caption: [Melhores modelos por acurácia da #get_term("value_head").],
        block(
          width: 90%,
          format_table(
            table(
              columns: (2fr, 3fr, 3fr),
              table.header([Ciclo], [#get_term(capitalize:true, "policy_head")], [#get_term(capitalize:true, "value_head")]),
              [7º], [$0.571429$], [*$0.571429$*],
              [8º], [$0.571429$], [$0.571429$],
              [13º], [$0.571429$], [$0.571429$],
              [15º], [$0.571429$], [$0.571429$],
              [16º], [$0.571429$], [$0.571429$],
            ),
          ),
        ),
      )<table:acuracia_value_head>],
    )]
  )

  - As métricas de acurácia não foram tão altas como era de interesse.
  
  - A baixa *complexidade* do #get_term("ligue4") teria permitido realizar o experimento com *menos épocas* por ciclo, e com *menos ciclos* de treinamento.
    - Poderíamos testar diferentes parâmetros e hiper-parâmetros.

  - Dúvidas acerca de o @agint conseguir perceber qual é o *@jogador* como quem ele deve atuar no *@turno atual*.
    - Acurácia próxima a #stress[57%] pode indicar que ele está jogando para ambos os @jogador:pl em todos os @turno:pl.

  - Selecionamos o *melhor* modelo em acurácia da *#get_term("policy_head")* para realizar a próxima fase do experimento.
]

#slide_page(
  title: [Simulação de @partida:pl]
)[
  - Simulação de @partida:pl sintéticas utilizando @resnet para predição.
    - Rodamos #stress[100] @partida:pl, variando #stress[@seed] de *1* a *100*.
    
  - Execução de script para coletar estatísticas a partir dos históricos gerados.
  
  #describe_figure(
    figure(
      kind: "board",
      supplement: [Quadro],
      caption: [Métricas acerca da duração em @turno:pl de @partida:pl simuladas do @jogo #get_term("ligue4").],
      block()[
        #set text(size: 1.5em)
        #table(
          columns: (1fr, 1fr, 1fr, 1fr, 1fr),
          align: center + horizon,
          table.header(
            table.cell()[#strong("Mínimo")],
            table.cell()[#strong("Máximo")],
            table.cell()[#strong("Média")],
            table.cell()[#strong("Mediana")],
            table.cell()[#strong("Desv. pad.")],
          ),
          [$15$], [$40$], [$24.32$], [$23.00$], [$5.94$]
        )
      ]
    )
  )

  #colbreak()

  - Ampla vantagem para o primeiro @jogador em @partida:pl até 20 @turno:pl.
  - Pequena vantagem em @partida:pl médias e na análise geral.

  #describe_figure(
    figure(
      caption: [Análise de vitórias dos @jogador:pl segundo faixas de duração de @partida:pl.],
      block(
        width: 80%,
      )[
        #set text(size: 1.25em)
        #format_table(
          table(
            align: (x, y) => {
              if (y == 0) { center + horizon } else if x == 0 { left + horizon } else { right + horizon }
            },
            stroke: (x, y) => (
              top: if (y == 0 or y == 2) { 1pt } else { 0pt },
              bottom: 1pt,
            ),
            columns: (3fr, 2fr, 1.5fr, 2fr, 1.5fr, 2fr),
            table.header(
              table.cell(rowspan: 2)[Duração],
              table.cell(rowspan: 2)[@Turno:pl],
              table.cell(colspan: 2)[@Jogador #get_term("alice")],
              table.cell(colspan: 2)[@Jogador #get_term("bruno")],
              [N], [%], [N], [%],
            ),
            [T <= 20], [$25$], [$20$], [$80%$], [$5$], [$20%$],
            [20 < T <= 30], [$59$], [$35$], [$59%$], [$24$], [$41%$],
            [30 < T <= 40], [$16$], [$9$], [$56%$], [$7$], [$44%$],
            [40 < T], [$0$], [$0$], [$0%$], [$0$], [$0%$],
            table.hline(stroke: 0.5pt),
            [Total], [$100$], [$64$], [$64%$], [$36$], [$36%$],
          ),
        )
      ]
    )
  )

  #colbreak()

  - Esse modelo apresentou preferência pelas colunas 2 e 5, o que não reflete nenhuma percepção estratégica acerca do #get_term("ligue4").
  - Um foco na coluna do meio seria mais esperado.
    - Por ela, há mais chances de marcar uma linha.

  #describe_figure(
    figure(
      caption: [Análise de @movimento:pl mais jogados por cada @agint.],
      block(
        width: 90%,
      )[
        #set text(size: 1.25em)
        #format_table(
          table(
            align: (x, y) => {
              if (y == 0) { center + horizon } else if x == 0 { left + horizon } else { right + horizon }
            },
            stroke: (x, y) => (
              top: if (y == 0 or y == 2) { 1pt } else { 0pt },
              bottom: 1pt,
            ),
            columns: (2fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
            table.header(
              table.cell(rowspan: 2)[@Jogador],
              table.cell(colspan: 7)[Coluna],
              table.cell()[1ª],
              table.cell()[2ª],
              table.cell()[3ª],
              table.cell()[4ª],
              table.cell()[5ª],
              table.cell()[6ª],
              table.cell()[7ª],
            ),
            [@Jogador #get_term("alice")], [77], [292], [67], [138], [208], [112], [254],
            [@Jogador #get_term("bruno")], [41], [300], [24], [205], [300], [230], [84],
            table.hline(stroke: 0.5pt),
            [Total], [118], [592], [91], [343], [508], [342], [338],
          ),
        )
      ]
    )
  )
]


= Considerações finais

#slide_page(
  title: [Análise dos objetivos]
)[
  - #stress[Geral:] oferecemos *perspectivas* promissoras e uma *ferramenta* inovadora para melhorar o cenário de criação de @jogo_turno:pl.

  - #stress[Hipótese:] avançamos a noção de que é viável substituir humanos por *@agint:pl* que realizem o processo de @playtest, mas os resultados exigem melhorias no processo e mais experimentos para comprovação.

  - #stress[Específico:] desenvolvemos o #glossarium.gls(first:true, "apts"), um ambiente para representar e testar protótipos de @jogo:pl.
    - Permitir *representar* @jogo_turno:pl arbitrários, com ou sem @pontuacao.
    - Permite jogar *@partida:pl* contra humanos, @mcts ou @agint:pl.
    - Criar e treina os *@agint:pl* para cada @jogo.
    - Permite gerar conjuntos de *dados* que para fazer análises estatísticas. 
]

#slide_page(
  title: [Limitações e trabalhos futuros]
)[
  - Não está certo se *@agint:pl* reconhecem como #stress[qual @jogador] eles devem agir a cada @turno.
    - Necessário investigar formas de representar um @estado *codificado*.
  
  - #stress[Experimentos] insuficientes.
    - Testada pouca variação de *parâmetros* e *hiper-parâmetros*.
    - Necessário estudar aprofundadamente métodos de *@rn:pl*.
    - Considerar aplicação de *penalidade* para @movimento:pl inválidos.

  - Impossível definir valor de #stress[@seed] para treinamento do #get_term("tensorflow_js").
    - Problemas para *reprodutibilidade* dos resultados.

  #colbreak()
    
  - Uso de função de #stress[avaliação] arbitrária para atribuir qualidades aos *@movimento:pl* após fim da construção da @mcts.
    - Necessário buscar referencial teórico nessa linha de pesquisa.

  - Limitação de escopo para representar apenas #stress[@jogo_turno:pl].
  
  - Adaptar o sistema para #stress[representar] @jogo:pl menos tradicionais.
      - *Fases* com regras diferentes dentro de uma @partida.
      - *Estágios* intermediários dentro de um @turno.
      - Perda da *vez* de um @jogador, ou atuação no @turno de outros @jogador:pl.

  - Necessidade de conhecimento em #stress[#get_term("js")] para descrever regras.
    - Usar linguagem específica de *domínio*.

  #colbreak()
    
  - Implementação limitada ao programa de #stress[linha de comando].
    - Interesse em usar o sistema como uma biblioteca para uma aplicação para *navegadores Web*.

  - Necessidade de o usuário descrever #stress[todos os movimentos] possíveis em qualquer momento do @jogo antes de sua simulação.
    - Em @jogo:pl mais complexos, esse número pode crescer muito.
      - #get_term("ligue4") tem 7, #get_term("jogo_velha") tem 9, Xadrez tem 4672.
    - Investigar se é possível fazer a @resnet atribuir qualidades apenas aos @movimento:pl *válidos* em dado @estado de forma *dinâmica*.

  - Fazer representação de @jogo:pl de #stress[cartas] e de informação #stress[incompleta].
    - Necessário estudar como codificar seus @estado:pl em *canais*.
]

// ## Bibliography. Referências.
#bibliography(
  title: [Referências],
  style: "/template/common/style/bibliography_style.csl",
  "/academic_work/data/bibliography.bib",
)

= Agradecemos pela atenção