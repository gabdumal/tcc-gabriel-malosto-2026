#import "../../components/note.typ": note_from_gabriel
#import "/template/common/components.typ": describe_figure, todo_note
#import "/template/packages.typ": glossarium
#import "/template/common/util.typ": text_in_english

= Resultados <chapter:resultados>

Este trabalho é precursor no desenvolvimento do sistema @apts, realizado por meio de código-livre e publicado em um repositório público @malosto:2026:apts.
Essa aplicação permite a uma pessoa projetista de um @jogo_tabuleiro descrever as regras de um protótipo de @jogo.
Então, o programa oferece métodos para gerar e treinar modelos de @ia:long que atuam como @agint:pl para simular @partida:pl.

As simulações geram conjuntos de dados acerca de quais @movimento:pl tomados levam a melhores resultados.
Espera-se que, por meio deles, o projetista possa gerar informações estatísticas acerca das regras implementadas.
Isso tem o objetivo de diminuir o esforço humano nas etapas de @playtest, sobretudo aquelas que envolvem testes de estresse e balanceamento, em que a experiência do jogador não é a variável principal.

== Ambiente de execução

Os autores têm a expectativa de que o @apts possa ser acessado por meio de programas navegadores da internet, dispondo de uma interface de usuário satisfatória para usuários não familiarizados com programação.
Entretanto, concluiu-se que seria vantajoso desenvolver scripts de teste de software para verificar sua qualidade durante as versões iniciais de desenvolvimento.
Por isso, estabeleceu-se como requisito que o sistema funcionasse como uma biblioteca, de forma que possa ser utilizado tanto por um programa de linha de comando, como também por uma página da web.

Com essa perspectiva, escolhemos escrever o código-fonte do sistema na linguagem de programação @js.
Essa é utilizada comumente para o desenvolvimento de páginas da web, tendo suporte oferecido pelos principais navegadores, como comprovado pelo suporte fornecido pela empresa #cite(form: "prose", <aws:2020:supported_browsers>) ao seu @sdk para @js.

Essa linguagem também pode ser utilizada em um ambiente de execução de linha de comando, sendo o mais comum o @node.
Ele utiliza o motor de @js V8, o que garante o desempenho para programas. Apesar de rodar em uma só @thread, o ciclo de processamento trata eventos assíncronas por meio de operações primitivas @node:2025:introduction.

== Ambiente de desenvolvimento

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

O projeto da aplicação desenvolvida a divide em cinco módulos, quais sejam: `core`, `game`, `search`, `games` e `interface`.
A @figure:modulos representa as relações de dependência entre tais módulos e com os pacotes externos `ts-graphviz` e `tensorflow`.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [Um módulo aponta para o pacote do qual ele depende.],
  [#figure(
    caption: [Dependências entre os módulos do sistema e com pacotes externos.],
    image(
      width: 55%,
      "/academic_work/assets/images/modules_diagram.png",
    ),
  )<figure:modulos>],
)

=== Utilitários

O módulo `core` tem a responsabilidade de definir constantes, tipos e funções utilitárias para todos os demais módulos.
Destacam-se algumas funções de conversão de tipos de dados, sobretudo para tratar argumentos fornecidos pela linha de comando em suas representações numéricas.
Também estão disponíveis utilitários para a formatação de dados de tipos compostos e de descritores dos testes de unidade.
Além disso, o módulo gerencia a codificação de dados para o formato de @json e a equivalente conversão para objetos em memória, o que é necessário para salvar e interpretar o histórico de @partida:pl para o treinamento de modelos.

A fim de facilitar a compreensão de conceitos comuns ao domínio da aplicação, definimos por meio do @ts alguns tipos derivados, utilizados por todo o projeto.
Os principais estão dispostos na @figure:diagrama_tipos.
Ela também explicita os tipos concretos `string` e `number` da linguagem @js, que guardam, respectivamente, texto e números reais.
O tipo `Char` foi um @alias (#glossarium.gls-custom("alias")) dado para campos de texto de apenas um caractere, como a marcação de uma peça em uma @casa do tabuleiro.
Já o tipo `Integer` é um @alias para um valor numérico que deve ser preenchido apenas por um número inteiro, como por exemplo na indexação de dados em @vetor:pl.
Essa lógica foi tão comumente utilizada na elaboração do sistema, que decidimos criar @alias:pl para a indexação de @movimento:pl (moves), @casa:pl (slots) e @jogador:pl (players).

Outro dado relevante é a marcação de pontos dos jogadores, que é feita com números inteiros pelo @alias `Points`.
Guardamos a @pontuacao completa de todos os @jogador:pl por meio da estrutura de indexação por chave-valor `Map`, do @js.
No tipo abstrato `PointsOfEachPlayer`, as chaves são definidas pelo índice de cada @jogador, conforme registrado pelo projetista do @jogo, ao passo em que os pontos são salvos no campo de valor.
Finalmente, o tipo `EncodedState` representa o formato de codificação de um estado em canais, como descrito na @section:alphazero. Ele aceita qualquer matriz multidimensional de valores reais, embora tenhamos respeitado a convenção de utilizar apenas os valores os $0$ e $1$ para definirmos tais codificações.

#describe_figure(
  placement: auto,
  sticky: true,
  note: (
    [O pacote `Primitive` se refere aos tipos de dados concretos disponibilizados pela linguagem @js.],
    [As propriedades com visibilidade privada têm métodos públicos de encapsulamento para a obtenção de seus valores.],
  ),
  [#figure(
    caption: [Tipos de dados comuns utilizados pelo projeto.],
    image(
      width: 65%,
      "/academic_work/assets/images/types_diagram.png",
    ),
  )<figure:diagrama_tipos>],
)

=== Componentes fundamentais de um @jogo

Seguindo a descrição modular do sistema, o módulo `game` é responsável por estabelecer os componentes fundamentais para representar um @jogo_turno digitalmente.
Todos eles foram implementados por meio de classes abstratas, considerando que a linguagem @js não dispõe de estruturas como interfaces ou protocolos.
Seus principais atributos e métodos, além das relações entre si, podem ser vistos na @figure:diagrama_classes_pacote_game.

#describe_figure(
  placement: auto,
  sticky: true,
  note: (
    [Os métodos abstratos são representados em itálico.],
    [As propriedades com visibilidade privada têm métodos públicos de encapsulamento para a obtenção de seus valores que não foram representados.],
  ),
  [#figure(
    caption: [Dependências entre os módulos do sistema e com pacotes externos.],
    image(
      width: 100%,
      "/academic_work/assets/images/simplified_class_diagram_of_package_game.png",
    ),
  )<figure:diagrama_classes_pacote_game>],
)

A classe mais simples é a que representa uma @casa do tabuleiro, chamada de `Slot`.
Esse conceito é um dos mais variáveis em @jogo_turno:pl, que pode marcar apenas o símbolo de um @jogador --- como no Jogo da Velha ---, uma dentre peças que apresentam comportamentos diversos --- como no Xadrez ---, camadas sucessivas de peças --- como no Gobblet Gobblers #footnote[
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
Por exemplo, no Jogo da Velha, ele se iniciaria com um tabuleiro vazio.
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

== Search
