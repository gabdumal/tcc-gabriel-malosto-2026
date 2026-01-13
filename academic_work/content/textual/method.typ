#import "../../components/note.typ": note_from_gabriel, note_from_igor
#import "/template/common/components.typ": done_note, progress_note, todo_note
#import "/template/packages.typ": glossarium

= Material e métodos <chapter:metodos>

#progress_note(note_from_gabriel[Deve categorizar o tipo de pesquisa])

O presente trabalho se classifica como uma pesquisa de natureza aplicada acerca do uso de @agint:pl para realizar a fase de @playtest em @jogo_tabuleiro:pl.
Ele busca, através de uma abordagem qualitativa, aplicar os métodos de #glossarium.gls(long: true, "mcts") e de #glossarium.gls(long: true, plural: true, "resnet") conforme o @alphazero para gerar dados de apoio ao balanceamento para o desenvolvedor de jogos. A pesquisa também é exploratória, pois permitirá aumentar familiaridade acerca da modelagem de jogos e seus mecanismos com os métodos de aprendizagem profunda para uso como ferramentas de projeto.


== Material <section:material>

Foi desenvolvida neste trabalho a aplicação de linha de comando *APTS*, capaz de representar @jogo:pl discretos e gerar @agint:pl que simulem @partida:pl conforme o método de @selfplay @malosto:2026:apts.
As simulações coletam dados sobre as @partida:pl para prover ao projetista do @jogo informações estatísticas usadas para orientar testes de estresse e de balanceamento, que focam em aspectos técnicos em vez de tratar da experiência do @jogador.


#todo_note(
  note_from_igor[Deixe claro o que você usou do ponto de vista de tecnologia e ferramental. Quais linguagens, bibliotecas, ambiente de desenvolvimento e execução, como os dados e foram gerados e quais artefatos são utilizados e produzidos. Use o nome da aplicação! ],
)


O APTS é desenvolvido em TypeScript XX, com as bibliotecas de X, Y e Z para ... . O núcleo que realizar a simulação dos métodos MCTS e Alfazero foram desenvolvidos complemtamente pelo autor, enquanto as redes usam @tensorflow_js ...

== Métodos <section:metodo>

#done_note(
  note_from_igor[Não citar uma figura de outro capitulo. Se for ilustrar aqui, melhor fazer um diagrama de blocos com as entradas e saídas de cada módulo do projeto e seus artefatos de entrada e saída. Mas só se tiver tempo, tem coisa mais importante para resolver antes ],
)

A construção dos modelos é feita em ciclos, em que o primeiro passo do sistema é gerar um @agint cuja @resnet tenha @peso:pl e @vies:pl aleatórios.
Esse agente usa a técnica de @mcts para direcionar a simulação de @partida:pl e gerar um histórico das jogadas.
Esse conjunto de dados é utilizado numa técnica de @aprendizado_maquina para reforçar as conexões da @rn que prevejam @movimento:pl mais adequados a um @estado fornecido.
Após o alinhamento, o @agint pode ser aprimorado ao voltar ao primeiro passo do ciclo e gerar mais uma memória de treinamento.

#todo_note(note_from_gabriel[Deve descrever a forma de avaliação])

A avaliação da solução proposta foi realizada de forma qualitativa por meio da comparação entre a atuação de diferentes @agint:pl no jogo clássico e de informação completa @ligue4.
Cada agente foi preparado com variação na quantidade de épocas de treinamento.
O foco do experimento é verificar se o processo de treinamento de modelos de @ia:long é capaz de gerar @agint:pl viáveis para realizar a etapa de @playtest na prototipagem de @jogo:pl, o que visa a reduzir o uso de recursos humanos.
