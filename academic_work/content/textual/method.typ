#import "../../components.typ": get_term, note_from_gabriel, note_from_igor
#import "/template/common/components.typ": done_note, progress_note, todo_note, describe_figure
#import "/template/packages.typ": glossarium

= Material e métodos <chapter:metodos>

// #progress_note(note_from_gabriel[Deve categorizar o tipo de pesquisa])

O presente trabalho se classifica como uma pesquisa de natureza aplicada acerca do uso de @agint:pl para realizar a fase de @playtest em @jogo_tabuleiro:pl.
Ela busca, através de uma abordagem qualitativa, aplicar os métodos de #glossarium.gls(first: true, "mcts") e de #glossarium.gls(first: true, plural: true, "resnet") conforme o projeto @alphazero para gerar dados de apoio ao balanceamento para o desenvolvedor de jogos.
A pesquisa também é exploratória, pois permitirá aumentar familiaridade acerca da modelagem de jogos e seus mecanismos com os métodos de aprendizagem profunda para uso como ferramentas de projeto.


== Material <section:material>

Dando continuidade aos trabalho desenvolvidos em
#cite(<araki:2020:testes_de_software>, form: "prose")
#cite(<malosto:2023:alphazero_como_ferramenta_de_playtest>, form: "prose")
#cite(<malosto:2025:moving_towards>, form: "prose"),
foi desenvolvida neste trabalho a aplicação de linha de comando chamada *@apts*, capaz de representar @jogo:pl discretos e gerar @agint:pl que simulem @partida:pl conforme o método de @selfplay.
As simulações coletam dados sobre as @partida:pl para prover ao projetista do @jogo informações estatísticas usadas para orientar testes de estresse e de balanceamento, que focam em aspectos técnicos em vez de tratar da experiência do @jogador.

=== Ambiente de execução

Os autores têm a expectativa de que o @apts possa ser acessado por meio de programas navegadores da internet, dispondo de uma interface de usuário satisfatória para usuários não familiarizados com programação.
Entretanto, concluiu-se que seria vantajoso desenvolver scripts de teste de software para verificar sua qualidade durante as versões iniciais de desenvolvimento.
Por isso, estabeleceu-se como requisito que o sistema funcionasse como uma biblioteca, de forma que possa ser utilizado tanto por um programa de linha de comando, como também por uma página da web.

Com essa perspectiva, escolhemos escrever o código-fonte do sistema na linguagem de programação #get_term("js").
Essa é utilizada comumente para o desenvolvimento de páginas da web, tendo suporte oferecido pelos principais navegadores, como comprovado pelo suporte fornecido pela empresa #cite(form: "prose", <aws:2020:supported_browsers>) ao seu @sdk para #get_term("js").

Essa linguagem também pode ser utilizada em um ambiente de execução de linha de comando, sendo o mais comum o #get_term("node").
Ele utiliza o motor de #get_term("js") V8, o que garante o desempenho para programas. Apesar de rodar em uma só @thread, o ciclo de processamento trata eventos assíncronas por meio de operações primitivas @node:2025:introduction.

=== Ambiente de desenvolvimento

O ambiente de desenvolvimento do projeto foi configurado utilizando o gerenciador de pacotes #get_term("pnpm")
#footnote[Acesso em: #link("https://pnpm.io/motivation").].
Ele instala e mantém atualizadas as ferramentas citadas e suas dependências por meio do registro de pacotes #get_term("npm")
#footnote[Acesso em: #link("https://www.npmjs.com/").].

A fim de evitar enganos de programação, utilizamos um superset do #get_term("js") chamado #get_term("ts"), que permite atribuir tipos estáticos e mais complexos a variáveis e funções.
Isso assegura a compatibilidade entre elas ainda em tempo de compilação @typescript:2026:for_javascript_programmers.

Outra ferramenta de inspeção de código-fonte utilizada é o #get_term("eslint") @eslint:2025:core_concepts e sua extensão typescript-eslint
#footnote[Acesso em: #link("https://typescript-eslint.io/").].
Esse programa é um @linter, que encontra e corrige problemas no código-fonte segundo os padrões e regras configurados.
Associamos essa ferramenta ao formatador automático de código-fonte #get_term("prettier")
#footnote[Acesso em: #link("https://prettier.io/").] com o fim de padronizar a disposição de importações e de atributos de classes, funções, objetos, e demais estruturas.

A fim de arquitetar o @apts como uma biblioteca modular, utilizamos o sistema de construção #get_term("turborepo")
#footnote[Acesso em: #link("https://turborepo.com/docs").].
Ele divide um repositório em pacotes, cada um com suas dependências.
Um pacote pode ter dependência em outro dentro do mesmo repositório, o que permite construir um sistema complexo, mas composto por partes simples.
De acordo com as relações inter-módulos, o #get_term("turborepo") gerencia a compilação e a execução do @linter de forma independente e faz cache dos resultados quando possível.

Finalmente, utilizamos a biblioteca de testes de unidade #get_term("vitest")
#footnote[Acesso em: #link("https://vitest.dev/guide/").].
Ela permite definir casos de teste e executá-los para entradas variadas, o que se provou útil sobretudo para garantir que as regras dos @jogo:pl modelados de fato levem às alterações esperadas nos @estado:pl.

=== Dependências externas

A construção do sistema requereu o uso de bibliotecas e demais pacotes externos instalados por meio do registro #get_term("npm").
A biblioteca de maior destaque é a implementação em #get_term("js")
#footnote[
  Acesso em: #link("https://www.tensorflow.org/js").
]
do projeto #get_term("tensorflow") @tensorflow:2015:whitepaper.
Ele foi desenvolvido pelo time de pesquisa da empresa Google e se propõe a facilitar a construção e o treinamento de modelos de @aprendizado_maquina.
Os autores deste trabalho selecionaram-no para construir dinamicamente @resnet:pl em #get_term("js"), ao passo em que o processamento efetivo do treinamento é descrito internamento pela linguagem C++.

Com o objetivo de tornar a execução do programa construído o mais determinística possível, os autores utilizaram a biblioteca `seedrandom`.
Isso foi necessário porque a função disponibilizada pela linguagem #get_term("js") para gerar números pseudo-aleatórios não permite ao desenvolvedor definir uma @seed.

Outro pacote utilizado foi o ts-graphviz
#footnote[
  Acesso em: #link("https://ts-graphviz.github.io/").
], que disponibiliza uma @api para o uso do programa #get_term("graphviz")
#footnote[
  Acesso em: #link("https://graphviz.org/").
], em conjunto com uma aplicação em #get_term("js").
Esse projeto descreve uma linguagem de representação de grafos e redes e oferece algoritmos que geram imagens a partir das descrições.
Os autores o utilizaram para exibir ao usuário as árvores de busca construídas ao executar o método de @mcts.

Finalmente, para elaborar a aplicação de linha de comando, os autores dispuseram da biblioteca #get_term("commander")
#footnote[
  Acesso em: #link("https://github.com/tj/commander.js").
], que facilita a definição de comandos e argumentos.
Ela gerencia o tratamento de dados recebidos do terminal e exibe mensagens de auxílio ao usuário sobre como preenchê-los.
Já para permitir ao usuário selecionar dentre opções de interface já dentro da execução de um comando, os autores escolheram a biblioteca #get_term("inquirer")
#footnote[
  Acesso em: #link("https://github.com/SBoudrias/Inquirer.js/").
].


== Métodos <section:metodos>

Os métodos dessa pesquisa e seus artefatos gerados são representados na @figure:metodos.
O primeiro requisito para executar a plataforma @apts é descrever por meio de classes concretas e suas consequentes instâncias todos os componentes fundamentais de um @jogo.
Então, esse poderá ser simulado por meio de @agint:pl que usam a @mcts clássica.

#describe_figure(
  // placement: auto,
  sticky: true,
  [#figure(
    caption: [Fluxograma dos métodos necessários e seus artefatos.],
    image(
      width: 80%,
      "../../assets/images/methods.png",
    ),
  )<figure:metodos>],
)

A fim de utilizar a @mcts adaptada pelo @alphazero, o usuário deve gerar, para aquele jogo, um modelo de @resnet que tenha @peso:pl e @vies:pl aleatórios.
Esse processo exporta a rede em arquivos que definem sua estrutura e seus @peso:pl e @vies:pl.
Então, esse modelo precisa passar por um processo de treinamento em ciclos.

A primeira etapa do ciclo é executar um algoritmo de @selfplay que usa a técnica de @mcts adaptada pelo @alphazero para direcionar a simulação de várias @partida:pl.
Nesse processo, é gerado um artefato que guarda dados relevantes da atuação dos @jogador:pl durante as @partida:pl.
Entre eles estão a sequências de @turno:pl, em que cada um guarda o @estado do @jogo, a expectativa dada pela @resnet da qualidade de cada @movimento possível e o @movimento que o @agint de fato tomou.
Além disso, para cada @partida, é salva @pontuacao final dos @jogador:pl, o que permite avaliar se a tomada de uma decisão em certo @estado levou a uma vitória ou não.

O passo seguinte do ciclo de treinamento é fornecer esse conjunto de dados para um algoritmo que utiliza a técnica de @aprendizado_maquina para reforçar as conexões da @rn que prevejam @movimento:pl mais adequados a um @estado fornecido.
Esse processo exporta como artefato o novo modelo de @resnet.
Então, essa rede treinada pode voltar ao primeiro passo do ciclo para gerar mais um conjunto de memórias, agora mais especializadas.

Após dispor de modelos de @resnet suficientemente treinados, o @apts deve permitir que seu usuário os utilize para orientar @agint:pl na simulação de @partida:pl.
Elas devem salvar os mesmos artefatos de registro de histórico, que podem ser usados para extrair dados relevantes sobre a atuação de cada @jogador.

Espera-se que esse processo seja capaz de levantar informações comuns à fase de @playtest, mas reduzindo a necessidade de testadores humanos.
Dessa forma, foi determinado como foco do experimento realizado nesta pesquisa: verificar se o processo de treinamento de modelos de @ia:long é capaz de gerar @agint:pl viáveis para realizar a etapa de @playtest na prototipagem de @jogo:pl.

Para tal, os autores representaram no sistema o @jogo #get_term("ligue4"), que é organizado em #glossarium.gls("jogo_turno", display: [turnos]) e apresenta informação completa.
Em seguida, geraram uma @resnet compatível com o @jogo, e a sujeitaram a $21$ ciclos de treinamento.
Dentre os modelos criados, os autores selecionaram o que apresentava as melhores métricas de acurácia e o utilizaram para orientar ambos os @jogador:pl.

Então, esses @agint:pl foram usados na simulação de $100$ @partida:pl, cujo histórico foi salvo da mesma forma como os artefatos utilizados no ciclo de treinamento. 
Por meio de um algoritmo, os autores extraíram informações de interesse dos históricos e as compilaram em um artefato final.
Esse descreve métricas acerca: (1) da duração das @partida:pl, medida em quantidade de @turno:pl; (2) da distribuição de @movimento:pl mais escolhidos por cada @jogador; e (3) da contagem de vitórias e derrotas de cada @jogador relacionada à duração da @partida.

A avaliação da solução proposta foi realizada de forma qualitativa por meio da análise e discussão sobre a capacidade de os artefatos gerados expressarem conclusões relevantes acerca do @jogo testado.
Além disso, também foi avaliada a capacidade do sistema de representar o #get_term("ligue4") e de gerar @agint:pl que o simulem.