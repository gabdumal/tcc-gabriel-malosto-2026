#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/figure.typ": describe_figure
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": glossarium
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

O módulo `core` tem a responsabilidade de definir constantes, tipos e funções utilitárias para todos os demais módulos.
Destacam-se algumas funções de conversão de tipos de dados, sobretudo para tratar argumentos fornecidos pela linha de comando em suas representações numéricas.
Também estão disponíveis utilitários para a formatação de dados de tipos compostos e de descritores dos testes de unidade.
Além disso, o módulo gerencia a codificação de dados para o formato de @json e a equivalente conversão para objetos em memória, o que é necessário para salvar e interpretar o histórico de @partida:pl para o treinamento de modelos.

A fim de facilitar a compreensão de conceitos comuns ao domínio da aplicação, definimos por meio do @ts alguns tipos derivados, utilizados por todo o projeto.
Os principais estão dispostos na @figure:diagrama_tipos.
Ela também explicita os tipos concretos `string` e `number` da linguagem @js, que guardam, respectivamente, texto e números reais.
O tipo `Char` foi um @alias (#glossarium.gls-custom("alias")) dado para campos de texto de apenas um caractere, como a marcação de uma peça em uma @casa do tabuleiro.
Já o tipo `Integer` é um @alias para um valor numérico que deve ser preenchido apenas por um número inteiro, como por exemplo na indexação de dados em vetores.
Essa lógica foi tão comumente utilizada na elaboração do sistema, que decidimos criar @alias:pl para a indexação de @movimento:pl (moves), @casa:pl (slots) e @jogador:pl (players).

Outro dado relevante é a marcação de pontos dos jogadores, que é feita com números inteiros pelo @alias `Points`.
Guardamos a @pontuacao completa de todos os @jogador:pl por meio da estrutura de indexação por chave-valor `Map`, do @js.
No tipo abstrato `PointsOfEachPlayer`, as chaves são definidas pelo índice de cada @jogador, conforme registrado pelo projetista do @jogo, ao passo em que os pontos são salvos no campo de valor.
Finalmente, o tipo `EncodedState` representa o formato de codificação de um estado em canais, como descrito na @section:alphazero. Ele aceita qualquer matriz multidimensional de valores reais, embora tenhamos respeitado o padrão de utilizar apenas os valores os $0$ e $1$ para definirmos tais codificações.

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

Seguindo a descrição modular do sistema, o módulo `game` é responsável por estabelecer os componentes fundamentais para representar um @jogo_turno digitalmente.
Todos eles foram implementados por meio de classes abstratas, considerando que a linguagem @js não dispõe de estruturas como interfaces ou protocolos.
Seus principais atributos e métodos, além das relações entre si, podem ser vistos na @figure:diagrama_classes_pacote_game.

#describe_figure(
  placement: auto,
  sticky: true,
  note: (
    [Os métodos abstratos são representados em itálico, ao passo em que os métodos estáticos são representados sublinhados.],
    [As propriedades com visibilidade privada têm métodos públicos de encapsulamento para a obtenção de seus valores.],
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
] --- ou até mesmo uma carta específica dentro de uma mão.
Essa variabilidade não nos permite atribuir nenhum dado comum à classe.
Dessa forma, cabe inteiramente ao projetista definir o conteúdo possível por meio de uma classe concreta que a implemente.

Em seguida, implementamos a classe `Player`, que representa os dados fixos de um @jogador durante todo o período de duração da partida.
Os dados comuns identificados foram acerca da distinção entre os @jogador:pl na interface de execução por linha de comando.
Nesse sentido, quando o projetista for criar um objeto da classe `Player`, ele deve atribuir um nome por meio do atributo `name` e um símbolo por meio do atributo `symbol` --- como "primeiro" (1) e "segundo" (2), peças "brancas" (B) e "pretas" (P), ou (X) e (O), por exemplo.

Para registrar as possibilidades de transição entre @estado:pl, criamos a classe `Move` que representa um @movimento.
Por padrão, ela apenas guarda dados de identificação para a interface com o usuário, quais sejam o título com atributo `title` e sua descrição com atributo `description`.
Para todas as classes abstratas, o projetista pode definir novos atributos caso sejam necessários para efetuar as regras do @jogo.

A fim de permitir que os @agint:pl gerados possam avaliar as qualidade dos @movimento:pl, é necessário que o projetista descreva previamente ao início da @partida todos aqueles que são possíveis em qualquer momento.
Por exemplo, #cite(form: "prose", <silver:2017:mastering_chess_shogi>) representam o Xadrez por meio de $4672$ @movimento:pl, por meio de uma matriz de $8$ @casa:pl na horizontal, $8$ @casa:pl na vertical e $73$ mudanças de estado que uma peça pode efetuar.
Apesar dessa lista de opções ser extensa, ela é necessária porque a estrutura da @rn usada pelo agente atribui um valor de qualidade para todos os @movimento:pl do jogo, mesmo aqueles que não são válidos em um @estado específico.
