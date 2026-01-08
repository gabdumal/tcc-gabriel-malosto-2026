#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": glossarium
#import "/template/common/util/text_in_english.typ": text_in_english

== Trabalhos relacionados <section:related_works>

#cite(form: "prose", <zook:2019:automatic_playtesting>) reforçam as vantagens da substituição de @jogador:pl humanos em partes bem específicas do processo de @playtest.
O principal destaque é no ajuste de parâmetros e de dificuldade quando os sistemas do @jogo já estão definidos mas se busca uma melhor experiência para o público alvo do @jogo.

Ademais, os autores desenvolvem um estudo combinando técnicas de regressão e classificação para realizar uma aprendizagem ativa @cohn:1994:improving_generalization_with_active_learning de um @jogo #text_in_english[shoot'em up].
A mecânica desse @jogo é bem definida, mas os parâmetros --- como velocidades de jogador, inimigos e tiros --- são ajustados através de testes exaustivos.
Nesse trabalho, eles foram substituídos pelo @playtest automatizado.

Nos trabalhos de #cite(form: "prose", <gudmundsson:2018:human_like_playtesting>)#cite(form: "prose", <zook:2019:automatic_playtesting>), a @mcts é utilizada junto a #glossarium.gls(plural: true, long: true, "cnn").
Elas são treinadas através de um massivo conjunto de dados de @jogador:pl reais para prever a dificuldade de missões em @jogo:pl digitais #text_in_english[match-3] --- respectivamente #text_in_english[Candy Crush] e #text_in_english[Jewels Star Story].
Neste tipo de @jogo, o @jogador deve mover figuras em uma grade, buscando colocar três ou mais figuras iguais adjacentes, que são retiradas do tabuleiro e podem gerar outras remoções em cadeia.
Os trabalhos conseguem reproduzir comportamentos de @jogador:pl humanos e avaliar a dificuldade do nível proposto pelo #text_in_english[game designer] para uma melhor experiência de @jogo.

Sob a ótica de comunicação dos dados gerados ao #text_in_english[designer], #cite(form: "prose", <wallner:2019:aggregated_visualization_playtesting_data>) desenvolveram um sistema para traçar, em @jogo:pl digitais de plataforma, a trajetória de dados de partidas colhidas diretamente sobre os mapas do @jogo.
Ele integra dados de fontes diferentes em uma única visualização capaz de representar o #text_in_english[feedback] dado pelos @jogador:pl, medidas fisiológicas colhidas e a rastreabilidade dos @movimento:pl em @jogo.


Os dados fisiológicos relacionados ao estímulo do @jogador são representados por mapas de cor ao dividir o espaço do @jogo em regiões; a movimentação por linhas que conectam essas regiões, com sua opacidade e espessura relacionadas à frequência; e os eventos discretos agrupados em ícones com o tamanho relacionado à sua frequência, relatando observações de comportamentos durante a partida.
A abordagem diminui a poluição visual, compila um grande conjunto de de informações e provê um grande valor para avaliar um cenário em desenvolvimento.
#todo_note(note_from_gabriel(margin: true)[Reescrever este parágrafo])

Similarmente, #cite(form: "prose", <stahlke:2020:artificial_players_in_the_design_process>) investigam técnicas similares em @jogo:pl em três dimensões, apresentando os caminhos sobre superfícies para auxiliar no processo de projeto dos níveis.
Registra-se também o uso de agentes para o projeto ou validação da economia interna dos @jogo:pl, mostrado nos resultados iniciais de #cite(form: "prose", <ranandeh:2023:beyond_equilibrium>).

Apesar de os trabalhos de testes serem em sua maioria referentes a @jogo:pl digitais --- normalmente modelados sistemas em tempo contínuo ---, acreditamos que as mesmas técnicas podem ser aplicadas a @jogo:pl físicos e modelados por sistemas discretos.
A escassez de trabalhos nesta indústria nos motiva a realizar esta investigação, buscando avaliar as limitações ou ajustes necessários para sua implantação.
