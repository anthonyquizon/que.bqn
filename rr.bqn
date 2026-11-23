# BQN primitive glyphs: functions, 1-modifiers, 2-modifiers
gl←⟨
  "+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍⋈↑↓↕«»⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔!"
  "˙˜˘¨⌜⁼´˝`"
  "∘○⊸⟜⌾⊘◶⎉⚇⍟⎊"
⟩

# max 
Repr←{
  •SHOW "woo"‿𝕩
  •Repr 𝕩
}
Fmt‿· ← (•Import "f.bqn"){𝔽} ⟨
  •Type
  •Decompose
  gl
  Repr                        # Format number
⟩


•Out Fmt 3‿3‿3⥊↕10
