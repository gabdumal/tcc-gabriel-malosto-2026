// # Util. Utilitários.


// ## Gender. Gênero.

#let get_gender_ending(
  gender,
  masculine_ends_with_vowel: true,
  plural: false,
) = {
  if gender == "masculine" {
    if masculine_ends_with_vowel {
      "o"
    } else {
      if plural {
        "e"
      }
    }
  } else if gender == "feminine" {
    "a"
  }
  if plural {
    "s"
  }
}


// ## Text in english. Texto em inglês.

#let text_in_english = it => emph(
  text(
    lang: "en",
    region: "us",
    it,
  ),
)


// ## Text. Texto.

#let capitalize_first_letter = text => {
  upper(text.at(0)) + text.slice(1)
}

#let capitalize_every_word = text => {
  text.split().map(word => capitalize_first_letter(word)).join(sym.space)
}
