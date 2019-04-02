# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest, unicode
include eastasianwidth

suite "existsIn":
  test "exist":
    check 1.existsIn(@[0..10])
    check 10.existsIn(@[0..10])
    check 11.existsIn(@[0..10]) == false

suite "eastAsianWidth":
  test "full width":
    check "　".runeAtPos(0).int == 0x3000
    check "　".runeAtPos(0).int.eastAsianWidth == fullWidth
    check "Ａ".runeAtPos(0).int.eastAsianWidth == fullWidth
    check "￠".runeAtPos(0).int.eastAsianWidth == fullWidth
  test "half width":
    discard
    # check ".".runeAtPos(0).int.eastAsianWidth == halfWidth
    # check "|".runeAtPos(0).int.eastAsianWidth == halfWidth
  test "wide":
    check "ㄅ".runeAtPos(0).int.eastAsianWidth == wide
    check "뀀".runeAtPos(0).int.eastAsianWidth == wide
  test "narrow":
    check "¢".runeAtPos(0).int.eastAsianWidth == narrow
    check "⟭".runeAtPos(0).int.eastAsianWidth == narrow
    check "a".runeAtPos(0).int.eastAsianWidth == narrow
  test "ambiguous":
    check "⊙".runeAtPos(0).int.eastAsianWidth == ambiguous
    check "①".runeAtPos(0).int.eastAsianWidth == ambiguous
  test "neutral":
    check "ب".runeAtPos(0).int.eastAsianWidth == neutral
    check "ف".runeAtPos(0).int.eastAsianWidth == neutral

suite "stringWidth":
  test "0 value":
    check "".stringWidth == 0
  test "half width":
    check "a".stringWidth == 1
    check "abcde".stringWidth == 5
    check "12345".stringWidth == 5
  test "full width":
    check "あ".stringWidth == 2
    check "あいうえお".stringWidth == 10
    check "月火水木金".stringWidth == 10
    check "　 ".stringWidth == 3
