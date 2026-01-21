#import "../../components.typ": note_from_gabriel, note_from_igor
#import "/template/common/components.typ": done_note, progress_note, todo_note
#import "/template/common/util.typ": text_in_english
#import "/template/packages.typ": glossarium

= Introdução <chapter:introducao>

// #progress_note[#note_from_gabriel[Definir @jogo:pl de turno]]

@Jogo:pl são conceituados como atividades com propósito bem definido, o qual comumente é vencer um desafio.
Um @jogador apenas pode ser considerado vitorioso caso ele atinja o objetivo segundo condições pré-estabelecidas, definidas como as regras do @jogo.
Tais regras permitem diferentes estratégias, as quais podem ser consideradas melhores ou piores para obter a vitória, de acordo com o contexto da @partida @suits:1967:what_is_a_game.

Dentre as categorias existentes, destacam-se os @jogo_turno:pl (#text_in_english[turn-based games]), em que o tempo de partida evolui em unidades discretas.
Essas são chamadas de @turno:pl, nos quais os @jogador:pl realizam um número finito de @movimento:pl que resultam em mudanças no @estado do @jogo.
Comumente, os @turno:pl se alternam de forma pré-estabelecida, ao que se denomina @rodada.
Nessa classe de @jogo:pl, as @rodada:pl se sucedem até que a @partida chegue a um @estado final o qual é avaliado com alguma métrica para decidir o sucesso ou fracasso dos jogadores dentro do desafio proposto.
Uma característica marcante deles é a possibilidade representar a tomada de decisão dos @jogador:pl durante uma @partida por meio de árvores de decisão.
Essas estruturas permitem formalizar em um grafo os @movimento:pl possíveis, definidos pelas regras, e os @estado:pl resultantes daquelas @salen:2003:rules_of_play[p. 410].

// #progress_note[#note_from_gabriel[Escrever sobre o mercado de @jogo:pl]]

O mercado dos @jogo_tabuleiro:pl (#glossarium.gls-custom("jogo_tabuleiro")) modernos teve um marco com o lançamento de #emph[Colonizadores de Catan] @teuber:1995:catan, quando @jogo:pl contemporâneos se tornaram populares mundialmente a partir da Alemanha e criaram um novo movimento cultural.
Atualmente existem sites focados em catalogar esses @jogo:pl, sendo o maior o BoardGameGeek
#footnote[
  Acesso em: #link("https://boardgamegeek.com/wiki/page/Welcome_to_BoardGameGeek").
],
que registra mais de 140 mil itens entre @jogo:pl, suas reimplementações e suas subsequentes expansões.

Uma grande parcela desses @jogo:pl se destaca pelo seu perfil tático ou estratégico durante as @partida:pl, com uma série de reações em cadeia oriundas dos @movimento:pl escolhidos pelas decisões dos @jogador:pl, ocasionando diversas dinâmicas sociais e complexidade emergente.
Estes @jogo:pl são também conhecidos como #text_in_english[designer's games], ou @jogo:pl autorais, por trazerem o nome do autor na capa.
Eles são fruto de uma organização de criadores que proporciona uma série de benefícios para um mercado baseado em novidades @woods:2012:eurogame_design_culture_play.
Anualmente, acima de 1000 novos @jogo:pl são apresentados nas maiores convenções do meio, além de reimpressões, reedições expansões de conteúdo e jogabilidade @boardgamegeek:2025:spiel25_preview.

// #progress_note[#note_from_gabriel[Escrever sobre @playtest]]

O processo de criação de um @jogo é um processo exaustivamente iterativo.
O criador implementa a sua ideia em um protótipo, normalmente de baixo custo para facilitar as contínuas modificações necessárias.
Assim que o autor julga que esse protótipo está pronto dentro da experiência de @jogo desejada, ele deve ser testado na que se denomina a fase de @playtest (#glossarium.gls-custom("playtest")).
Esta é a etapa na qual se realizam @partida:pl para explorar o comportamento dos sistemas e encontrar possíveis desequilíbrios @marcelo:2009:design_de_jogos@fullerton:2019:game_design_workshop.

Deve-se ressaltar que desenvolvimento de um @jogo autoral é um processo complexo e custoso, sobretudo durante a fase de @playtest.
Não é incomum o autor realizar os testes sozinho, simulando vários @jogador:pl.
Mas algumas dinâmicas e mecanismos não funcionam dessa forma e é necessário convidar outras pessoas para auxiliá-lo.
Adicionalmente, são feitos testes de estresse para diversos sistemas do @jogo.
Entre eles, podemos citar a realização da mesma ação durante quase toda a @partida, caso aparente ser muito vantajosa.
Isso ajudar a verificar se ela consegue sobrepujar todas as demais @marcelo:2009:design_de_jogos. Esta é a etapa do @playtest que é conhecida como balanceamento.

A busca pelo balanceamento em @jogo:pl apresenta um desafio grande para a indústria, pois o próprio termo não é consenso @becker:2020:what_is_game_balancing.
Tal processo é altamente dependente de contexto, com desdobramentos para equilíbrio matemático, progressão de dificuldade, progressão de conteúdo, variedade de estratégias e imparcialidade entre @jogador:pl.
Cada um desses grupos apresenta suas próprias características, constituindo subsistemas altamente inter-relacionados de um sistema complexo maior, que é o @jogo @romero:2021:game_balance.

Essa etapa, na qual @partida:pl do @jogo são performadas repetidamente, tem alto custo de recursos humanos e tempo.
É difícil manter um grupo de teste ativo e focado, dado que se trata de um processo cansativo --- quando o número de partidas começa a ficar alto --- e cujo objetivo nem sempre é claro para os @jogador:pl @trzewiczek:2017:i_play_tested_it_100_times.

Ademais, efeitos sobre os próprios testadores podem influenciar os resultados dos testes com suas expectativas, humores, excessos ou falta de concentração.
Esses são pontos importantes a se observar em um teste de experiência de jogo @marcelo:2009:design_de_jogos, mas não são relevantes quando os objetivos são equilíbrios durante testes de estresse, nos quais os @movimento:pl executados devem ser puramente efetivos e alheios ao divertimento e emoções dos @jogador:pl ou dinâmicas do grupo.

O estudo de @jogo:pl de mesa por meios computacionais segue a própria história da Computação, em que pioneiros buscaram construir máquinas, modelos e algoritmos para jogar xadrez em um nível avançado @silver:2018:general_reinforcement_learning_algorithm.
Tradicionalmente, @jogo_tabuleiro:pl são descritos por @estado:pl discretos e tidos como @jogo:pl combinatoriais.
A área foi conduzida pelo estudo da busca eficiente em árvores de decisão via variações do algoritmo minimax e poda em árvore alfa-beta nas últimas duas décadas @plaat:2017:minimax_alphabeta.

Os estudos continuaram com as heurísticas especializadas até que os resultados da @mcts:long (@mcts:short) na implementação de algoritmos de decisão se mostraram positivos @kocsis:2006:bandit_based_mcts_planning@holmgard:2019:automated_playtesting_procedural_personas.
Seu uso não requeria qualquer outro conhecimento prévio além das regras do @jogo e apresentava um bom desempenho sem necessitar que se implementasse uma heurística especializada.

Com base nela, o projeto @alphazero, do laboratório de pesquisa Google DeepMind, se destacou por substituir a necessidade de adaptar conhecimento de domínio de um @jogo específico pelo uso de uma @resnet:long (@resnet:short), atuando como um algoritmo de aprendizagem profunda independente @silver:2016:mastering_game_go.
Essa estratégia permitiu realizar buscas eficientes na árvore de decisão através de um modelo treinado por aprendizado profundo.
Esse método teve várias aplicações em @jogo:pl diferentes, como o Shogi e Go, que apresentavam complexidade superior ao xadrez.
Assim, ao considerar o aprendizado não informado resultante das repetidas @partida:pl simuladas, percebe-se que essas tecnologias são promissoras para aprimorar @jogo:pl de mesa em desenvolvimento, observando desde a avaliação do @estado do @jogo, bem como a massa de dados gerada ao final do treinamento.

// #done_note[#note_from_gabriel[Destacar objetivos gerais e específicos]]

Dado este contexto, o presente trabalho continua uma pesquisa exploratória para investigar relações de balanceamento em @jogo:pl durante sua criação @araki:2020:testes_de_software@malosto:2023:alphazero_como_ferramenta_de_playtest@malosto:2025:moving_towards.
Seu objetivo geral é oferecer perspectivas e ferramentas inovadoras ao cenário de criação de @jogo_turno:pl, estabelecendo como foco a fase de @playtest.

Os autores estabelecem como hipótese que é viável construir sistemas computacionais para a execução de @partida:pl sintéticas que ofereçam dados relevantes aos projetistas de @jogo:pl, de forma a reduzir o emprego de recursos humanos nessa fase. 
Assim, espera-se que a participação de pessoas seja empregada para investigar aspectos lúdicos, sociais e a experiência do jogador, ao passo em que os testes repetitivos sejam realizados majoritariamente por @agint:pl.

A nível dos objetivos específicos, é proposto um ambiente de @playtest simulado para auxiliar as pessoas autoras de @jogo:pl a realizar as primeiras iterações do processo de teste.
Esse sistema deve permitir representar um @jogo_turno arbitrário e, por meio das regras descritas, oferecer ao usuário um sistema de simulação de @partida:pl.
Nessa perspectiva, é necessário estudar a modelagem de estruturas de dados capazes de organizar informações sobre diferentes conceitos, como: @jogo, @partida, @rodada, @turno, @jogador, @movimento e @estado.

Outro requisito do sistema é oferecer formas de avaliação dos @movimento:pl viáveis a partir de dado @estado.
Isso deve ser implementado tanto pelo método clássico do algoritmo de @mcts, como também pelo uso de @agint:pl guiados por @resnet:pl.
O treinamento desses é feito no processo de aprendizado por reforço, o que requer que o sistema gerencie a criação de massas de dados por meio do processo de @selfplay ao simular @partida:pl sintéticas pelo método @alphazero e, em seguida, utilize-os no alinhamento de @peso:pl e @vies:pl.

O presente trabalho está organizado em seis capítulos.
Este #ref(<chapter:introducao>), de Introdução, apresenta o tema geral e a situação de mercado, delimita o problema de pesquisa e descreve a contribuição esperada.
O #ref(<chapter:fundamentacao>), de Fundamentação teórica, aborda conceitos fundamentais para a pesquisa segundo a literatura, apresentando estudos que abordam o tema proposto ou correlatos, a fim de situar o presente trabalho no contexto da pesquisa.
Por sua vez, o #ref(<chapter:metodos>), de Material e métodos, descreve a metodologia de pesquisa e desenvolvimento da solução proposta.
Segue o @chapter:resultados, de Desenvolvimento, que apresenta os resultados obtidos e a discussão acerca dos artefatos gerados.
Por fim, o @chapter:consideracoes, de Considerações finais, apresenta comentários acerca da pesquisa, suas limitações e as perspectivas para trabalhos futuros.
