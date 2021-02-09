\version "2.20.0"

\include "whiteberry-natsumatsuri-bass.ily"

\score {
  \keepWithTag #'score \staves
}

\score {
  \unfoldRepeats \articulate \keepWithTag #'midi \staff
  \midi {}
}
