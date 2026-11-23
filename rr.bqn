⟨F,code⟩←•Import "lib.bqn"
⟨rs,shade,red,blue,grey,Gradient⟩←code
# BQN primitive glyphs: functions, 1-modifiers, 2-modifiers
gl←⟨
  "+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍⋈↑↓↕«»⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔!"
  "˙˜˘¨⌜⁼´˝`"
  "∘○⊸⟜⌾⊘◶⎉⚇⍟⎊"
⟩

•SHOW 

# max 
Repr←{𝕊:
  ⋈1⊑shade
}
Fmt‿· ← F ⟨
  •Type
  •Decompose
  gl
  Repr                        # Format number
⟩


•Show 3‿3‿3⥊↕10
•Out Fmt 3‿3‿3⥊↕10
•Out rs
