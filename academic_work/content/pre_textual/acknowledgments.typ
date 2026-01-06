// # Acknowledgments. Agradecimentos.
// NBR 14724:2024 4.2.1.6

#import "../../components/note.typ": note_from_gabriel
#import "/template/academic_work/pages/pre_textual/acknowledgments.typ": include_acknowledgments
#import "/template/common/components/note.typ": todo_note

#include_acknowledgments()[

  #todo_note(note_from_gabriel[Escrever agradecimentos])

  Agradecemos aos informáticos que construíram as ferramentas utilizadas para desenvolver este projeto, em especial aos contribuidores dos projetos
  #emph[abnTeX2] @abntex:2023:repository_abntex2,
  #emph[Typst] @typst:2025:typst, #emph[glossarium] @typst_community:2025:glossarium e #emph[subpar] @tinger:2025:subpar.
]
