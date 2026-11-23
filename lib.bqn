# Format an array to a string including newlines

code⇐{
  all   ⇐ @+9600+↕32                                                        # "▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟"
  lower ⇐ @+9600+1+↕8                                                       # "▁▂▃▄▅▆▇█"  ⅛ → full height (bars, sparklines)
  left  ⇐ @+9608+↕8                                                         # "█▉▊▋▌▍▎▏"  full → ⅛ width (horizontal bars)
  shade ⇐ " ░▒▓█"                                                           # empty → full shading
  quads ⇐ " ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█"                                                # quadrants indexed by 4-bit mask (TL=1 TR=2 BL=4 BR=8)

  # Quadrant char from booleans tl‿tr‿bl‿br
  Quad ⇐ { quads⊑˜+´1‿2‿4‿8×𝕩 }

  # ANSI SGR escapes
  e     ⇐ @+27
  Sgr   ⇐ { e∾"["∾(1↓∾";"⊸∾¨•Fmt¨𝕩)∾"m" }                                   # Sgr ⟨codes…⟩
  Fg    ⇐ Sgr 38‿2∾⊢                                                        # truecolor foreground: Fg r‿g‿b
  Bg    ⇐ Sgr 48‿2∾⊢                                                        # truecolor background: Bg r‿g‿b
  Fg256 ⇐ Sgr 38‿5∾⊢                                                        # 256-colour fg: 232–255 grey ramp, 16–231 6×6×6 cube
  Bg256 ⇐ Sgr 48‿5∾⊢
  rs    ⇐ Sgr ⟨0⟩                                                           # reset
  Half ⇐ { (Fg 𝕨)∾(Bg 𝕩)∾"▀" }                                              # Two vertical pixels in one cell: top Half bot (both r‿g‿b)
  Hue ⇐ { ⌊255×0⌈1⌊1-˜|3-˜6|0‿4‿2+6×𝕩 }                                     # Hue in [0,1) → r‿g‿b (full saturation and value)
  Gradient ⇐ { a‿b𝕊n: rs∾˜{(Fg ⌊a+𝕩×b-a)∾"█"}¨(↕n)÷1⌈n-1 }                  # a‿b Gradient n: n full blocks linearly interpolated from colour a to b
  Spectrum ⇐ { rs∾˜∾{(Hue 𝕩)Half Hue 1|𝕩+0.5}¨(↕𝕩)÷𝕩 }                      # Spectrum n: rainbow of n half-block cells (hue on top, shifted hue below)

  black     ⇐ 0‿0‿0
  white     ⇐ 255‿255‿255
  grey      ⇐ 128‿128‿128
  darkGrey  ⇐ 64‿64‿64
  lightGrey ⇐ 192‿192‿192
  red       ⇐ 255‿0‿0
  darkRed   ⇐ 128‿0‿0
  green     ⇐ 0‿255‿0
  darkGreen ⇐ 0‿128‿0
  blue      ⇐ 0‿0‿255
  navy      ⇐ 0‿0‿128
  yellow    ⇐ 255‿255‿0
  cyan      ⇐ 0‿255‿255
  teal      ⇐ 0‿128‿128
  magenta   ⇐ 255‿0‿255
  purple    ⇐ 128‿0‿128
  orange    ⇐ 255‿165‿0
  pink      ⇐ 255‿192‿203
  brown     ⇐ 139‿69‿19
  gold      ⇐ 255‿215‿0
  violet    ⇐ 148‿0‿211
  skyBlue   ⇐ 135‿206‿235
  lime      ⇐ 50‿205‿50
  olive     ⇐ 128‿128‿0

  Cube ⇐ { 16++´36‿6‿1×𝕩 }
}

# modified copy from bqn src/f.bqn
F⇐{
  ⟨Type,Decomp,FF,FN⟩←𝕩
  ReprAtom ← <⟜@◶⟨@⊸≠◶⟨"@","'"⊸(∾∾⊣)⟩,FN⟩

  # Vertical padding for arrays of rank greater than 2
  PadCount ← {
    # Empty lines after each row: 1 if it's at the end of a 2-cell, plus
    # 1 if it's at the end of a 2-cell and a 3-cell, and so on
    # But none at the very end
    0⌾(¯1⊸⊑) ⥊ 𝕨 +⎉¯1‿∞´ ×⌜˜`⌾⌽ (-𝕩)↑¨1
  }
  PadV ← {
    # Leading shape and padding count
    p ← PadCount 1 ⌈ ls ← ¯1↓≢𝕩
    # If 𝕩 has cells, pad by selection; if it's empty, there are only
    # pads but selection would try to get cells (1⌈ above), so overtake.
    Pad ← {(»⊸<⊸×/0∾1+𝕨) ⊏ ' '¨∘⊏⊸∾𝕩} # AQ: pad vertical
    p (0<≠∘⊢)◶⟨+´⊸↑,Pad⟩ ((×´ls)∾¯1↑≢𝕩) ⥊ 𝕩
  }⍟(2 < =)
  PadVMixed ← {
    # PadV, but with 2-cells enclosed: they might have different lengths
    ∾ (1 PadCount ≢𝕩) (⊢∾≍⟜(¯1⊑≢)⥊' '˙)¨ ⥊𝕩
  }

  # Horizontal padding: just some spaces on either side
  PadH ← { s←⟨≠𝕩,𝕨⟩⥊' ' ⋄ ∾≍⟨s,𝕩,s⟩ }

  # Add a frame to padded data
  Enframe ← ∨○(1⊸≠)⟜≠◶{∨´2=+`-˝"⟨⟩"=⌜⊏𝕩}‿1◶{
    # One-line version
    ≍"⟨"∾(¯1↓1↓⊏𝕩)∾"⟩"
  }‿{
    # General case
    t ← "┌" ∾ (5⊸<)◶⟨⥊"·─"⊏˜1⌊⊢,FN⟩𝕨
    l ← (≠t) ⌈ ¯1 ⊑ ≢𝕩
    ∾ ⟨≍l↑t, ((0⌈4⌊𝕨-1)⊑"·╵╎┆┊")⌾⊑l↑˘𝕩, ≍l-⊸↑"┘"⟩
  }

  FmtEmpty ← (0‿0≢≢)◶("┌┐"≍"└┘")‿(((2≠=)∨0=≠)◶{
    '┐'⌾(0‿¯1⊸⊑) 2 Enframe 1 PadH ' '¨𝕩
  }‿{
    ≍(1<≠)◶⟨"⟨⟩",'↕'⌾⊑·∾·"‿"⊸∾¨FN¨⟩≢𝕩
  })

  _paddingJoin ← {  # 𝕗 is 1 to left align and ¯1 to right align
    s ← ≢¨ 𝕩
    w ← 0¨(0<=)◶⟨⥊,⌈˝⍟(=-1˙)⟩1⊑¨s #AQ change here for width block padding 0¨
    h ← ⌈˝⎉1⍟(0<=) ⊑¨s
    o ← <∘∾⎉2 ≍⍟(0⌈2-=) (h ⋈⌜ 𝕗×w¬(-𝕗×≠w)↑1) ↑¨ 𝕩
    2 PadH (1⊸⌽⊸≡⥊h)◶⟨PadVMixed,PadV∘>⟩ o
  }

  _fmtMixedP ← {
    r ← =𝕩
    Join ← r Enframe 𝕗 _paddingJoin

    𝕨 (∨´<⟜∞)◶(Join <⊸(Fmt¨))‿{
      p ← ⟨r>1,2⟩  # Outer padding
      o ← ¯1((0+⌜´(1(1+×)`⊢)⌾⌽×↕¨)∘↓⋈⌜2×↕∘⊑)≢𝕩  # Offset
      E ← (1‿1⥊'…')˙
      f ← o (𝕨-p)⊸-⊸(⊣ E∘⊢⍟(∨´<⟜≢) (∨´≤⟜0)◶Fmt‿E)¨ 𝕩
      Join f
    } 𝕩
  }
  FmtMixed ← 1 _fmtMixedP

  FmtSimple ← (≠(0⊸<+≤)+´)∘(⥊<@˙)∘⊢◶{ # Depth 1
    # All characters
    r ← =𝕩 ⋄ 𝕩 ↩ ><¨0↓𝕩  # Ensure rank>0 and ' ' for fill
    k ← ∞⍟(0⊸=) -≠ c ← ¯1↓≢𝕩
    q ← "'"""⊑˜0<r
    # Escape quotes in strings (rank 1) and substitute control chars
    # with control pictures for other ranks.
    CSub ← { 𝕩 + (𝕩(=×'␡'-⊢)@+127) + ('␀'-@)×𝕩<@+32 }
    𝕩 ↩ (1≠r)◶⟨(1+q=⊢)⊸/,Csub⟩ 𝕩
    (r Enframe 1 PadH PadV)⍟(1≠r) ≍ (q⌾⊑c⥊(¯1⊑1∾c)↑'·') ∾⎉k 𝕩 ∾⎉k c-⊸↑q
  }‿{
    # Not homogeneous, or empty
    (∨´0=≢)◶⟨𝕨⊸FmtMixed,FmtEmpty⟩ 𝕩
  }‿{
    # All numbers
    𝕨 ¯1 _fmtMixedP 𝕩
  }

  # Format data type
  FmtDat ← (2⌊≡∘⊢)◶⟨
    ≍ ReprAtom∘⊢
    (∨´∘⥊3≤Type⌜∘⊢)◶FmtSimple‿FmtMixed
    FmtMixed
  ⟩

  # Word-forming characters need to be separated by spaces
  IsWordChar ← ∊⟜(∧"¯π∞_") ∨ (⥊∧"0AaÀàØø"+0≍˘10∾2/26‿23‿7)⊸(2|⍋)

  # Format part of a compound operation; return precedence‿string
  Paren ← "("∾∾⟜")"
  _dispOp_ ← {
    FmtComp ← Type (3≤⊣)◶⟨0⋈·𝔽⊢, 𝕊⟩ ⊢
    k ← ⊑ d ← Decomp 𝕩
    p ← k ⊑ "00321111"-'0'
    JW ← ∾ (∧˝∘IsWordChar (⊢´¨¯1⊸↓)≍(⊣´¨1⊸↓)) 0⊸∾⊸(↑⟜" "⊸∾¨)⍟(∨´⊣) ⊢
    FromComp ← JW (⌽⍟(p>1)·-0=↕∘≠) (+⟜⊑Paren∘⊢⍟((2⌊p)≤⊣)1⊸⊑)⟜FmtComp¨ ⊢
    s ← (2⌊|k)◶⟨⥊∘FF𝕩˙,𝕨𝔾⊢,FromComp⟩ 1↓d
    s ↩ ∾⟜"{𝔽}"⍟(3>·Type ¯1⊑d˙)⍟(2≤p) s
    p‿s
  }
  arr ← "*array*"
  FmtOp ← ≍1⊑ (1=≠)◶⟨arr,⊏⟩∘(∞‿∞⊸FmtDat) _dispOp_ (=⟜2◶⟨FF⊑∘⊢,arr⟩)

  # Format any value to character matrix
  Fmt ← {
    t ← Type𝕩
    𝕨 (3≤t)◶⟨FmtDat,t⊸FmtOp⟩ 𝕩
  }
  Trunc ← {
    c ← 𝕨<s←≢ f ← 𝕩
    𝕨 {l←c-˜𝕨⌊s ⋄ ls←⋈⌜´l∾⟜(⥊⟜1)¨c ⋄ ∾ ls ⥊¨ (l↑f)⌾⊑ '…'¨ ls}⍟(∨´c) f
  }
  FmtW ← {
    m ← "•Fmt: 𝕨 must be a list of up to two numbers (width, height)"
    m ! (1≥=)◶⟨0,2≥≠⟩ 𝕨
    (⌽𝕨⊢⊘»∞‿∞) (⊣ Trunc Fmt) 𝕩
  }

  # Represent as string
  RR ← {Repr𝕩}
  ReprList ← (0<≠)◶⟨"⟨⟩",(⌈´(2‿1‿0»7⥊2)⊏˜Type⌜)◶⟨
    '"' (⊣∾((1+=)/⊢)∾⊣) ⊢
    (1<≠)◶⟨"⟨"∾"⟩"«∾,1↓∾⟩("‿"∾ReprAtom)¨
    "⟨"∾"⟩"«·∾(","∾RR)¨
  ⟩⟩
  ReprArr ← (2⌊=)◶⟨Paren"<"∾RR∘⊑,ReprList,Paren≢∾⟜"⥊"⊸∾○ReprList⥊⟩
  ReprDat ← (0=Type)◶⟨ReprAtom,ReprArr⟩
  ReprOp ← 1⊑ RR _dispOp_ ("Can't represent block"!0˙)
  Repr ← Type (3≤⊣)◶⟨ReprDat⊢,ReprOp⟩ ⊢

  # Convert Fmt from matrix to string
  ⟨¯1↓·⥊ ∾⟜(@+10)˘∘FmtW, Repr⟩
}
