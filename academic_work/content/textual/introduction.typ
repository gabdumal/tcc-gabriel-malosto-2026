#import "../../components/note.typ": note_from_gabriel
#import "/template/common/components/note.typ": progress_note, todo_note
#import "/template/common/util/text_in_english.typ": text_in_english

= Introdução <cap:introduction>

#progress_note[#note_from_gabriel[Definir jogos de turno]]

Jogos são definidos como atividades com propósito bem definido, o qual comumente é vencer um desafio.
Um jogador apenas pode ser considerado vitorioso caso ele atinja o objetivo segundo condições pré-estabelecidas, definidas como as regras do jogo.
Tais regras permitem diferentes estratégias, as quais podem ser consideradas melhores ou piores para obter a vitória, de acordo com o contexto da partida @suits:1967:what_is_a_game.

Dentre as categorias existentes, destacam-se os jogos de turnos, em que o tempo ocorre em unidades discretas.
Essas são chamadas de turnos, nos quais os jogadores realizam um número finito de ações que resultam em mudanças no estado do jogo.
Comumente, os turnos se alternam de forma pré-estabelecida, ao que se denomina rodada.
Nessa classe de jogos, as rodadas se sucedem até que a partida chegue a um estado final.
Uma característica marcante deles é a possibilidade representar a tomada de decisão dos jogadores durante uma partida por meio de árvores de decisão.
Essas estruturas permitem formalizar em um grafo as ações possíveis, definidas pelas regras, e os estados resultantes daquelas @salen:2003:rules_of_play[p. 410].

#progress_note[#note_from_gabriel[Escrever sobre o mercado de jogos]]

O mercado dos jogos de tabuleiros modernos teve um marco com o lançamento de #emph[Colonizadores de Catan] @teuber:1995:catan, quando jogos contemporâneos se tornaram populares mundialmente a partir da Alemanha e criaram um novo movimento cultural.
Atualmente existem sites focados em catalogar esses jogos, sendo o maior o BoardGameGeek
#footnote[
  Acesso em: #link("https://boardgamegeek.com/wiki/page/Welcome_to_BoardGameGeek").
],
que registra mais de 140 mil itens entre jogos, suas reimplementações e suas subsequentes expansões.

Ums grande parcela desses jogos se destaca pelo seu perfil tático ou estratégico durante as partidas, com uma série de reações em cadeia oriundas das ações escolhidas pelas decisões dos jogadores e diversas dinâmicas sociais e complexidade emergente.
Estes jogos são também conhecidos como #text_in_english[designer's games], ou jogos autorais, por trazerem o nome do autor na capa.
Eles são fruto de uma organização de criadores que proporciona uma série de benefícios para um mercado baseado em novidades @woods:2012:eurogame_design_culture_play.
Anualmente, entre 500 e 600 novos jogos são apresentados nas maiores convenções do meio, além de reimpressões e reedições @boardgamegeek:2022:spiel22_preview.

#progress_note[#note_from_gabriel[Escrever sobre @pt]]

O processo de criação de um jogo é iterativo.
O criador implementa a sua ideia em um protótipo, de preferência de baixo custo para facilitar as modificações necessárias.
Assim que o autor julga que esse protótipo do jogo está pronto, ele deve ser testado, ao que se denomina a fase de @pt.
Esta é a etapa na qual se realizam partidas para explorar o comportamento dos sistemas e encontrar possíveis desequilíbrios @marcelo:2009:design_de_jogos@fullerton:2019:game_design_workshop.

Deve-se ressaltar que desenvolvimento de um jogo autoral é um processo complexo e custoso, sobretudo durante a fase de @pt.
Não é incomum o autor realizar os testes sozinho, simulando vários jogadores.
Mas algumas dinâmicas e mecanismos não funcionam dessa forma e é necessário convidar outras pessoas para auxiliá-lo.
Adicionalmente, são feitos testes de estresse para diversos sistemas do jogo.
Entre eles, podemos citar a realizar a mesma ação durante quase toda a partida, caso aparente ser muito vantajosa.
Isso ajudar a  verificar se ela consegue sobrepujar todas as demais @marcelo:2009:design_de_jogos.

A busca pelo balanceamento em jogos apresenta um desafio grande para a indústria, pois o próprio termo não é consenso @becker:2020:what_is_game_balancing.
Tal processo é altamente dependente de contexto, com desdobramentos para equilíbrio matemático, progressão de dificuldade, progressão de conteúdo, variedade de estratégias e imparcialidade entre jogadores.
Cada um desses grupos apresenta suas próprias características, constituindo subsistemas altamente inter-relacionados de um sistema complexo maior, que é o jogo @romero:2021:game_balance.

Esta etapa de @pt, na qual partidas do jogo são performadas repetidamente, tem alto custo de recursos humanos.
É difícil manter o grupo de teste ativo e focado, dado que se trata de um processo exaustivo e cujo objetivo nem sempre é claro para os jogadores @trzewiczek:2017:i_play_tested_it_100_times.

Ademais, as ações dos próprios testadores podem influenciar os resultados dos testes com suas expectativas, humores, excessos ou falta de concentração.
Esses são pontos importantes a se observar em um teste @marcelo:2009:design_de_jogos, mas não são relevantes quando os objetivos são equilíbrios ou testes de estresse, nos quais as ações executadas devem ser puramente efetivas e alheias ao divertimento e emoções dos jogadores ou do grupo.

#progress_note[#note_from_gabriel[Escrever sobre estudos sobre jogos]]

O estudo de jogos de mesa por meios computacionais segue a própria história da Computação, em que pioneiros buscaram construir máquinas, modelos e algoritmos para jogar xadrez em um nível avançado @silver:2018:general_reinforcement_learning_algorithm.
Tradicionalmente, jogos de tabuleiro são descritos por estados discretos e tidos como jogos combinatoriais.
A área foi conduzida pelo estudo da busca eficiente em árvores de decisão via variações do algoritmo minimax e poda em árvore alfa-beta nas últimas duas décadas.

Os estudos continuaram com as heurísticas especializadas até que os resultados da @mcts:long (@mcts:short) na implementação de algoritmos de decisão se mostraram positivos @kocsis:2006:bandit_based_mcts_planning.
Seu uso não requeria qualquer outro conhecimento prévio além das regras do jogo e apresentava um bom desempenho sem necessitar que se implementasse uma heurística especializada.

Já o @az se destacou por substituir a necessidade de adaptar conhecimento de domínio de um jogo específico pelo uso de uma @resnet:long (@resnet:short), atuando como um algoritmo de aprendizagem profunda independente @silver:2016:mastering_game_go.
Essa estratégia permitiu realizar buscas eficientes na árvore de decisão através de um modelo treinado por aprendizado profundo.
Ela teve várias aplicações em jogos diferentes, como o Shogi e Go, que apresentavam complexidade superior ao xadrez.
Assim, ao considerar o aprendizado não informado resultante das repetidas partidas simuladas, percebe-se que essas tecnologias são promissoras para aprimorar jogos de mesa em desenvolvimento, observando desde a avaliação do estado do jogo, bem como a massa de dados gerada ao final do treinamento.

#progress_note[#note_from_gabriel[Escrever sobre a contribuição]]

Dado este contexto, o presente trabalho apresenta os primeiros passos de uma pesquisa exploratória para investigar relações de balanceamento em jogos durante sua criação.
A nível específico, é proposto um ambiente de @pt simulado para auxiliar as pessoas autoras de jogos a realizar as primeiras iterações do processo de teste.
#todo_note[#note_from_gabriel(margin: true)[Possivelmente alterar a contribuição, para reduzir o escopo]]

O objetivo dessas etapas compreende testes de estresse e equilíbrio matemático, de forma a eliminar a necessidade de testadores humanos além do autor.
Assim, espera-se que a participação de pessoas seja empregada para investigar aspectos lúdicos, sociais e a experiência do jogador, ao passo em que os testes repetitivos serão realizados majoritariamente por @intag:pl.

A fim de construir o ambiente proposto, é necessário estudar a representação de jogos de turnos em ambiente computacional.
Identifica-se o foco em estudar a modelagem de estruturas de dados capazes de organizar informações sobre diferentes conceitos, como: jogo, partida, rodada, turno, jogador, movimento e estado.
Além disso, é necessário estudar a implementação de algoritmos de busca e de aprendizado por reforço, a fim de simular partidas e avaliar o estado do jogo.
Etapas relevantes desse processo incluem a geração de massa de dados sobre as partidas simuladas, a avaliação dos estados do jogo segundo métricas de balanceamento e a comparação entre agentes treinados em diferentes condições.
#todo_note[#note_from_gabriel(margin: true)[Possivelmente alterar a avaliação, para reduzir o escopo]]
Tem-se o foco sobre os métodos de @ia, @mcts e @resnet, que se mostram promissores para orientar agentes inteligentes em partidas simuladas de jogos de tabuleiro.

#progress_note[#note_from_gabriel[Escrever sobre a estrutura]]

O presente trabalho está organizado em seis capítulos.
Este #ref(<cap:introduction>), de Introdução, apresenta o tema geral e a situação de mercado, delimita o problema de pesquisa e descreve a contribuição esperada.
O #ref(<cap:foundation>), de Fundamentação Teórica, aborda conceitos fundamentais para a pesquisa segundo a literatura, apresentando estudos que abordam o tema proposto ou correlatos, a fim de situar o presente trabalho no contexto da pesquisa.
Por sua vez, o #ref(<cap:method>), de Material e Métodos, descreve a metodologia de pesquisa e desenvolvimento da solução proposta.
Segue o @cap:results, de Resultados, que apresenta os resultados esperados e a análise dos dados coletados.
Por fim, o @cap:conclusion, de Considerações Finais, apresenta comentários acerca da pesquisa, suas limitações e as perspectivas para trabalhos futuros.
