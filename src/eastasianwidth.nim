## This module provides functions to solve 'East Asian Width' problems. 
## This functions help to create text base UI.
##
## Usage example
## =============
##
## Text align right with multibyte string.
## 
## TODO
##
## References:
## * https://ja.wikipedia.org/wiki/%E6%9D%B1%E3%82%A2%E3%82%B8%E3%82%A2%E3%81%AE%E6%96%87%E5%AD%97%E5%B9%85
## * http://www.unicode.org/Public/UCD/latest/ucd/EastAsianWidth.txt
## * http://www.unicode.org/reports/tr11/
## * https://github.com/mattn/go-runewidth
## * https://github.com/komagata/eastasianwidth

import unicode
from sequtils import mapIt, foldr

type EastAsianWidth* = enum
  fullWidth = "F"
  halfWidth = "H"
  wide = "W"
  narrow = "Na"
  ambiguous = "A"
  neutral = "N"

let fullWidthRange = @[
  0x3000..0x3000,
  0xFF01..0xFF60,
  0xFFE0..0xFFE6,
]

let halfWidthRange = @[
  0x20A9..0x20A9,
  0xFF61..0xFFBE,
  0xFFC2..0xFFC7,
  0xFFCA..0xFFCF,
  0xFFD2..0xFFD7,
  0xFFDA..0xFFDC,
  0xFFE8..0xFFEE,
]

let wideWidthRange = @[
  0x1100..0x115F,
  0x11A3..0x11A7,
  0x11FA..0x11FF,
  0x2329..0x232A,
  0x2E80..0x2E99,
  0x2E9B..0x2EF3,
  0x2F00..0x2FD5,
  0x2FF0..0x2FFB,
  0x3001..0x303E,
  0x3041..0x3096,
  0x3099..0x30FF,
  0x3105..0x312D,
  0x3131..0x318E,
  0x3190..0x31BA,
  0x31C0..0x31E3,
  0x31F0..0x321E,
  0x3220..0x3247,
  0x3250..0x32FE,
  0x3300..0x4DBF,
  0x4E00..0xA48C,
  0xA490..0xA4C6,
  0xA960..0xA97C,
  0xAC00..0xD7A3,
  0xD7B0..0xD7C6,
  0xD7CB..0xD7FB,
  0xF900..0xFAFF,
  0xFE10..0xFE19,
  0xFE30..0xFE52,
  0xFE54..0xFE66,
  0xFE68..0xFE6B,
  0x1B000..0x1B001,
  0x1F200..0x1F202,
  0x1F210..0x1F23A,
  0x1F240..0x1F248,
  0x1F250..0x1F251,
  0x20000..0x2F73F,
  0x2B740..0x2FFFD,
  0x30000..0x3FFFD,
]

let narrowWidthRange = @[
  0x0020..0x007E,
  0x00A2..0x00A3,
  0x00A5..0x00A6,
  0x00AC..0x00AC,
  0x00AF..0x00AF,
  0x27E6..0x27ED,
  0x2985..0x2986,
]

let ambiguousWidthRange = @[
  0x00A1..0x00A1,
  0x00A4..0x00A4,
  0x00A7..0x00A8,
  0x00AA..0x00AA,
  0x00AD..0x00AE,
  0x00B0..0x00B4,
  0x00B6..0x00BA,
  0x00BC..0x00BF,
  0x00C6..0x00C6,
  0x00D0..0x00D0,
  0x00D7..0x00D8,
  0x00DE..0x00E1,
  0x00E6..0x00E6,
  0x00E8..0x00EA,
  0x00EC..0x00ED,
  0x00F0..0x00F0,
  0x00F2..0x00F3,
  0x00F7..0x00FA,
  0x00FC..0x00FC,
  0x00FE..0x00FE,
  0x0101..0x0101,
  0x0111..0x0111,
  0x0113..0x0113,
  0x011B..0x011B,
  0x0126..0x0127,
  0x012B..0x012B,
  0x0131..0x0133,
  0x0138..0x0138,
  0x013F..0x0142,
  0x0144..0x0144,
  0x0148..0x014B,
  0x014D..0x014D,
  0x0152..0x0153,
  0x0166..0x0167,
  0x016B..0x016B,
  0x01CE..0x01CE,
  0x01D0..0x01D0,
  0x01D2..0x01D2,
  0x01D4..0x01D4,
  0x01D6..0x01D6,
  0x01D8..0x01D8,
  0x01DA..0x01DA,
  0x01DC..0x01DC,
  0x0251..0x0251,
  0x0261..0x0261,
  0x02C4..0x02C4,
  0x02C7..0x02C7,
  0x02C9..0x02CB,
  0x02CD..0x02CD,
  0x02D0..0x02D0,
  0x02D8..0x02DB,
  0x02DD..0x02DD,
  0x02DF..0x02DF,
  0x0300..0x036F,
  0x0391..0x03A1,
  0x03A3..0x03A9,
  0x03B1..0x03C1,
  0x03C3..0x03C9,
  0x0401..0x0401,
  0x0410..0x044F,
  0x0451..0x0451,
  0x2010..0x2010,
  0x2013..0x2016,
  0x2018..0x2019,
  0x201C..0x201D,
  0x2020..0x2022,
  0x2024..0x2027,
  0x2030..0x2030,
  0x2032..0x2033,
  0x2035..0x2035,
  0x203B..0x203B,
  0x203E..0x203E,
  0x2074..0x2074,
  0x207F..0x207F,
  0x2081..0x2084,
  0x20AC..0x20AC,
  0x2103..0x2103,
  0x2105..0x2105,
  0x2109..0x2109,
  0x2113..0x2113,
  0x2116..0x2116,
  0x2121..0x2122,
  0x2126..0x2126,
  0x212B..0x212B,
  0x2153..0x2154,
  0x215B..0x215E,
  0x2160..0x216B,
  0x2170..0x2179,
  0x2189..0x2189,
  0x2190..0x2199,
  0x21B8..0x21B9,
  0x21D2..0x21D2,
  0x21D4..0x21D4,
  0x21E7..0x21E7,
  0x2200..0x2200,
  0x2202..0x2203,
  0x2207..0x2208,
  0x220B..0x220B,
  0x220F..0x220F,
  0x2211..0x2211,
  0x2215..0x2215,
  0x221A..0x221A,
  0x221D..0x2220,
  0x2223..0x2223,
  0x2225..0x2225,
  0x2227..0x222C,
  0x222E..0x222E,
  0x2234..0x2237,
  0x223C..0x223D,
  0x2248..0x2248,
  0x224C..0x224C,
  0x2252..0x2252,
  0x2260..0x2261,
  0x2264..0x2267,
  0x226A..0x226B,
  0x226E..0x226F,
  0x2282..0x2283,
  0x2286..0x2287,
  0x2295..0x2295,
  0x2299..0x2299,
  0x22A5..0x22A5,
  0x22BF..0x22BF,
  0x2312..0x2312,
  0x2460..0x24E9,
  0x24EB..0x254B,
  0x2550..0x2573,
  0x2580..0x258F,
  0x2592..0x2595,
  0x25A0..0x25A1,
  0x25A3..0x25A9,
  0x25B2..0x25B3,
  0x25B6..0x25B7,
  0x25BC..0x25BD,
  0x25C0..0x25C1,
  0x25C6..0x25C8,
  0x25CB..0x25CB,
  0x25CE..0x25D1,
  0x25E2..0x25E5,
  0x25EF..0x25EF,
  0x2605..0x2606,
  0x2609..0x2609,
  0x260E..0x260F,
  0x2614..0x2615,
  0x261C..0x261C,
  0x261E..0x261E,
  0x2640..0x2640,
  0x2642..0x2642,
  0x2660..0x2661,
  0x2663..0x2665,
  0x2667..0x266A,
  0x266C..0x266D,
  0x266F..0x266F,
  0x269E..0x269F,
  0x26BE..0x26BF,
  0x26C4..0x26CD,
  0x26CF..0x26E1,
  0x26E3..0x26E3,
  0x26E8..0x26FF,
  0x273D..0x273D,
  0x2757..0x2757,
  0x2776..0x277F,
  0x2B55..0x2B59,
  0x3248..0x324F,
  0xE000..0xF8FF,
  0xFE00..0xFE0F,
  0xFFFD..0xFFFD,
  0x1F100..0x1F10A,
  0x1F110..0x1F12D,
  0x1F130..0x1F169,
  0x1F170..0x1F19A,
  0xE0100..0xE01EF,
  0xF0000..0xFFFFD,
  0x100000..0x10FFFD,
]

proc existsIn(i: int, s: seq[HSlice[int,int]]): bool =
  for r in s:
    if i in r:
      return true
  return false

proc eastAsianWidth*(codePoint: int): EastAsianWidth =
  ## eastAsianWidth returns EastAsianWidth of code point.
  runnableExamples:
    doAssert 0x3000.eastAsianWidth == fullWidth
    doAssert "　".runeAtPos(0).int.eastAsianWidth == fullWidth
  if codePoint.existsIn fullWidthRange:
    return fullWidth
  if codePoint.existsIn halfWidthRange:
    return halfWidth
  if codePoint.existsIn wideWidthRange:
    return wide
  if codePoint.existsIn narrowWidthRange:
    return narrow
  if codePoint.existsIn ambiguousWidthRange:
    return ambiguous
  return neutral

proc runeLen(e: EastAsianWidth): int =
  result = case e
           of fullWidth, wide, ambiguous: 2
           else: 1

proc stringWidth*(s: string): int =
  ## stringWidth returns text looks width.
  runnableExamples:
    doAssert "".stringWidth == 0
    doAssert "abcde".stringWidth == 5
    doAssert "あいうえお".stringWidth == 10
  let runes = s.toRunes
  if runes.len < 1:
    return 0
  result = runes.mapIt(it.int.eastAsianWidth.runeLen).foldr(a + b)
