#import "/academic_work/components/note.typ": note_from_gabriel
#import "/template/common/components/figure.typ": describe_figure
#import "/template/common/components/note.typ": todo_note
#import "/template/common/packages.typ": glossarium
#import "/template/common/util/text_in_english.typ": text_in_english

== #glossarium.gls(capitalize: true, long: true, plural: true, "resnet") <section:resnet>

As #glossarium.gls(long: true, plural: true, "cnn") são uma classe de @rn:pl profundas especialmente projetadas para processar dados estruturados em grade.
Seus usos se destacam na áreas de visão computacional, sobretudo para o reconhecimento de imagens.
Aprimorando as @rn:pl tradicionais totalmente conectadas, as @cnn:pl utilizam operações de convolução que permitem capturar padrões espaciais e hierárquicos nos dados de entrada sem definição prévia dos elementos de interesse @li:2022:survey_convolutional_neural_networks.

A arquitetura típica de uma @cnn consiste em camadas convolucionais, camadas de @pooling (#glossarium.gls-custom("pooling")) e camadas totalmente conectadas.
As camadas convolucionais aplicam filtros que detectam características locais, como bordas e texturas, enquanto as camadas de @pooling reduzem a dimensionalidade espacial (#text_in_english[downsampling]), preservando as informações mais relevantes @li:2022:survey_convolutional_neural_networks.
Dessa forma, essa classe de @rn:pl balanceia a precisão dos detalhes com a rapidez de convergência pelo processo de #text_in_english[downsampling].

Seguindo os trabalhos na área, #cite(form: "prose", <he:2015:deep_residual_learning>) introduziram as #glossarium.gls(long: true, plural: true, "resnet") como uma evolução importante das @cnn:pl.
Seu principal objetivo era resolver o problema de degradação em redes muito profundas.
Quando @rn:pl convencionais se tornam excessivamente profundas, sua acurácia tende a saturar e depois degradar, não devido ao @overfitting (#glossarium.gls-custom("overfitting")), mas à dificuldade de otimização @he:2015:deep_residual_learning.

A inovação fundamental das @resnet:pl é a introdução de conexões residuais (#text_in_english[shortcut connections]), que permitem que o gradiente flua diretamente através da rede durante o treinamento @he:2015:deep_residual_learning@liang:2020:image_classification_resnet.

Tais conexões são incorporadas em uma estrutura padrão chamada bloco residual, como se pode observar na @figure:residual_block.
Em vez de aprender uma transformação direta $H(x)$, cada bloco aprende uma função residual $F(x) = H(x) - x$, onde $x$ é a entrada do bloco.
A saída final do bloco é então $F(x) + x$, combinando a transformação aprendida com a entrada original @he:2015:deep_residual_learning.
Essa estrutura permite que a rede aprenda transformações incrementais enquanto preserva informações da entrada @liang:2020:image_classification_resnet.

#describe_figure(
  placement: auto,
  source: [#cite(<he:2015:deep_residual_learning>, form: "prose").],
  sticky: true,
  [#figure(
    caption: [Estrutura de um bloco residual usado em uma @resnet.],
    image(
      width: 60%,
      "/academic_work/assets/images/residual_block.webp",
    ),
  )<figure:residual_block>],
)

O formato de uma @resnet consiste de sucessivos blocos residuais, cada um composto por camadas convolucionais e normalizações, nas quais a função de ativação utilizada é a @relu, detalhada nos trabalhos de #cite(form: "prose", <nair:2010:rectified_linear_units>).
Essa arquitetura possibilita a construção de redes extremamente profundas mantendo alta precisão e facilitando o treinamento @he:2015:deep_residual_learning.
