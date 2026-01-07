#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": glossarium
#import "/template/common/util/text_in_english.typ": text_in_english

== Modelo #glossarium.gls("alphazero") <section:alphazero>

Dentro da categoria de @jogo:pl de estratégia baseados em @turno:pl, destaca-se o Go, originado na China.
Ele é jogado por duas pessoas, sendo composto por um tabuleiro de 19 linhas verticais e horizontais, 180 peças brancas e 180 peças pretas.
Uma @partida se inicia com o tabuleiro vazio.
Em cada @turno, os @jogador:pl se alternam colocando uma de suas peças nas intersecções das linhas horizontais e verticais.

Qualquer intersecção não ocupada é válida para colocação das peças, que então não podem ser movidas.
O objetivo é cercar totalmente as peças adversárias pois, quando um grupo dessas é totalmente cercado, elas são removidas do tabuleiro.
O outro @jogador tenta evitar a captura ao posicionar peças em interseções não dominadas pelo oponente.
Vence o @jogador que, ao se esgotarem todos os @movimento:pl, tiver a maior quantidade de peças no tabuleiro @britannica:2023:go.

A fim de desenvolver um @jogador autônomo para o Go a nível competitivo, o laboratório DeepMind, braço de pesquisa em @ia da Google, desenvolveu o método de construção de modelos de @rn:pl chamado de #text_in_english[AlphaGo].
Essa versão gerava dados para treinar o modelo ao colocá-lo para jogar contra @jogador:pl humanos.

Foi então desenvolvida sua evolução, chamada de #text_in_english[AlphaGo Zero], que acumula dados de treinamento jogando contra si mesma, no que se define como @selfplay (#glossarium.gls-custom("selfplay")).
Um novo modelo construído é iniciado com @peso:pl (#glossarium.gls-custom("peso")) e @vies:pl (#glossarium.gls-custom("vies")) aleatórios, o que leva a @movimento:pl arbitrários.
Ainda assim, a massa de dados gerada permite identificar quais estados levaram a melhores @avaliacao:pl de qualidade @silver:2016:mastering_game_go.

Dessa forma, por meio de treinamentos e geração de dados sucessivos, o modelo tende a alcançar desempenho excepcional.
Esse processo de lapidação dos @peso:pl e @vies:pl por meio de @selfplay é compreendido como um método de aprendizado por reforço @silver:2017:mastering_chess_shogi.

O método foi então generalizado para permitir a criação de modelos capazes de aprender qualquer @jogo de tabuleiro dadas apenas as suas regras, ao que se denominou @alphazero.
Os principais destaques foram os @jogo:pl Go, Shogi e Xadrez @silver:2018:general_reinforcement_learning_algorithm.

Para tanto, a @mcts é associada a uma @resnet.
O método @alphazero utiliza uma adaptação deste conceito, ao representar o estado do jogo similarmente a uma imagem de três canais de cor.

#todo_note(note_from_gabriel[Colocar aqui as imagens de representação do tabuleiro])

A utilização do modelo requer como entrada um dado @estado do tabuleiro.
A @rn processa a entrada e retorna como saída dois valores: (1) um vetor que representa a qualidade atribuída a cada um dos @movimento:pl válidos naquele @estado; e (2) um escalar que representa a qualidade do resultado estimado para aquela @partida, sendo maior para uma expectativa de vitória e menor para uma de derrota.
