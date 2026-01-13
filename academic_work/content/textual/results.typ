#import "../../components/note.typ": note_from_gabriel, note_from_igor
#import "/template/common/components.typ": (
  describe_figure, equation, information_footer, print_source_for_content_created_by_authors, todo_note,
)
#import "/template/packages.typ": glossarium
#import "/template/common/util.typ": text_in_english

= Desenvolvimento <chapter:resultados>

Este capítulo descreve o desenvolvimento do sistema @apts, realizado como um projeto de código-livre em um repositório público
#footnote[
  Acesso em: #link("https://github.com/ufjf-gamelab/apts").
]
@malosto:2026:apts.
Essa aplicação permite a uma pessoa projetista de um @jogo_tabuleiro descrever as regras de um protótipo de @jogo.
Então, o programa oferece métodos para gerar e treinar modelos de @ia:long que atuam como @agint:pl para simular @partida:pl. As simulações geram conjuntos de dados acerca de quais @movimento:pl tomados levam a melhores resultados.
Espera-se que, por meio deles, o projetista possa gerar informações estatísticas acerca das regras implementadas.
Isso tem o objetivo de diminuir o esforço humano nas etapas de @playtest, sobretudo aquelas que envolvem testes de estresse e balanceamento, em que a experiência do jogador não é a variável principal.

== Ambiente de execução

#todo_note[#note_from_igor[esta parte toda está mais para material]]

Os autores têm a expectativa de que o @apts possa ser acessado por meio de programas navegadores da internet, dispondo de uma interface de usuário satisfatória para usuários não familiarizados com programação.
Entretanto, concluiu-se que seria vantajoso desenvolver scripts de teste de software para verificar sua qualidade durante as versões iniciais de desenvolvimento.
Por isso, estabeleceu-se como requisito que o sistema funcionasse como uma biblioteca, de forma que possa ser utilizado tanto por um programa de linha de comando, como também por uma página da web.

Com essa perspectiva, escolhemos escrever o código-fonte do sistema na linguagem de programação @js.
Essa é utilizada comumente para o desenvolvimento de páginas da web, tendo suporte oferecido pelos principais navegadores, como comprovado pelo suporte fornecido pela empresa #cite(form: "prose", <aws:2020:supported_browsers>) ao seu @sdk para @js.

Essa linguagem também pode ser utilizada em um ambiente de execução de linha de comando, sendo o mais comum o @node.
Ele utiliza o motor de @js V8, o que garante o desempenho para programas. Apesar de rodar em uma só @thread, o ciclo de processamento trata eventos assíncronas por meio de operações primitivas @node:2025:introduction.

== Ambiente de desenvolvimento

#todo_note[#note_from_igor[esta parte toda está mais para material]]

O ambiente de desenvolvimento do projeto foi configurado utilizando o gerenciador de pacotes @pnpm
#footnote[Acesso em: #link("https://pnpm.io/motivation").].
Ele instala e mantém atualizadas as ferramentas citadas e suas dependências por meio do registro de pacotes @npm
#footnote[Acesso em: #link("https://www.npmjs.com/").].

A fim de evitar enganos de programação, utilizamos um superset do @js chamado @ts, que permite atribuir tipos estáticos e mais complexos a variáveis e funções.
Isso assegura a compatibilidade entre elas ainda em tempo de compilação @typescript:2026:for_javascript_programmers.

Outra ferramenta de inspeção de código-fonte utilizada é o @eslint.
Ela é um @linter, que encontra e corrige problemas no código-fonte, segundo os padrões e regras configurados @eslint:2025:core_concepts.
O associamos à análise do @ts e ao formatador automático @prettier
#footnote[Acesso em: #link("https://prettier.io/").]
para padronizar a disposição de importações e de atributos.

A fim de arquitetar o @apts como uma biblioteca modular, utilizamos o sistema de construção @turborepo
#footnote[Acesso em: #link("https://turborepo.com/docs").].
Ele divide um repositório em pacotes, cada um com suas dependências.
Um pacote pode ter dependência em outro dentro do mesmo repositório, o que permite construir um sistema complexo, mas composto por partes simples.
De acordo com as relações inter-módulos, o @turborepo gerencia a compilação e a execução do @linter de forma independente e faz cache dos resultados quando possível.

Finalmente, utilizamos a biblioteca de testes de unidade @vitest
#footnote[Acesso em: #link("https://vitest.dev/guide/").].
Ela permite definir casos de teste e executá-los para entradas variadas, o que se provou útil sobretudo para garantir que as regras dos @jogo:pl modelados de fato levem às alterações esperadas nos @estado:pl.

== Arquitetura do projeto

#todo_note[#note_from_igor[esta parte toda ótima para ser a primeira seção do cap 4. Não precisa mencionar o turborepo se as duas forem enviadas para o material ]]

O projeto da aplicação desenvolvida a divide em cinco módulos --- ou pacotes, segundo a terminologia da ferramenta @turborepo ---, quais sejam: `core`, `game`, `search`, `games` e `interface`.
A @figure:modulos representa as relações de dependência entre tais módulos e com os pacotes externos `ts-graphviz` e `tensorflow`.
Esta seção discute a responsabilidade e a implementação de cada um dos módulos internos.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [Um módulo aponta para o pacote do qual ele depende.],
  [#figure(
    caption: [Dependências entre os módulos do sistema e com pacotes externos.],
    image(
      width: 55%,
      "../../assets/images/uml/modules_diagram.png",
    ),
  )<figure:modulos>],
)

=== Utilitários

O módulo `core` tem a responsabilidade de definir constantes, tipos e funções utilitárias para todos os demais módulos.
Destacam-se algumas funções de conversão de tipos de dados, sobretudo para tratar argumentos fornecidos pela linha de comando em suas representações numéricas.
Também estão disponíveis utilitários para a formatação de dados de tipos compostos e de descritores dos testes de unidade.
Além disso, o módulo gerencia a codificação de dados para o formato de @json e a equivalente conversão para objetos em memória, o que é necessário para salvar e interpretar o histórico de @partida:pl para o treinamento de modelos.

A fim de facilitar a compreensão de conceitos comuns ao domínio da aplicação, definimos por meio do @ts alguns tipos derivados, utilizados por todo o projeto.
Os principais estão dispostos na @figure:diagrama_pacote_core_tipos.
Ela explicita os tipos concretos `string` e `number` da linguagem @js, que guardam, respectivamente, texto e números reais.
O tipo `Char` foi um @alias (#glossarium.gls-custom("alias")) dado para campos de texto de apenas um caractere, como a marcação de uma peça em uma @casa do tabuleiro.
Já o tipo `Integer` é um @alias para um valor numérico que deve ser preenchido apenas por um número inteiro, como por exemplo na indexação de dados em @vetor:pl.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [O pacote `primitive` se refere aos tipos de dados concretos disponibilizados pela linguagem @js.],
  [#figure(
    caption: [Tipos de dados comuns definidos pelo pacote `core`.],
    image(
      width: 65%,
      "../../assets/images/uml/core/types_diagram_of_package_core.png",
    ),
  )<figure:diagrama_pacote_core_tipos>],
)

=== Componentes fundamentais de um @jogo <subsection:componentes_fundamentais>

Seguindo a descrição modular do sistema, o módulo `game` é responsável por estabelecer os componentes fundamentais para representar um @jogo_turno digitalmente.
Primeiramente, definimos tipos úteis para esse pacote e para seus dependentes, como apresentado na @figure:diagrama_pacote_game_tipos.
Uma vez que utilizamos @vetor:pl extensamente pelo projeto, decidimos criar @alias:pl para nomear os índices de @movimento:pl (moves), de @casa:pl (slots) e de @jogador:pl (players).

#describe_figure(
  placement: auto,
  sticky: true,
  note: [O pacote `primitive` se refere aos tipos de dados concretos disponibilizados pela linguagem @js.],
  [#figure(
    caption: [Tipos de dados comuns definidos pelo pacote `game`.],
    image(
      width: 65%,
      "../../assets/images/uml/game/types_diagram_of_package_game.png",
    ),
  )<figure:diagrama_pacote_game_tipos>],
)

Outro dado comumente referenciado é a marcação de pontos dos jogadores, que é feita com números inteiros pelo @alias `Points`.
Guardamos a @pontuacao completa de todos os @jogador:pl por meio da estrutura de indexação por chave-valor `Map`, do @js.
No tipo abstrato `PointsOfEachPlayer`, as chaves são definidas pelo índice de cada @jogador, conforme registrado pelo projetista do @jogo, ao passo em que os pontos são salvos no campo de valor.
Finalmente, o tipo `EncodedState` representa o formato de codificação de um estado em canais, como descrito na @section:alphazero. Ele aceita qualquer matriz multidimensional de valores reais, embora tenhamos respeitado a convenção de utilizar apenas os valores os $0$ e $1$ para definirmos tais codificações.

Após definir os tipos, passamos à implementação dos componentes fundamentais para descrever um @jogo, que foram inspirados pela descrição dada pela documentação do projeto boardgame.io
#footnote[
  Acesso em: #link("https://boardgame.io/documentation/#/").
]
@boardgameio:2022:concepts.
Os implementamos por meio de classes abstratas, uma vez que a linguagem @js não dispõe de estruturas como interfaces ou protocolos.
Os principais atributos e métodos de cada classe, além das relações entre elas, podem ser vistos na @figure:diagrama_classes_pacote_game.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [As propriedades com visibilidade privada têm métodos públicos de encapsulamento para a obtenção de seus valores que não foram representados.],
  [#figure(
    caption: [Classes definidas pelo pacote `game`.],
    image(
      width: 100%,
      "../../assets/images/uml/game/simplified_class_diagram_of_package_game.png",
    ),
  )<figure:diagrama_classes_pacote_game>],
)

A classe mais simples é a que representa uma @casa do tabuleiro, chamada de `Slot`.
Esse conceito é um dos mais variáveis em @jogo_turno:pl, que pode marcar apenas o símbolo de um @jogador --- como no @jogo_velha ---, uma dentre peças que apresentam comportamentos diversos --- como no Xadrez ---, camadas sucessivas de peças --- como no Gobblet Gobblers #footnote[
  Descrição disponível em: #link("https://boardgamegeek.com/boardgame/13230/gobblet-gobblers").
] --- ou até mesmo uma carta específica dentro de uma mão #footnote[
  Apesar de termos determinado como limite do escopo desta pesquisa a investigação de @jogo_tabuleiro:pl, tentamos manter a implementação genérica para representar jogos de cartas futuramente.
].
Essa variabilidade não nos permite atribuir nenhum dado comum à classe.
Dessa forma, cabe inteiramente ao projetista definir o conteúdo possível por meio de uma classe concreta que a implemente.

Em seguida, implementamos a classe abstrata `Player`, que representa os dados fixos de um @jogador durante todo o período de duração da partida.
Os dados comuns identificados foram acerca da distinção entre os @jogador:pl na interface de execução por linha de comando.
Nesse sentido, quando o projetista for criar um objeto da classe `Player`, ele deve atribuir um nome por meio do atributo `name` e um símbolo por meio do atributo `symbol` --- como "primeiro" (1) e "segundo" (2), peças "brancas" (B) e "pretas" (P), ou (X) e (O), por exemplo.

Para registrar as possibilidades de transição entre @estado:pl, criamos a classe abstrata `Move` que representa um @movimento.
Por padrão, ela apenas guarda dados de identificação para a interface com o usuário, quais sejam o título com atributo `title` e sua descrição com atributo `description`.
Para todas as classes abstratas, o projetista pode definir novos atributos caso sejam necessários para efetuar as regras do @jogo.

A fim de permitir que os @agint:pl gerados possam avaliar as qualidade dos @movimento:pl, é necessário que o projetista descreva previamente ao início da @partida todos aqueles que são possíveis em qualquer momento.
Por exemplo, #cite(form: "prose", <silver:2017:mastering_chess_shogi>) representam o Xadrez por meio de $4672$ @movimento:pl, por meio de uma matriz de $8$ @casa:pl na horizontal, $8$ @casa:pl na vertical e $73$ mudanças de estado que uma peça pode efetuar.
Apesar de essa lista de opções ser extensa, ela é necessária porque a estrutura da @rn usada pelo agente atribui um valor de qualidade para todos os @movimento:pl do @jogo, mesmo aqueles que não são válidos em um @estado específico.

As classes descritas previamente têm a função de armazenar dados imutáveis no contexto de uma @partida.
Para representar um @estado --- o qual sintetiza a disposição variável dos elementos em um @turno ---, desenvolvemos a classe abstrata `State`.
Ela deve manter, por meio do atributo `game`, uma referência para a classe que representa um @jogo a fim de ter acesso às suas regras e a outros dados invariáveis.

Outra característica de um @estado é manter a disposição de peças nas @casa:pl do tabuleiro, o que é feito por meio do @vetor `slots`.
Ele guarda objetos da classe `Slot` e deve ser indexado da mesma forma em todos os @estado:pl para que o programa consiga acessar os componentes de forma direta.
O método concreto `getSlot` oferece uma facilidade ao desenvolvedor por implementar uma busca de uma @casa naquele vetor dado o seu índice.
Por isso, a decisão de como organizar os objetos naquele @vetor deve ser pensada no mesmo momento em que o projetista implementa o método abstrato `getEncodedState`, o qual sintetiza todas as informações relevantes num conjunto de canais a ser fornecido para a @rn.

Outro atributo armazenado em cada objeto da classe `State` é o `indexOfPlayer`, que guarda a informação sobre qual dos @jogador:pl pode realizar um @movimento no @turno atual, usualmente chamada de "vez do @jogador".
A @pontuacao dos @jogador:pl também depende de como os @turno:pl decorreram durante a @partida, o que é salvo no atributo `score`.
Para fins de organização do código-fonte e de abertura para expansão, criamos uma classe abstrata chamada `Score` para representar a @pontuacao de todos os @jogador:pl em um determinado @estado.

O único atributo dessa classe é o mapa `pointsOfEachPlayer`, que atribui um valor em pontos para cada jogador de acordo com o índice a esse atribuído pelo projetista.
É relevante ressaltar que alguns @jogo_tabuleiro:pl, como o Xadrez, não utilizam sistema de @pontuacao, atribuindo apenas o resultado de vitória para um dos @jogador:pl.
Nesses casos, recomendamos a implementação de forma que a quantidade de pontos permaneça como $0$ durante toda a partida e que, no @estado que representa fim de @jogo, esse marcador seja alterado para $1$ na entrada referente ao vencedor.

Finalmente, a classe abstrata `Game` representa as regras do @jogo e guarda os conjuntos de dados imutáveis durante uma @partida.
Para representá-lo em interfaces com o usuário, o atributo `name` requer que o projetista o nomeie.
Então, no atributo `slots`, o projetista deve fornecer a lista de @casa:pl organizada previamente.
O mesmo deve ser feito em relação ao argumento `moves` para a lista de @movimento:pl e em relação ao atributo `players` para a lista de @jogador:pl.
A classe oferece métodos auxiliares que buscam por um @movimento ou por um @jogador em seu respectivo @vetor dado o seu índice.

Em relação aos métodos abstratos da classe `Game`, destacamos os `getQuantityOfRows`, `getQuantityOfColumns` e `getQuantityOfChannels` que respectivamente definem a a quantidade de linhas, de colunas e de canais da matriz que representa um @estado codificado.
Esses dados devem ser definidos previamente e ser imutáveis para um @jogo porque eles são usados na construção da arquitetura da @resnet que orienta o @agint.

Outro método que deve ser determinístico é o `constructInitialState`, em que o projetista descreve a forma como o @estado inicial da @partida é construído.
Por exemplo, no @jogo_velha, ele se iniciaria com um tabuleiro vazio.
Já no Xadrez, as @casa:pl de um lado do tabuleiro e do outro devem estar preenchidas pelas devidas peças de cada um dos @jogador:pl.
O comportamento dos quatro últimos métodos citados seria melhor representado por métodos estáticos.
Entretanto, a linguagem @js não permite a definição desse tipo de método numa classe abstrata.

Agora tratando dos métodos dinâmicos da classe `State`, destacamos a responsabilidade do método `getIndexesOfValidMoves`.
Sua função é determinar, a partir de um certo @estado fornecido, quais são os @movimento:pl que o @jogador daquele turno poderá executar.
Para fins de otimização de memória, seu retorno deve ser um conjunto sem repetição de índices referentes aos @movimento:pl válidos de acordo com a ordem dada pelo @vetor salvo na classe `Game`.
Esse comportamento é obtido pela estrutura de dados `Set`, implementada na linguagem @js.
Esse conjunto de jogadas válidas é utilizado, entre outros, para filtrar o @vetor de qualidades atribuídas pelo modelo de @resnet e apresentar apenas os adequados ao @agint.

Com uma lógica de implementação similar, o método `getIndexOfNextPlayer` deve determinar de qual @jogador será a vez no próximo @turno.
É comum que os @jogador:pl se alternem sequencialmente a cada @turno durante uma @rodada, mas é possível para o projetista definir as regras do @jogo de forma que um @jogador deixe de jogar por um @turno ou que tenha nele mais de um @movimento.
O retorno desse método deve ser o índice do @jogador escolhido conforme o @vetor salvo na classe `Game`.

Com o auxílio do último método, o projetista pode descrever as regras para atualizar um dado @estado.
Uma vez que seguimos a convenção de que os objetos representantes de conceitos do @jogo devem ser imutáveis, o método `play`, responsável por essa atualização, retorna um novo objeto da classe `State`.
Seus argumentos são o @estado do @turno atual e o índice do @movimento a ser realizado.
O projetista deve codificar a lógica para descrever a lista de @casa:pl atualizada, incrementar ou decrementar as @pontuacao:pl e definir próximo @jogador.

Após cada @turno, é necessário determinar se o @estado gerado leva ao fim da @partida.
O projetista deve descrever essa consulta por meio do método `isFinal`, que recebe o @estado referenciado e retorna um valor do tipo `boolean`, definido como `true` para quando a @partida deve se encerrar ou como `false` para quando ela deve continuar.
Para isso, ele dispõe de todos os dados discutidos, como a disposição das peças, a pontuação dos jogadores e quaisquer outros atributos que ele tenha acrescentado às classes concretas criadas por ele.

=== Implementação do jogo @ligue4

A fim de executar o experimento desta pesquisa, implementamos, no módulo `games`, os @jogo:pl @ligue4, @jogo_velha e uma variação própria do @jogo_velha em um tabuleiro de 9 linhas e 9 colunas em que os @jogador:pl acumulam pontos ao preencher formatos especificados no tabuleiro.
Criamos um conjunto de objetos para cada um desses jogos, de forma a permitir ao usuário do sistema jogá-los.
Uma parte representativa desses objetos foram selecionados para realizar testes de unidade, a fim de garantir que suas regras estavam bem definidas antes de prosseguir com a execução dos métodos de busca.

Escolhemos o @ligue4 para realizar o experimento porque ele é um jogo de informação completa entre dois jogadores que apresenta um tamanho de tabuleiro razoável e uma quantidade pequena de @movimento:pl possíveis.
Dessa forma, realizamos com atenção a implementação dos objetos relacionados a esse @jogo descritos no módulo `games` e também naqueles dos módulos mais derivados, conforme dispostos na @figure:modulos.

O @ligue4 é jogado em um tabuleiro vertical de $6$ linhas e $7$ colunas, o que resulta em $42$ @casa:pl.
As peças são discos de mesmo tamanho divididas igualmente entre cada um dos @jogador:pl, que recebe todas as peças de uma das duas cores disponíveis.
Dentro de um @turno, o jogador atual deve escolher uma colunas que já não tenha sido completamente preenchida para colocar sua peça.
No tabuleiro vertical, ela cairá até a linha mais baixa ainda não preenchida naquela coluna.
Após colocada, uma peça não pode mais ser removida naquela @partida.

Então, a @rodada passa a vez para o segundo @jogador, que deve escolher seu @movimento da mesma forma que o primeiro.
Um @jogador vence caso ele posicione $4$ de suas peças de forma adjacente na mesma linha, coluna ou diagonal.
Configura um empate o caso em que todas as @casa:pl tenham sido preenchidas e nenhum @jogador tenha marcado um dos formatos especificados.
Essas regras fazem com que haja mais de 4.5 trilhões de combinações possíveis de peças no tabuleiro, mesmo que o jogo permita no máximo $7$ @movimento:pl em qualquer @turno @cahn:2024:connect4.

Nesta seção, descrevemos o processo de implementação do jogo @ligue4, destacando os conceitos fundamentais discutidos na @subsection:componentes_fundamentais.
Em relação à pré-implementação das classes abstratas, poucas adaptações foram necessárias.
Todas as classes concretas seguiram a convenção de iniciar seus nomes com o termo `ConnectFour` seguido do nome da classe que ela implementa.
Conforme visto na @figure:diagrama_classes_pacote_games, as classes `Slot` e `Move` foram acrescidas de novos atributos.
Além disso, observamos a necessidade de criar uma nova estrutura de dados abstrata para representar os formatos considerados para levar à vitória, o que foi feito pelo tipo `ConnectFourShape`.
Ele permite definir linhas de um tamanho arbitrário --- embora tenhamos escolhido $4$ peças conforme a descrição padrão do jogo --- e a direção de marcação --- se horizontal, vertical ou em uma diagonal principal ou secundária.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [As propriedades com visibilidade privada têm métodos públicos de encapsulamento para a obtenção de seus valores que não foram representados.],
  [#figure(
    caption: [Classes concretas alteradas na implementação do @ligue4 e tipo utilitário nela definido.],
    image(
      width: 70%,
      "../../assets/images/uml/games/simplified_class_diagram_of_package_games.png",
    ),
  )<figure:diagrama_classes_pacote_games>],
)

A primeira classe concreta implementada foi a `ConnectFourPlayer`, referente aos dados imutáveis de cada @jogador.
O @ligue4 não guarda nenhuma informação relevante sobre um @jogador exceto aquelas necessárias para a sua distinção na interface com o usuário.
Assim, não foi necessária nenhuma alteração na classe.
Ao criar seus objetos, escolhemos arbitrariamente o nome @alice:long e o símbolo @alice:short para o @jogador de índice $0$ e o nome @bruno:long e símbolo @bruno:short para o @jogador de índice $1$.
Tais valores não representam nomes reais de pessoas, mas servem apenas como facilitadores de distinção entre esses objetos para os desenvolvedores do protótipo.

Em seguida, implementamos a classe concreta `ConnectFourSlot`, que representa o conteúdo guardado em uma @casa do tabuleiro.
O @ligue4 utiliza peças simples, cuja única diferença é a cor, que é associada a cada um dos @jogador:pl.
Por isso, a única informação relevante para cada @casa é se ela está vazia ou, caso não esteja, qual @jogador a preencheu.
Então, acrescentamos o atributo `indexOfOccupyingPlayer`, que pode ser assinalado com o índice $0$ caso o @jogador @alice tenha marcado uma peça, com o índice $1$ caso o @jogador @bruno o tenha feito, ou com o valor `null` se a @casa estiver vazia.
Quanto aos objetos utilizados pelo experimento, criamos todas as $49$ @casa:pl, definindo o atributo de jogador ocupante como `null` e nomeando-as com a convenção "rXcY", em que os termos "X" representam o índice da linha que ela ocupa e o termo "Y" representa o da coluna.
Para os testes de unidade, também criamos novos objetos preenchidos em diferentes combinações.

Diferentemente do @jogo_velha, em que cada @movimento tem relação direta com uma única @casa do tabuleiro, o @ligue4 precisa calcular a posição onde marcar uma peça a depender de dois fatores: o índice da coluna escolhida pelo @jogador e a disposição de peças já marcadas nela.
Percebe-se então que esse índice deve ser armazenado no atributo `indexOfColumnInWhichPlacePiece` da classe concreta `ConnectFourMove`.
Implementamos também o método auxiliar `getIndexOfSlotInWhichPlacePiece`, responsável por acessar, de baixo para cima, cada @casa da coluna para encontrar a primeira que esteja vazia no @estado fornecido.
Depois, criamos um objeto para cada uma das colunas, cujo índice guardamos no atributo discutido e cujos títulos e descrições foram dados em relação ao seu número ordinal.

A verificação acerca da marcação dos formatos de linha foi implementada por funções no arquivo nomeado `ConnectFourShape`.
A lógica desses utilitários é sintetizada no @code:get_index_of_player_who_is_occupying_shape, que determina se um formato iniciado em dada @casa está sendo ocupado por algum jogador e, caso esteja, qual é o seu índice.

#describe_figure(
  placement: auto,
  sticky: true,
  [#figure(
    supplement: "Algoritmo",
    caption: [Código-fonte simplificado da função `getIndexOfPlayerWhoIsOccupyingShape`.],
    ```js
    function getIndexOfPlayerWhoIsOccupyingShape(
        indexOfFirstSlot: IndexOfSlot, shape: Shape
    ): IndexOfPlayer | null {
        const slots = getSlotsThatFormShape(indexOfFirstSlot, shape);
        let indexOfPlayerOccupyingPreviousSlot = null

        for (const slot of slots) {
            const indexOfPlayer = slot.getIndexOfOccupyingPlayer();
            if (indexOfPlayerOccupyingPreviousSlot === null) {
                indexOfPlayerOccupyingPreviousSlot = indexOfPlayer;
            } else if (indexOfPlayer !== indexOfPlayerOccupyingPreviousSlot) {
                return null;
            }
            indexOfPlayerOccupyingPreviousSlot = indexOfPlayer;
        }

        return indexOfPlayerOccupyingPreviousSlot;
    }
    ```,
  )<code:get_index_of_player_who_is_occupying_shape>],
)

Essa função é utilizada na classe concreta `ConnectFourScore`, que representa e oferece métodos para calcular a @pontuacao dos @jogador:pl.
Quando seus objetos são inicializados, todos os @jogador:pl têm atribuído o valor de $0$ pontos.
Por meio de seu método auxiliar `getUpdatedScore`, o programa verifica, para cada uma das @casa:pl, se houve marcação de qualquer uma das linhas de $4$ peças adjacentes.
Caso positivo, a função retorna um objeto `Score` em que o @jogador vencedor é marcado com $1$ ponto.

Então, a classe concreta `ConnectFourGame` utiliza todos os dados discutidos para representar as regras do @jogo.
Ao criar seu objeto, o projetista deve fornecer as listas de @jogador:pl, @movimento:pl e @casa:pl previamente instanciadas.
Um primeiro método de destaque dessa classe é o `getIndexesOfValidMoves`, cuja implementação recebe um @estado e retorna os índices das colunas do tabuleiro em que alguma de suas @casa:pl ainda esteja vazia.
Após selecionar um @movimento, o @jogador deve executar o método `play`, que retorna o @estado atualizado com a marcação da peça na posição escolhida, além da eventual @pontuacao nova caso tenha sido uma jogada vitoriosa.
Em seguida, o algoritmo utiliza o método `isFinal` para determinar se a @partida chegou ao fim com o novo @estado, o que ocorre quando todas as @casa:pl estão preenchidas ou quando um dos @jogador:pl marcou um ponto.
Caso a @partida continue, o método `getIndexOfNextPlayer` é responsável por passar a vez para o oponente.

Outra responsabilidade da implementação da classe `Game` é estabelecer a quantidade de linhas, de colunas e de canais do @estado codificado.
Decidimos utilizar a mesma dimensão do tabuleiro ($6$ linhas e $7$ colunas) para a codificação e empilhar sobre ela $4$ canais de dados, inicializados com o valor $0$.
Como descrito na @section:alphazero, o canal de índice $0$ terá cada um de seus valores definido como $1$ se a @casa correspondente por estiver marcada pelo jogador @alice.
Já as @casa:pl do canal de índice $1$ serão ativadas pelas peças do @jogador @bruno, ao passo em que as @casa:pl vazias ativam o canal de índice $2$.
Finalmente, o canal de índice $3$ tem a responsabilidade de informar à @rn de qual @jogador é a vez no @turno atual, sendo completamente preenchido com $0$ caso seja do @jogador @alice ou com $1$ caso seja do @jogador @bruno.

=== Elaboração dos algoritmos de busca

Havendo devidamente representado o @jogo @ligue4, passamos à implementação do módulo `search`, responsável pelos algoritmos de @mcts:long e de predição por meio de @resnet:pl.
A lógica de construção de suas principais classes foi inspirada pela implementação de referência de #cite(form: "prose", <forster:2023:alphazero>).

Primeiramente definimos tipos úteis para a melhor descrição de conceitos comuns, como mostrado na @figure:diagrama_pacote_search_tipos.
Todos eles são @alias:pl do tipo primitivo `number`, que representa números reais.
Seus significados são descritos nesta seção, conforme a discussão acerca de seus usos.

#describe_figure(
  sticky: true,
  note: [O pacote `primitive` se refere aos tipos de dados concretos disponibilizados pela linguagem @js.],
  [#figure(
    caption: [Tipos de dados comuns definidos pelo pacote `search`.],
    image(
      width: 65%,
      "../../assets/images/uml/search/types_diagram_of_package_search.png",
    ),
  )<figure:diagrama_pacote_search_tipos>],
)

O primeiro elemento necessário para implementar a @mcts é a classe abstrata `TreeNode`, cujo diagrama é apresentado na @figure:diagrama_classes_pacote_search_mostrando_classe_tree_node.
Ela tem a função de implementar um nó da árvore de busca, o qual representa um @estado da @partida simulada e que é guardado em seu atributo `state`.
Também são importantes os dados sobre o histórico que levou até esse @estado.
Por isso, armazenamos no atributo `indexOfPlayedMove` o índice do @movimento jogado no @turno anterior e no atributo `indexOfPlayerWhoPlayedMove` o índice do @jogador que o efetuou.
O caso em que esses dois marcadores estarão vazios é no início da partida, que corresponde ao nó raiz da árvore.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [As propriedades com visibilidade privada e protegida têm métodos públicos de encapsulamento para a obtenção de seus valores que não foram representados.],
  [#figure(
    caption: [Classe `TreeNode` definida no pacote `search`.],
    image(
      width: 90%,
      "../../assets/images/uml/search/simplified_class_diagram_of_package_search_showing_class_tree_node.png",
    ),
  )<figure:diagrama_classes_pacote_search_mostrando_classe_tree_node>],
)

Para representar a transição entre os nós e permitir realizar a fase de retro-propagação da busca, salvamos em cada nó a referência para seu nó pai por meio do atributo `parentNode`, que estará vazio apenas para a raiz da árvore.
Uma vez que um @estado pode levar a múltiplas configurações da @partida por meio de cada um de seus @movimento:pl válidos, decidimos representar, no atributo `childrenNodes`, as transições do nó para seus filhos por meio de um mapa indexado, em que cada entrada marca o @movimento escolhido e o nó que ele gerou.

Como discutido na @section:mcts sobre a diretriz de @fitness da @mcts, a cada ciclo de busca, a etapa de retro-propagação incrementa o contador de visitas e atualiza a expectativa de qualidade da @partida para todos os nós do ramo selecionado.
Esses dois marcadores são armazenados nos atributos `quantityOfVisits` e `qualityOfMatch`, respectivamente.

Quanto aos métodos da classe `TreeNode`, destacamos o `getQualityOfMatchFromScore`, que converte a @pontuacao final dos jogadores em um número do tipo `QualityOfMatch`, representante da qualidade da @partida para o @jogador atual.
Esse dado é retro-propagado recursivamente até o nó raiz por meio do método `updateQualityOfMatchAndQuantityOfVisitsOnBranch`, incrementando-o nos turnos do @jogador vencedor e decrementando-o para os demais.

Já a etapa de seleção é gerenciada pelo método `selectBestChildNode`, que calcula o valor de @fitness para cada nó já expandido e escolhe o melhor.
Para isso, é chamado o método `calculateFitnessOfChild`, que soma os componentes de @aproveitamento e de @exploracao da equação de @uct, equilibrando-os por meio da constante de @exploracao fornecida.
Uma vez que a @mcts clássica e a adaptada pelo @alphazero calculam o valor de @fitness de forma diferente, utilizamos os métodos abstratos para defini-los.

Finalmente, o método `qualityOfMove` é responsável por classificar os @movimento:pl válidos a partir do @estado inicial da árvore.
A forma de avaliação utilizada pela implementação de referência @forster:2023:alphazero prioriza os @movimento:pl que levaram a ramos com o maior número de visitas.
Essa lógica se justifica porque se entende que um @estado muito visitado foi aquele mais selecionado pela diretriz de busca.
Entretanto, percebemos que, quando realizamos a busca a partir de um @estado próximo de levar a uma vitória, essa heurística se prova falha.
Isso ocorre porque o @estado vitorioso não gera mais filhos e, dessa forma, não pode mais ser visitado pela busca.
Assim, o algoritmo é obrigado a visitar seus vizinhos, o que os torna melhor classificados.
Para resolver esse problema, decidimos alterar o cálculo da qualidade de um @movimento para a @equation:qualidade_do_movimento, que alinha a qualidade estimada da @partida e a quantidade de visitas ao dado ramo.

#equation[
  $
    F(n) = Q(n) + root(4, V(n))
  $ <equation:qualidade_do_movimento>

  Na qual:
  - $F(s)$ é a qualidade do @movimento representado pelo nó $n$;
  - $Q(n)$ é a qualidade da @partida calculada por meio de simulações a partir do nó $n$;
  - $V(s)$ é quantidade de vezes em que o nó $n$ foi visitado nas iterações anteriores.

  #information_footer(
    source: print_source_for_content_created_by_authors(),
  )
]

A @mcts:long é gerenciada pela classe abstrata `Search`, cujo diagrama é mostrado na @figure:diagrama_classes_pacote_search_mostrando_classe_search.
Ela armazena dados relevantes para executar o algoritmo, como o coeficiente de exploração e a quantidade de ciclos a serem realizados, o que é guardado no atributo `quantityOfExpansions`, além de um objeto da classe auxiliar `Random` que realiza operações pseudo-aleatórias a partir da mesma @seed informada ao programa.

#describe_figure(
  placement: auto,
  sticky: true,
  [#figure(
    caption: [Classe `Search` definida no pacote `search`.],
    image(
      width: 60%,
      "../../assets/images/uml/search/simplified_class_diagram_of_package_search_showing_class_search.png",
    ),
  )<figure:diagrama_classes_pacote_search_mostrando_classe_search>],
)

O método abstrato `expandTree` da classe `Search` executa o ciclo de busca, utilizando o método `selectNextNode` para realizar a etapa de seleção e o método `simulateMatch` para implementar a etapa de simulação da @mcts clássica ou de predição da @mcts adaptada pelo @alphazero.
Esse primeiro algoritmo foi implementado nas classes concretas `CommonSearch` e `CommonTreeNode`.
Essa define a etapa de expansão por um método chamado `expand`, que recebe o @movimento a expandir e gera um único novo nó.

Já em relação à @mcts adaptada, a classe concreta `AgentGuidedSearch` implementa a busca e define um novo atributo chamado `predictionModel`, que guarda o modelo de @resnet responsável por orientar a etapa de predição.
Em seguida, durante a etapa de expansão, os valores estimados por sua @policy_head geram todos os @movimento:pl válidos para o @estado atual.
Essa fase é implementada pelo método `expand` da classe concreta `AgentGuidedTreeNode`, que recebe aquele @vetor e guarda a qualidade estimada no novo atributo `qualityOfMoveAttributedByModel` de cada nó filho.
Por fim, a predição da qualidade da partida é utilizada para orientar a fase de retro-propagação.

=== Construção da @resnet:long

Considerando a variação de complexidade entre diferentes @jogo:pl e seguindo a recomendação da implementação de referência @forster:2023:alphazero, possibilitamos ao projetista de um protótipo definir parâmetros da arquitetura da @resnet:long utilizada pelos @agint:pl.
Para isso, criamos a classe `ResidualNeuralNetwork`, que recebe os seguintes dados: (1) #glossarium.gls("seed", display: `seed`), usado para inicializar os @peso:pl e @vies:pl da @rn; (2) `quantityOfResidualBlocks`, para definir a quantidade de blocos residuais a serem criados na @backbone da rede; e (3) `quantityOfHiddenChannels`, referente à quantidade de canais usada nas camadas internas de processamento da rede.

A classe construtora de modelos de @rn e as operações sobre tensores foram disponibilizadas pelo pacote do projeto @tensorflow_js.
Ele disponibiliza algumas formas de construir a arquitetura da rede, dentre as quais selecionamos a de #text_in_english[LayersModel].
Tomamos o cuidado de encapsular o uso do @tensorflow dentro dessa classe, a fim de permitir sua substituição se necessário sem requerer a refatoração de outros componentes do projeto.
Então, definimos funções auxiliares para a construção das camadas de adaptação da entrada, de blocos residuais e de saída para a @policy_head e para a @value_head.

Acerca do treinamento, o método `train` dessa mesma classe recebe os conjuntos de @estado:pl codificados e de saídas esperadas para a @policy_head e para a @value_head.
O alinhamento dos @peso:pl e @vies:pl é realizado pelo método `fit` do objeto de `LayersModel`, utilizando o otimizador @adam.
Para a @policy_head, selecionamos a função de @perda de @entropia_cruzada_categorica (#glossarium.gls-custom("entropia_cruzada_categorica")), ao passo em que escolhemos a função de @erro_quadratico_medio (#glossarium.gls-custom("erro_quadratico_medio")) para calcular a @perda da @value_head.
Quanto à execução do programa, permitimos que o usuário escolha os seguintes parâmetros: (1) `quantityOfEpochs`, para definir a quantidade de épocas de treinamento; e (2) `sizeOfBatch`, para ajustar o tamanho do conjunto de entradas e saídas usado a cada passo de alinhamento.

=== Geração de @agint:pl
