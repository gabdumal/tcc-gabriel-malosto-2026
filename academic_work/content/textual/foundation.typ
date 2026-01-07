#import "/template/common/components/figure.typ": describe_figure
#import "/template/common/packages.typ": glossarium

= Fundamentação teórica <chapter:fundamentacao>

A fim de atingir os objetivos propostos, o presente trabalho investiga duas técnicas para a construção de @jogador:pl digitais autônomos para @jogo:pl de mesa, sendo elas a @mcts e as @resnet:pl, de acordo com os usos que o @az faz delas.
Este capítulo faz a revisão desses métodos, bem como elenca os trabalhos relacionados a uso de @agint:pl como ferramentas de @pt.

== #glossarium.Gls(long: true, "mcts") <sec:mcts>

O método de @mcts:long (@mcts:short) é um algoritmo de decisão em que cada nó de uma árvore representa dado @estado de um @jogo @kocsis:2006:bandit_based_mcts_planning@coulom:2006:efficient_selectivity_backup_operators.
Uma aresta entre um dado nó e outro representa um @movimento tomado por um @jogador, que conduz uma transição entre os @estado:pl representados.

O nó raiz da árvore representa o primeiro @turno, em que está disposto o @estado inicial do jogo.
O @jogador inicial escolhe um dentre todos os @movimento:pl disponíveis, segundo as regras do jogo.
Essa jogada leva à criação de um novo @estado, que é colocado no segundo nível da árvore.
Para o caso de um @jogo entre dois @jogador:pl, o segundo @jogador escolherá um dentre os @movimento:pl possíveis, o que levará novamente ao @turno do primeiro @jogador, posicionado no terceiro nível da árvore.

Os níveis irão alternadamente representar as jogadas de cada um dos @jogador:pl.
Essa estrutura possibilita ao algoritmo explorar o próximo @movimento realizado pelo oponente, a fim de prever a melhor ação futura @swiechowski:2022:monte_carlo_tree_search.

O processo de @mcts:long tem o objetivo de encontrar as melhores sequências de jogadas, que conduzam a uma vitória do @jogador.
Ele é formado por quatro etapas: seleção, expansão, simulação, e retro-propagação, as quais são representas na @figure:mcts_cycle.

#describe_figure(
  source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose").],
  sticky: true,
  [#figure(
    caption: [Ciclo da @mcts:long: suas quatro etapas são a seleção, a expansão, a simulação e a retro-propagação.],
    image(
      width: 80%,
      "../../assets/images/mcts_cycle.jpg",
    ),
  )<figure:mcts_cycle>],
)

A etapa de seleção procura, a partir do nó raiz, o melhor ramo a explorar, orientada por uma diretriz de busca.

A primeira diretriz definida e mais frequentemente utilizada nas implementações de referência é chamada \gls{ucb}~\cite{kocsis:2006:bandit_based_mcts_planning}, a qual atribui, a cada nó, contadores de visita e de vitória.
Com base nesses dados, ela calcula uma equação cujo resultado alinha exploração (\textit{exploration}) e aproveitamento (\textit{exploitation}) do espaço de busca.
A \autoref{eq:ucb_teorica} apresenta como escolher uma ação.
