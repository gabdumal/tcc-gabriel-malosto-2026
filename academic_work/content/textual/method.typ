#import "../../components/note.typ": note_from_gabriel
#import "/template/common/components.typ": progress_note, todo_note
#import "/template/packages.typ": glossarium

= Material e métodos <chapter:metodos>

#progress_note(note_from_gabriel[Deve categorizar o tipo de pesquisa])

O presente trabalho se classifica como uma pesquisa exploratória acerca do uso de @agint:pl para realizar a fase de @playtest em @jogo_tabuleiro:pl.
Seus focos são estudar os métodos de #glossarium.gls(long: true, "mcts") e de #glossarium.gls(long: true, plural: true, "resnet") conforme aplicados pelo projeto @alphazero.

#progress_note(note_from_gabriel[Deve descrever a lista de materiais tilizados
])

Os autores desenvolveram uma aplicação de linha de comando capaz de representar @jogo:pl discretos e gerar @agint:pl que simulem @partida:pl conforme o método de @selfplay @malosto:2026:apts.
As simulações devem coletar dados sobre as @partida:pl para prover ao projetista do @jogo informações estatísticas usadas para orientar testes de estresse e de balanceamento, que focam em aspectos técnicos em vez de tratar da experiência do @jogador.

A construção dos modelos se dá conforme o ciclo demonstrado na @figure:treinamento, de forma que primeiramente o sistema gera um @agint cuja @resnet tenha @peso:pl e @vies:pl aleatórios.
Esse agente usa a técnica de @mcts para direcionar a simulação de @partida:pl e gerar um histórico das jogadas.
Esse conjunto de dados é utilizado numa técnica de @aprendizado_maquina para reforçar as conexões da @rn que prevejam @movimento:pl mais adequados a um @estado fornecido.
Após o alinhamento, o @agint pode ser aprimorado ao voltar ao primeiro passo do ciclo e gerar mais uma memória de treinamento.

#todo_note(note_from_gabriel[Deve descrever a forma de avaliação])

A avaliação da solução proposta foi realizada de forma qualitativa por meio da comparação entre a atuação de diferentes @agint:pl em jogos clássicos e de informação completa, como o @jogo_velha e o @ligue4.
Cada agente foi preparado com variação na quantidade de épocas de treinamento.
O foco do experimento é verificar se o processo de treinamento de modelos de @ia:long é capaz de gerar @agint:pl viáveis para realizar a etapa de @playtest na prototipagem de @jogo:pl, o que visa a reduzir o uso de recursos humanos.
