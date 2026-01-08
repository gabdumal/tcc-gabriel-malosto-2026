#import "../../components/note.typ": note_from_gabriel
#import "/template/common/components/note.typ": progress_note, todo_note
#import "/template/common/packages.typ": glossarium
#import "/template/common/util/text_in_english.typ": text_in_english

= Introdução <chapter:introducao>

#progress_note[#note_from_gabriel[Definir @jogo:pl de turno]]

@Jogo:pl são definidos como atividades com propósito bem definido, o qual comumente é vencer um desafio.
Um @jogador apenas pode ser considerado vitorioso caso ele atinja o objetivo segundo condições pré-estabelecidas, definidas como as regras do @jogo.
Tais regras permitem diferentes estratégias, as quais podem ser consideradas melhores ou piores para obter a vitória, de acordo com o contexto da @partida @suits:1967:what_is_a_game.

Dentre as categorias existentes, destacam-se os @jogo_turno:pl (#glossarium.gls-custom("jogo_turno")), em que o tempo ocorre em unidades discretas.
Essas são chamadas de @turno:pl, nos quais os @jogador:pl realizam um número finito de @movimento:pl que resultam em mudanças no @estado do @jogo.
Comumente, os @turno:pl se alternam de forma pré-estabelecida, ao que se denomina @rodada.
Nessa classe de @jogo:pl, as @rodada:pl se sucedem até que a @partida chegue a um @estado final.
Uma característica marcante deles é a possibilidade representar a tomada de decisão dos @jogador:pl durante uma @partida por meio de árvores de decisão.
Essas estruturas permitem formalizar em um grafo os @movimento:pl possíveis, definidos pelas regras, e os @estado:pl resultantes daquelas @salen:2003:rules_of_play[p. 410].

#progress_note[#note_from_gabriel[Escrever sobre o mercado de @jogo:pl]]

O mercado dos @jogo_tabuleiro:pl (#glossarium.gls-custom("jogo_tabuleiro")) modernos teve um marco com o lançamento de #emph[Colonizadores de Catan] @teuber:1995:catan, quando @jogo:pl contemporâneos se tornaram populares mundialmente a partir da Alemanha e criaram um novo movimento cultural.
Atualmente existem sites focados em catalogar esses @jogo:pl, sendo o maior o BoardGameGeek
#footnote[
  Acesso em: #link("https://boardgamegeek.com/wiki/page/Welcome_to_BoardGameGeek").
],
que registra mais de 140 mil itens entre @jogo:pl, suas reimplementações e suas subsequentes expansões.

Ums grande parcela desses @jogo:pl se destaca pelo seu perfil tático ou estratégico durante as @partida:pl, com uma série de reações em cadeia oriundas dos @movimento:pl escolhidos pelas decisões dos @jogador:pl, ocasionando diversas dinâmicas sociais e complexidade emergente.
Estes @jogo:pl são também conhecidos como #text_in_english[designer's games], ou @jogo:pl autorais, por trazerem o nome do autor na capa.
Eles são fruto de uma organização de criadores que proporciona uma série de benefícios para um mercado baseado em novidades @woods:2012:eurogame_design_culture_play.
Anualmente, entre 500 e 600 novos @jogo:pl são apresentados nas maiores convenções do meio, além de reimpressões e reedições @boardgamegeek:2022:spiel22_preview.

#progress_note[#note_from_gabriel[Escrever sobre @playtest]]

O processo de criação de um @jogo é iterativo.
O criador implementa a sua ideia em um protótipo, de preferência de baixo custo para facilitar as modificações necessárias.
Assim que o autor julga que esse protótipo do @jogo está pronto, ele deve ser testado, ao que se denomina a fase de @playtest (#glossarium.gls-custom("playtest")).
Esta é a etapa na qual se realizam @partida:pl para explorar o comportamento dos sistemas e encontrar possíveis desequilíbrios @marcelo:2009:design_de_jogos@fullerton:2019:game_design_workshop.

Deve-se ressaltar que desenvolvimento de um @jogo autoral é um processo complexo e custoso, sobretudo durante a fase de @playtest.
Não é incomum o autor realizar os testes sozinho, simulando vários @jogador:pl.
Mas algumas dinâmicas e mecanismos não funcionam dessa forma e é necessário convidar outras pessoas para auxiliá-lo.
Adicionalmente, são feitos testes de estresse para diversos sistemas do @jogo.
Entre eles, podemos citar a realizar a mesma ação durante quase toda a @partida, caso aparente ser muito vantajosa.
Isso ajudar a  verificar se ela consegue sobrepujar todas as demais @marcelo:2009:design_de_jogos.

A busca pelo balanceamento em @jogo:pl apresenta um desafio grande para a indústria, pois o próprio termo não é consenso @becker:2020:what_is_game_balancing.
Tal processo é altamente dependente de contexto, com desdobramentos para equilíbrio matemático, progressão de dificuldade, progressão de conteúdo, variedade de estratégias e imparcialidade entre @jogador:pl.
Cada um desses grupos apresenta suas próprias características, constituindo subsistemas altamente inter-relacionados de um sistema complexo maior, que é o @jogo @romero:2021:game_balance.

Esta etapa de @playtest, na qual @partida:pl do @jogo são performadas repetidamente, tem alto custo de recursos humanos.
É difícil manter o grupo de teste ativo e focado, dado que se trata de um processo exaustivo e cujo objetivo nem sempre é claro para os @jogador:pl @trzewiczek:2017:i_play_tested_it_100_times.

Ademais, as ações dos próprios testadores podem influenciar os resultados dos testes com suas expectativas, humores, excessos ou falta de concentração.
Esses são pontos importantes a se observar em um teste @marcelo:2009:design_de_jogos, mas não são relevantes quando os objetivos são equilíbrios ou testes de estresse, nos quais os @movimento:pl executados devem ser puramente efetivos e alheios ao divertimento e emoções dos @jogador:pl ou do grupo.

#progress_note[#note_from_gabriel[Escrever sobre estudos sobre @jogo:pl]]

O estudo de @jogo:pl de mesa por meios computacionais segue a própria história da Computação, em que pioneiros buscaram construir máquinas, modelos e algoritmos para jogar xadrez em um nível avançado @silver:2018:general_reinforcement_learning_algorithm.
Tradicionalmente, @jogo_tabuleiro:pl são descritos por @estado:pl discretos e tidos como @jogo:pl combinatoriais.
A área foi conduzida pelo estudo da busca eficiente em árvores de decisão via variações do algoritmo minimax e poda em árvore alfa-beta nas últimas duas décadas.

Os estudos continuaram com as heurísticas especializadas até que os resultados da @mcts:long (@mcts:short) na implementação de algoritmos de decisão se mostraram positivos @kocsis:2006:bandit_based_mcts_planning.
Seu uso não requeria qualquer outro conhecimento prévio além das regras do @jogo e apresentava um bom desempenho sem necessitar que se implementasse uma heurística especializada.

Com base nela, o projeto @alphazero, do laboratório de pesquisa Google DeepMind, se destacou por substituir a necessidade de adaptar conhecimento de domínio de um @jogo específico pelo uso de uma @resnet:long (@resnet:short), atuando como um algoritmo de aprendizagem profunda independente @silver:2016:mastering_game_go.
Essa estratégia permitiu realizar buscas eficientes na árvore de decisão através de um modelo treinado por aprendizado profundo.
Esse método teve várias aplicações em @jogo:pl diferentes, como o Shogi e Go, que apresentavam complexidade superior ao xadrez.
Assim, ao considerar o aprendizado não informado resultante das repetidas @partida:pl simuladas, percebe-se que essas tecnologias são promissoras para aprimorar @jogo:pl de mesa em desenvolvimento, observando desde a avaliação do @estado do @jogo, bem como a massa de dados gerada ao final do treinamento.

#progress_note[#note_from_gabriel[Escrever sobre a contribuição]]

Dado este contexto, o presente trabalho continua uma pesquisa exploratória para investigar relações de balanceamento em @jogo:pl durante sua criação @araki:2020:testes_de_software@malosto:2023:alphazero_como_ferramenta_de_playtest@malosto:2025:moving_towards.
A nível específico, é proposto um ambiente de @playtest simulado para auxiliar as pessoas autoras de @jogo:pl a realizar as primeiras iterações do processo de teste.\
#todo_note[#note_from_gabriel(margin: true)[Possivelmente alterar a contribuição, para reduzir o escopo]]

O objetivo dessas etapas compreende testes de estresse e equilíbrio matemático, de forma a eliminar a necessidade de testadores humanos além do autor.
Assim, espera-se que a participação de pessoas seja empregada para investigar aspectos lúdicos, sociais e a experiência do jogador, ao passo em que os testes repetitivos serão realizados majoritariamente por @agint:pl.

A fim de construir o ambiente proposto, é necessário estudar a representação de @jogo:pl de @turno:pl em ambiente computacional.
Identifica-se o foco em estudar a modelagem de estruturas de dados capazes de organizar informações sobre diferentes conceitos, como: @jogo (#glossarium.gls-custom("jogo")), @partida (#glossarium.gls-custom("partida")), @rodada (#glossarium.gls-custom("rodada")), @turno (#glossarium.gls-custom("turno")), @jogador (#glossarium.gls-custom("jogador")), @movimento (#glossarium.gls-custom("movimento")) e @estado (#glossarium.gls-custom("estado")).

Além disso, é necessário estudar a implementação de algoritmos de busca e de aprendizado por reforço, a fim de simular @partida:pl e avaliar o @estado do @jogo.
Etapas relevantes desse processo incluem a geração de massa de dados sobre as @partida:pl simuladas, a avaliação dos @estado:pl do @jogo segundo métricas de balanceamento e a comparação entre agentes treinados em diferentes condições.
#todo_note[#note_from_gabriel(margin: true)[Possivelmente alterar a avaliação, para reduzir o escopo]]
Tem-se o foco sobre os métodos de @ia, @mcts e @resnet, que se mostram promissores para orientar @agint:pl em @partida:pl simuladas de @jogo_tabuleiro:pl.

#progress_note[#note_from_gabriel[Escrever sobre a estrutura]]

O presente trabalho está organizado em seis capítulos.
Este #ref(<chapter:introducao>), de Introdução, apresenta o tema geral e a situação de mercado, delimita o problema de pesquisa e descreve a contribuição esperada.
O #ref(<chapter:fundamentacao>), de Fundamentação Teórica, aborda conceitos fundamentais para a pesquisa segundo a literatura, apresentando estudos que abordam o tema proposto ou correlatos, a fim de situar o presente trabalho no contexto da pesquisa.
Por sua vez, o #ref(<chapter:metodos>), de Material e Métodos, descreve a metodologia de pesquisa e desenvolvimento da solução proposta.
Segue o @chapter:resultados, de Resultados, que apresenta os resultados esperados e a análise dos dados coletados.
Por fim, o @chapter:conclusao, de Considerações Finais, apresenta comentários acerca da pesquisa, suas limitações e as perspectivas para trabalhos futuros.
