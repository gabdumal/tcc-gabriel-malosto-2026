#import "../../components/note.typ": note_from_gabriel, note_from_igor
#import "/template/common/components.typ": done_note, progress_note, todo_note
#import "/template/packages.typ": glossarium

= Material e métodos <chapter:metodos>

#progress_note(note_from_gabriel[Deve categorizar o tipo de pesquisa])

O presente trabalho se classifica como uma pesquisa de natureza aplicada acerca do uso de @agint:pl para realizar a fase de @playtest em @jogo_tabuleiro:pl.
Ela busca, através de uma abordagem qualitativa, aplicar os métodos de #glossarium.gls(long: true, "mcts") e de #glossarium.gls(long: true, plural: true, "resnet") conforme o @alphazero para gerar dados de apoio ao balanceamento para o desenvolvedor de jogos. A pesquisa também é exploratória, pois permitirá aumentar familiaridade acerca da modelagem de jogos e seus mecanismos com os métodos de aprendizagem profunda para uso como ferramentas de projeto.


== Material <section:material>

Foi desenvolvida neste trabalho a aplicação de linha de comando chamada *@apts*, capaz de representar @jogo:pl discretos e gerar @agint:pl que simulem @partida:pl conforme o método de @selfplay @malosto:2026:apts.
As simulações coletam dados sobre as @partida:pl para prover ao projetista do @jogo informações estatísticas usadas para orientar testes de estresse e de balanceamento, que focam em aspectos técnicos em vez de tratar da experiência do @jogador.

=== Ambiente de execução

Os autores têm a expectativa de que o @apts possa ser acessado por meio de programas navegadores da internet, dispondo de uma interface de usuário satisfatória para usuários não familiarizados com programação.
Entretanto, concluiu-se que seria vantajoso desenvolver scripts de teste de software para verificar sua qualidade durante as versões iniciais de desenvolvimento.
Por isso, estabeleceu-se como requisito que o sistema funcionasse como uma biblioteca, de forma que possa ser utilizado tanto por um programa de linha de comando, como também por uma página da web.

Com essa perspectiva, escolhemos escrever o código-fonte do sistema na linguagem de programação @js.
Essa é utilizada comumente para o desenvolvimento de páginas da web, tendo suporte oferecido pelos principais navegadores, como comprovado pelo suporte fornecido pela empresa #cite(form: "prose", <aws:2020:supported_browsers>) ao seu @sdk para @js.

Essa linguagem também pode ser utilizada em um ambiente de execução de linha de comando, sendo o mais comum o @node.
Ele utiliza o motor de @js V8, o que garante o desempenho para programas. Apesar de rodar em uma só @thread, o ciclo de processamento trata eventos assíncronas por meio de operações primitivas @node:2025:introduction.

=== Ambiente de desenvolvimento

O ambiente de desenvolvimento do projeto foi configurado utilizando o gerenciador de pacotes @pnpm
#footnote[Acesso em: #link("https://pnpm.io/motivation").].
Ele instala e mantém atualizadas as ferramentas citadas e suas dependências por meio do registro de pacotes @npm
#footnote[Acesso em: #link("https://www.npmjs.com/").].

A fim de evitar enganos de programação, utilizamos um superset do @js chamado @ts, que permite atribuir tipos estáticos e mais complexos a variáveis e funções.
Isso assegura a compatibilidade entre elas ainda em tempo de compilação @typescript:2026:for_javascript_programmers.

Outra ferramenta de inspeção de código-fonte utilizada é o @eslint @eslint:2025:core_concepts e sua extensão typescript-eslint
#footnote[Acesso em: #link("https://typescript-eslint.io/").].
Esse programa é um @linter, que encontra e corrige problemas no código-fonte segundo os padrões e regras configurados.
Associamos-no ao formatador automático @prettier
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

=== Dependências externas

A construção do sistema requereu o uso de bibliotecas e demais pacotes externos instalados por meio do registro @npm.
A biblioteca de maior destaque é a implementação em @js
#footnote[
  Acesso em: #link("https://www.tensorflow.org/js").
]
do projeto @tensorflow @tensorflow:2015:whitepaper.
Ele foi desenvolvido pelo time de pesquisa da empresa Google e se propõe a facilitar a construção e o treinamento de modelos de @aprendizado_maquina.
Os autores deste trabalho selecionaram-no para construir dinamicamente @resnet:pl em @js, ao passo em que o processamento efetivo do treinamento é descrito internamento pela linguagem C++.

Com o objetivo de tornar a execução do programa construído o mais determinística possível, os autores utilizaram a biblioteca `seedrandom`.
Isso foi necessário porque a função disponibilizada pela linguagem @js para gerar números pseudo-aleatórios não permite ao desenvolvedor definir uma @seed.

Outro pacote utilizado foi o ts-graphviz
#footnote[
  Acesso em: #link("https://ts-graphviz.github.io/").
], que disponibiliza uma @api para o uso do programa Graphviz
#footnote[
  Acesso em: #link("https://graphviz.org/").
], em conjunto com uma aplicação em @js.
Esse projeto descreve uma linguagem de representação de grafos e redes e oferece algoritmos que geram imagens a partir das descrições.
Os autores utilizaram-no para exibir para o usuário as árvores de busca construídas ao executar o método de @mcts.

Finalmente, para elaborar a aplicação de linha de comando, os autores dispuseram da biblioteca Commander.js
#footnote[
  Acesso em: #link("https://github.com/tj/commander.js").
], que facilita a definição de comandos e argumentos.
Ela gerencia o tratamento de dados recebidos do terminal e exibe mensagens de auxílio ao usuário sobre como preenchê-los.
Já para permitir ao usuário selecionar dentre opções de interface já dentro da execução de um comando, os autores escolheram a biblioteca Inquirer.js
#footnote[
  Acesso em: #link("https://github.com/SBoudrias/Inquirer.js/").
].


== Métodos <section:metodos>

#todo_note(
  note_from_igor[Descreva como os dados e foram gerados e quais artefatos são utilizados e produzidos.],
)

A construção dos modelos é feita em ciclos, em que o primeiro passo do sistema é gerar um @agint cuja @resnet tenha @peso:pl e @vies:pl aleatórios.
Esse agente usa a técnica de @mcts para direcionar a simulação de @partida:pl e gerar um histórico das jogadas.
Esse conjunto de dados é utilizado numa técnica de @aprendizado_maquina para reforçar as conexões da @rn que prevejam @movimento:pl mais adequados a um @estado fornecido.
Após o alinhamento, o @agint pode ser aprimorado ao voltar ao primeiro passo do ciclo e gerar mais uma memória de treinamento.

#todo_note(note_from_gabriel[Deve descrever a forma de avaliação])

A avaliação da solução proposta foi realizada de forma qualitativa por meio da comparação entre a atuação de diferentes @agint:pl no jogo clássico e de informação completa @ligue4.
Cada agente foi preparado com variação na quantidade de épocas de treinamento.
O foco do experimento é verificar se o processo de treinamento de modelos de @ia:long é capaz de gerar @agint:pl viáveis para realizar a etapa de @playtest na prototipagem de @jogo:pl, o que visa a reduzir o uso de recursos humanos.
