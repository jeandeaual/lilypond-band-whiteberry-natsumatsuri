\version "2.20.0"

\include "articulate.ly"

\header {
  pdftitle = "夏祭り"
  title = \markup {
    \override #'(font-name . "IPAexGothic")
    \fromproperty #'header:pdftitle
  }
  author = "Whiteberry"
  pdfcomposer = "破矢ジンタ"
  pdfpoet = \markup \fromproperty #'header:pdfcomposer
  composer = \markup {
    \override #'(font-name . "IPAexGothic")
    \concat { "作曲・作詞　" \fromproperty #'header:pdfcomposer }
  }
  subject = \markup \concat {
    "Bass partition for “"
    \fromproperty #'header:title
    "” by "
    \fromproperty #'header:pdfcomposer
    "."
  }
  keywords = #(string-join '(
    "music"
    "partition"
    "bass"
  ) ", ")
  tagline = ##f
}

\paper {
  indent = 0\mm
  markup-system-spacing.padding = 3
  system-system-spacing.padding = 3
  #(define fonts
    (set-global-fonts
     #:music "gonville"
     #:brace "gonville"
   ))
}

section = #(define-music-function (text) (string?) #{
  \once \override Score.RehearsalMark.self-alignment-X = #LEFT
  \once \override Score.RehearsalMark.padding = #2
  \mark \markup \override #'(thickness . 2) \rounded-box \bold #text
#})

gl = \glissando

% From https://lilypond.1069038.n5.nabble.com/Hammer-on-and-pull-off-td208307.html
after =
#(define-music-function (t e m) (ly:duration? ly:music? ly:music?)
   #{
     \context Bottom <<
       #m
       { \skip $t <> -\tweak extra-spacing-width #empty-interval $e }
     >>
   #})

sectionBOne = \relative c, {
  f16 16 8 ees16 16 8 f16 16 8 aes16 16 8 |
}

sectionB = \relative c, {
  \repeat percent 3 \sectionBOne
  f16 16 8 ees16 16 8 f16 16 f,8 16 16 8 |
}

sectionC = {
  \repeat volta 2 {
    \repeat percent 3 {
      f,8. 16 8 8 16 16 8 8 8 |
    }
    f8. 16 8 8 16 16 8 aes a\4 |
    bes8.\4 bes'16\2 f8\3 aes\2 bes,8.\4 16\4 8\4 a\4 |
    aes8.\4 aes'16\2 ees8\3 f aes,8.\4 16\4 8\4 a\4 |
    bes8.\4 bes'16\2 f8\3 aes\2 bes,8.\4 16\4 8\4 a\4 |
    aes8.\4 aes'16\2 ees8\3 f c16 c bes8\4 aes g |
  }
  aes8.\4 aes'16\2 ees8\3 f aes\2 g\2 f ees\3 |
}

sectionDOne = \relative c, {
  bes8\4 bes\4 f'\3 f\3 ees\3 ees\3 g\2 g\2 |
}

sectionDTwo = \relative c {
  aes\2 aes\2 g\2 g\2 f\3 f\3 ees\3 ees\3 |
}

sectionD = {
  \sectionDOne
  \sectionDTwo
  \sectionDOne
  aes8\2 aes\2 ees\3 ees\3 \repeat unfold 4 ges\2 |
  \sectionDOne
  \sectionDTwo
  \sectionDOne
}

sectionE = \sectionB

sectionF = {
  r1 |
  r |
  r |
  r2 r4 \deadNote g, \glissando
}

sectionG = {
  \sectionDOne
  \sectionDTwo
  \sectionDOne
  aes'8\2 aes\2 ees\3 ees\3 ges\2 ges\2 aes\2 aes\2 |
  \sectionDOne
  \sectionDTwo
  \sectionDOne
}

sectionH = \sectionB

sectionI = {
  \compressMMRests R1*9 |
}

song = \relative c, {
  \numericTimeSignature

  % Intro 1
  \tempo 4 = 71
  \tag #'(score video) \compressMMRests R1*7 |

  \tempo 4 = 140
  \section "B"
  \sectionB
  \break

  \section "C"
  \sectionC
  \break

  \section "D"
  \sectionD
  \break

  \section "E"
  \sectionE
  \break

  \section "F"
  \sectionF

  \section "G"
  \sectionG
  \break

  \section "H"
  \sectionH
  \break

  \section "I"
  \sectionI
  \break

  % D.S. 2
  \section "D (Repeat)"
  \sectionD
  \break

  \bar "|."
}

staff = \new Staff \with {
  midiInstrument = #"electric bass (finger)"
  \omit StringNumber
  % Don't show markup in this staff
  \omit TextScript
} {
  \clef "bass_8"
  \key aes \major
  \time 4/4
  \song
}
staves = \new StaffGroup \with {
  \override Glissando.breakable = ##t
  \override Glissando.after-line-breaking = ##t
} <<
  \staff
  \new TabStaff \with {
    stringTunings = #bass-tuning
    % To display the hammer-on and pull-of markup
    \revert TextScript.stencil
    \override TextScript.font-size = #-3
    \slurUp
  } {
    \clef moderntab
    \song
  }
>>

\score {
  \keepWithTag #'score \staves
}

\score {
  \unfoldRepeats \articulate \keepWithTag #'midi \staff
  \midi {}
}
