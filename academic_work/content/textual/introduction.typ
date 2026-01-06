= Introdução

Jogos são definidos como atividades com propósito bem definido, o qual comumente é vencer um desafio.
Um jogador apenas pode ser considerado vitorioso caso ele atinja o objetivo segundo condições pré-estabelecidas, definidas como as regras do jogo.
Tais regras permitem diferentes estratégias, as quais podem ser consideradas melhores ou piores para obter a vitória, de acordo com o contexto da partida @suits:1967:what_is_a_game.

Dentre as categorias existentes, destacam-se os jogos de turnos, em que o tempo ocorre em unidades discretas.
Essas são chamadas de turnos, nos quais os jogadores realizam um número finito de ações que resultam em mudanças no estado do jogo.
Comumente, os turnos se alternam de forma pré-estabelecida, ao que se denomina rodada.
Nessa classe de jogos, as rodadas se sucedem até que a partida chegue a um estado final.
Uma característica marcante deles é a possibilidade representar a tomada de decisão dos jogadores durante uma partida por meio de árvores de decisão.
Essas estruturas permitem formalizar em um grafo as ações possíveis, definidas pelas regras, e os estados resultantes daquelas @salen:2003:rules_of_play[p. 410].

O mercado dos jogos de tabuleiros modernos teve um marco com o lançamento de Colonizadores de Catan~\cite{teuber:1995:catan}, quando jogos contemporâneos se tornaram populares mundialmente a partir da Alemanha e criaram um novo movimento cultural.
Atualmente existem sites focados em catalogar esses jogos, sendo o maior o BoardGameGeek\footnote{Acesso em: \url{https://boardgamegeek.com/wiki/page/Welcome_to_BoardGameGeek}.}, que registra mais de 140 mil itens entre jogos, suas reimplementações e suas subsequentes expansões.

Um grande parcela desses jogos se destacam pelo seu perfil tático ou estratégico durante as partidas, com uma série de reações em cadeia oriundas das ações escolhidas pelas decisões dos jogadores e diversas dinâmicas sociais e complexidade emergente.
Estes jogos são também conhecidos como \textit{designer's games}, ou jogos autorais, por trazerem o nome do autor na capa.
Eles são fruto de uma organização de criadores que proporciona uma série de benefícios para um mercado baseado em novidades~\cite{woods:2012:eurogame_design_culture_play}.
Anualmente, entre 500 e 600 novos jogos são apresentados nas maiores convenções do meio, além de reimpressões e reedições~\cite{boardgamegeek:2022:spiel22_preview}.

O processo de criação de um jogo é iterativo.
O criador implementa a sua ideia em um protótipo, de preferência de baixo custo para facilitar as modificações necessárias.
Assim que o autor julga que esse protótipo do jogo está pronto, ele deve ser testado, ao que se denomina a fase de \gls{pt}.
Esta é a etapa na qual se realizam partidas para explorar o comportamento dos sistemas e encontrar possíveis desequilíbrios~\cite{marcelo:2009:design_de_jogos, fullerton:2019:game_design_workshop}.

Deve-se ressaltar que desenvolvimento de um jogo autoral é um processo complexo e custoso, sobretudo durante a fase de \gls{pt}.
Não é incomum o autor realizar os testes sozinho, simulando vários jogadores.
Mas algumas dinâmicas e mecanismos não funcionam dessa forma e é necessário convidar outras pessoas para auxiliá-lo.
Adicionalmente, são feitos testes de estresse para diversos sistemas do jogo.
Entre eles, podemos citar a realizar a mesma ação durante quase toda a partida, caso aparente ser muito vantajosa.
Isso ajudar a  verificar se ela consegue sobrepujar todas as demais~\cite{marcelo:2009:design_de_jogos}.

A busca pelo balanceamento em jogos apresenta um desafio grande para a indústria, pois o próprio termo não é consenso~\cite{becker:2020:what_is_game_balancing}.
Tal processo é altamente dependente de contexto, com desdobramentos para equilíbrio matemático, progressão de dificuldade, progressão de conteúdo, variedade de estratégias e imparcialidade entre jogadores.
Cada um desses grupos apresenta suas próprias características, constituindo subsistemas altamente inter-relacionados de um sistema complexo maior, que é o jogo~\cite{romero:2021:game_balance}.

Esta etapa de \gls{pt}, na qual partidas do jogo são performadas repetidamente, tem alto custo de recursos humanos.
É difícil manter o grupo de teste ativo e focado, dado que se trata de um processo exaustivo e cujo objetivo nem sempre é claro para os jogadores~\cite{trzewiczek:2017:i_play_tested_it_100_times}.

Ademais, as ações dos próprios testadores podem influenciar os resultados dos testes com suas expectativas, humores, excessos ou falta de concentração.
Esses são pontos importantes a se observar em um teste~\cite{marcelo:2009:design_de_jogos}, mas não são relevantes quando os objetivos são equilíbrios ou testes de estresse, nos quais as ações executadas devem ser puramente efetivas e alheias ao divertimento e emoções dos jogadores ou do grupo.
