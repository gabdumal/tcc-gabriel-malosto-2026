#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": glossarium

== #glossarium.gls(capitalize: true, long: true, plural: true, "resnet") <section:resnet>

#todo_note(note_from_gabriel[Desenvolver mais o texto sobre @resnet, independentemente da sua aplicação em @jogo:pl])

Essa classe de modelos de @ia é derivada das @cnn:pl, e aplicada primariamente em domínios de reconhecimento de imagens @li:2022:survey_convolutional_neural_networks@he:2015:deep_residual_learning.

Essa rede tem o objetivo de construir um modelo que responda bem a entradas diversas, ao criar uma rede de conexões profunda, mas garantindo baixa perda de precisão.

Sua estrutura consiste de sucessivos blocos de camadas convolucionais e normalizações, nas quais a função de ativação utilizada é a \gls{relu}, detalhada nos trabalhos de~\citeonline{nair:2010:rectified_linear_units}.
Ao final de cada bloco, é reaplicada a camada de entrada inicial, o que mantém intensos os detalhes da imagem.
