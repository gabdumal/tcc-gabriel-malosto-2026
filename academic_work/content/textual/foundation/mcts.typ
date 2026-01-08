#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/equation.typ": equation
#import "/template/common/components/figure.typ": describe_figure
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": glossarium

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
Ele é formado por quatro etapas: seleção, expansão, simulação, e retro-propagação, as quais são representas na @figure:ciclo_mcts.

#describe_figure(
  placement: auto,
  source: [Adaptado de #cite(<swiechowski:2022:monte_carlo_tree_search>, form: "prose").],
  sticky: true,
  [#figure(
    caption: [Ciclo da @mcts:long: suas quatro etapas são a seleção, a expansão, a simulação e a retro-propagação.],
    image(
      width: 80%,
      "/academic_work/assets/images/mcts_cycle.png",
    ),
  )<figure:ciclo_mcts>],
)

A etapa de seleção procura, a partir do nó raiz, o ramo com o melhor nó folha a explorar, orientada por uma diretriz de busca.
A mais frequentemente utilizada nas implementações de referência é chamada de @uct @kocsis:2006:bandit_based_mcts_planning.
Essa política atribui contadores de visita e de vitória a cada nó.
Com base nesses dados, ela calcula uma equação cujo resultado alinha @exploration (#glossarium.gls-custom("exploration")) e @exploitation (#glossarium.gls-custom("exploitation")) do espaço de busca.
A @eq:ucb_teorica apresenta como escolher uma ação.

#equation(width: 80%)[
  $ a^* = max_(a in A(s)) (Q(s, a) + C sqrt((ln[N(s)])/(N(s,a)))) $ <eq:ucb_teorica>

  Na qual:
  - $a^*$ é a ação ótima selecionada;
  - $A(s)$ é o conjunto de ações disponíveis dado o estado $s$;
  - $Q(s,a)$ é o resultado médio calculado jogando a ação $a$ no estado $s$, simulado até o momento;
  - $N(s)$ é o número de vezes em que o estado $s$ foi visitado nas iterações anteriores;
  - $N(s,a)$ é o número de vezes que a ação $a$ foi amostrada no estado $s$;
  - $C$ é o coeficiente que regula a relação entre @exploration e @exploitation.
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
Dispondo do vetor de probabilidades, o método da seleção aleatória por roleta escolhe um dos @movimento:pl.

#describe_figure(
  placement: auto,
  sticky: true,
  note: [Neste exemplo, o cálculo das probabilidades dos três @movimento:pl válidos a partir do @estado inicial utilizou apenas a quantidade de visitas a cada um dos ramos iniciados pelo respectivo movimento.],
  [#figure(
    caption: [Uso da @mcts para calcular as probabilidades de jogar cada um dos @movimento:pl válidos a partir de um @estado inicial.],
    image(
      width: 50%,
      "/academic_work/assets/images/mcts_probabilities.png",
    ),
  )<figure:probabilidades_mcts>],
)

#todo_note(
  note_from_gabriel[Deve-se descrever nos resultados as experiências de utilizar diferentes funções de cálculo de probabilidade. Por exemplo, uma função que usa apenas a quantidade de visitas tende a ser boa na exploração da árvore, mas ela tende a nunca selecionar estados próximos do estado terminal, uma vez que não se pode visitar um estado terminal mais de uma vez],
)

A descrição do método de @mcts permite concluir que apresenta boas soluções para problemas nos quais o espaço de busca não pode ser percorrido completamente em tempo hábil.
Isso se dá porque a política de seleção (@uct) privilegia os ramos com maior relevância e deixa de gastar recursos explorando aqueles que não tendem a gerar dados relevantes.
O método também diminui a necessidade de uma heurística prévia sobre o domínio para operar, embora existam trabalhos que buscam defini-la para melhora o desempenho.
