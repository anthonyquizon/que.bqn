⟨F,code⟩←•Import "lib.bqn"
⟨rs,shade,red,blue,grey,Gradient⟩←code
# BQN primitive glyphs: functions, 1-modifiers, 2-modifiers
gl←⟨
  "+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍⋈↑↓↕«»⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔!"
  "˙˜˘¨⌜⁼´˝`"
  "∘○⊸⟜⌾⊘◶⎉⚇⍟⎊"
⟩

# max 
Repr←{𝕊:
  ⋈1⊑shade
  #•Fmt 𝕩
}
Fmt‿· ← F ⟨
  •Type
  •Decompose
  gl
  Repr                        # Format number
⟩

z←2‿2‿3‿9⥊↕10
•Out Fmt z
•Out rs
