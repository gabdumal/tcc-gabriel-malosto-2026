#import "../../components.typ": note_from_gabriel, get_term
#import "/template/common/components.typ": todo_note
#import "/template/common/util.typ": text_in_english
#import "/template/packages.typ": glossarium

= Considerações finais <chapter:consideracoes>

Este trabalho se tratou de uma pesquisa de natureza aplicada e exploratória que visou o uso dos métodos de @mcts e de @resnet no contexto do projeto @alphazero como ferramenta de auxílio no projeto de jogos.
Seu objetivo específico era criar um ambiente de representação de protótipos de @jogo_turno:pl com o fim de auxiliar pessoas criadoras de @jogo:pl a realizarem a fase de @playtest.
Esse sistema deveria ser capaz de representar @jogo_turno:pl arbitrários e permitir a simulação de @partida:pl.
Além disso, o programa deveria avaliar os @movimento:pl viáveis a partir de um @estado por meio do método clássico de @mcts e por meio de @agint:pl orientados por @resnet:pl.

A hipótese tomada é que os @agint:pl seriam capazes de realizar a fase de @playtest de @jogo de forma automatizada por meio da geração do histórico de @partida:pl sintéticas, e destacar estatísticas que delas emergem.
Dessa forma, os projetistas de @jogo_turno:pl poderiam reduzir o uso de recursos humanos quando o interesse é realizar testes de estresse e balanceamento.
Então, esse estudo poderia oferecer perspectivas e ferramentas inovadoras ao cenário de criação de @jogo:pl autorais. 

Para isso, os autores desenvolveram o sistema #glossarium.gls(first: true, "apts") que, de forma geral, foi capaz de viabilizar a representação de @jogo_turno:pl de informação completa e organizados em #glossarium.gls("jogo_tabuleiro", display: "tabuleiros").
Como resultado, foi possível modelar o #get_term("jogo_velha"), uma variação autoral dele em um tabuleiro maior chamada de #get_term("snowball"), e ainda o @jogo #get_term("ligue4"), o que comprovou a viabilidade de representar diferentes estilos de @jogo na plataforma.

Esse último @jogo foi selecionado para criarmos um @agint orientado pela @mcts clássica, que é executada pelo programa e gera como artefatos a estimativa de qualidade de jogar cada um dos @movimento:pl disponíveis e uma imagem da árvore de busca construída.
Essa tecnologia foi aprimorada ao substituir a busca em árvore pela predição de modelos de @resnet:pl, usada para gerar o artefato de estimativa de qualidades do @movimento:pl.

Como objetivo de viabilizar essa técnica, implementamos no @apts métodos responsáveis por ajustar os modelos de @rn para que suas predições sejam mais acuradas.
Nesse sentido, o sistema permite criar uma instância de @resnet inicial e fornecê-la novamente ao programa para que seja usada como método de orientação de um @agint focado em geração de memória de treinamento.
Ele usa a @mcts com adaptações que incorporam a @resnet, conforme o projeto @alphazero, para escolher os melhores @movimento:pl em uma série de @partida:pl simuladas.

Algoritmos auxiliares usaram comandos disponibilizados pelo @apts para continuamente alinhar os modelos aos dados por eles próprios gerados num processo de aprendizado por reforço, comumente chamado de @selfplay.
Esse processo permite ao usuário do sistema ajustar os parâmetros para criar @agint:pl com diferentes estratégias de @jogo.

Então, ele é capaz de usar comandos do @apts alinhados a um script auxiliar para que tais agentes treinados se enfrentem em uma série de @partida:pl, cujos dados podem ser extraídos em métricas úteis acerca da quantidade de vitórias de cada @jogador, da duração do @jogo e da predileção por certos @movimento:pl.

Essas métricas demonstram a capacidade de uso do sistema construído para auxiliar no processo de @playtest, reduzindo a necessidade de testadores humanos nessa fase, ainda que tenha sido atestada a necessidade de novos estudos e encontradas possíveis melhorias a fazer.
Dessa forma, acreditamos ter contribuído diretamente às pessoas projetistas de @jogo_tabuleiro:pl autorais, por fornecer uma ferramenta diretamente aplicável ao seu trabalho.

Numa perspectiva maior, esperamos que este trabalho tenha contribuído de forma positiva para o cenário de criação de @jogo_turno:pl autorais, que se encontra em crescimento e requer o estudo de métodos inovadores.
Isso se justifica por termos fornecido uma avaliação de hipótese promissora acerca dos métodos abordados, e termos aplicado conceitos de representação de @jogo:pl de forma genérica o suficiente para compreender uma variabilidade grande de estilos de @jogo:pl.

Contudo, encontramos possíveis problemas no processo de alinhamento das @rn:pl aos dados de memória gerados, de forma que não está certo se os @agint:pl foram capazes de compreender plenamente como qual dos @jogador:pl eles deveriam atuar em cada @turno.
Uma proposta de solução razoável seria gerar um @agint:pl que atue apenas como um @jogador.
Entretanto, isso incorreria em maior gasto de recursos e dificultaria o uso do sistema para @jogo:pl com uma quantidade grande de @jogador:pl.
Essa perspectiva faz necessário investigar formas mais adequadas de representar dados de um @estado no formato de canais de números binários, o qual é requerido como entrada da @resnet.

Também é relevante ressaltar a necessidade de mais experimentos variando os parâmetros utilizados em várias fases do processo.
Durante a fase de criação de memórias, poderíamos testar valores diversos para a quantidade de ciclos realizados pela @mcts ou o coeficiente de @exploracao por ela utilizado.
Ainda, seria interessante testar diferentes quantidades de simulações de @partida:pl ao gerar as memórias, ou variar o coeficiente de suavização usado pelo método de seleção de @movimento por roleta.
Já durante a fase de alinhamento de @peso:pl e @vies:pl, é possível utilizar um tamanho diferente para o conjunto de @turno:pl alinhado a cada passo ou, ainda mais relevante, a quantidade de épocas de treino e de ciclos de treinamento, que deixaram de variar significativamente depois de poucas iterações.

Outra questão que não ficou evidente é a determinação do parâmetro de penalização de @movimento:pl inválidos, cujo valor foi dado como $0$.
Ao mesmo tempo em que seu uso poderia levar a uma convergência mais rápida para os @movimento:pl úteis, um valor muito alto levaria a uma diferença expressiva entre os valores de qualidade calculados para os @movimento:pl bons e o coeficiente, o que resultaria numa aferição alta para a função de @perda. 

Finalmente, destacamos que não foi possível definir um valor de @seed para o método de alinhamento da @rn disponibilizado pela biblioteca #get_term("tensorflow_js").
O processo aleatório do qual ele depende é o sorteio do conjunto de entradas e saídas a alinhar em cada momento.
Isso tornou essa etapa de execução não-determinística, o que prejudica a reprodutibilidade dos resultados.
Quanto aos demais usos de valores pseudo-aleatórios, certificamo-nos de gerá-los por meio da @seed fornecida pelo usuário.
Assim, também pode-se realizar mais experimentos variando seu valor.

Outra ponto a explorar é a avaliação da qualidade de um @movimento realizada após o fim da construção da árvore de busca.
É comum selecionar aquele que levou a mais visitas em seu ramo da árvore, mas isso prejudica @movimento:pl que imediatamente levam a um @estado vitorioso, o qual não pode mais ser visitado.
Para resolver esse problema, criamos uma função de avaliação que alinha a qualidade estimada da @partida com a quantidade de visitas em cada ramo.
Contudo, sua especificação foi arbitrária e requer maiores experimentos ou uma mais intensa busca na literatura para substituí-la.

Acerca da representação de @jogo:pl, este trabalho apresentou como limitação o suporte apenas a @jogo_turno:pl, o que se justifica pela tradução direta para código-fonte de componentes fundamentais que os definem.
Os autores seguiram a convenção de que, a cada @turno, pode existir apenas um estágio, no qual a única ação disponível é que o @jogador do @turno efetue um @movimento.
Em @jogo:pl mais complexos, cada @turno pode se dividir em estágios com objetivos diferentes, como primeiramente comprar uma carta do baralho e depois escolher um @movimento.
Além disso, é possível que outros @jogador:pl atuem dentro do @turno que a princípio não está alocado a eles.
Essas especificidades podem ser representadas em trabalhos futuros.

Nesse sentido, a necessidade de conhecimento da linguagem #get_term("js") para implementar as classes concretas e em seguida suas instâncias oferece uma restrição para parte dos usuários.
Idealmente, os projetistas não deveriam precisar ter esse conhecimento específico, mas utilizariam uma plataforma com interface gráfica com suporte a navegadores Web.
Então, a descrição dos protótipos deveria ser completamente desconectada da base de código-fonte do sistema.
Para isso, poderíamos adaptar o @apts para reconhecer linguagens específicas de domínio, como a #text_in_english[Game Description Language] (GDL)
#footnote[Acesso em: #link("http://logic.stanford.edu/ggp/notes/gdl.html").]
ou a #text_in_english[Zillions by rules files] (ZRF)
#footnote[Acesso em: #link("https://www.zillionsofgames.com/language").]
.

Nesse contexto, o sistema atualmente foi testado apenas para @jogo_tabuleiro:pl, ainda que os autores tenham tomado o cuidado de estabelecer os componentes de forma abstrata o suficiente para implementar @jogo:pl de cartas.
Contudo, existe uma complicação para esse tipo de @jogo em relação à sua codificação em canais, uma vez que a entrada da @resnet requer uma matriz de três dimensões, o que comumente representa as linhas e colunas do tabuleiro e, em seguida, os canais de dados.
Para @jogo:pl de cartas, não há uma relação direta entre esses conceitos, o que também abre uma linha de investigação futura.

Finalmente, existe uma preocupação quanto à necessidade de descrever todos os @movimento:pl possíveis de um @jogo no momento em que se realiza a sua representação.
O @jogo #get_term("ligue4"), usado no experimento deste trabalho, permitia executar apenas 7 @movimento:pl, o que não constitui um problema.
Já o @jogo de Xadrez como implementado pelo projeto @alphazero apresenta 4672 @movimento:pl, os quais deveriam ter, cada um, um nome e descrição.
Apesar de a maior parte desse número ser devido a combinações das mesmas peças em diferentes situações --- cujas instâncias poderiam ser definidas por meio de scripts ---, ainda é pouco ergonômico para um usuário pensar em todas essas possibilidades antes sequer de testar o protótipo.
Por isso, é relevante pesquisar sobre a possibilidade de treinar a @rn para atribuir qualidades apenas aos @movimento:pl válidos dinamicamente gerados a cada @turno.

Ademais, é uma característica comum de @jogo:pl de cartas que os @jogador:pl não mostrem aos demais as cartas que seguram em cada @turno.
Isso os configura seus @estado:pl como de informação incompleta, o que exige mais estudos acerca da representação desses na forma codificada para a entrada na @resnet.
