## Half width characters and Full width characters exist.
## This example prints padded texts.

import eastasianwidth
from sequtils import mapIt
from strformat import `&`
from strutils import repeat

let
  records = @["Google", "グーグル",
              "Apple", "アップル",
              "Facebook", "フェイスブック",
              "Amazon", "アマゾン",
              "Twitter", "ツイッター",
              "Oracle", "オラクル"]
  indexWidth = records.len.`$`.len
  valueWidth = records.mapIt(it.stringWidth).max

for i, v in records:
  let
    iPad = " ".repeat(indexWidth - i.`$`.len)
    vPad = " ".repeat(valueWidth - v.stringWidth)
  echo &"| {iPad}{i} | {v}{vPad} |"

## Output:
## |  0 | Google         |
## |  1 | グーグル       |
## |  2 | Apple          |
## |  3 | アップル       |
## |  4 | Facebook       |
## |  5 | フェイスブック |
## |  6 | Amazon         |
## |  7 | アマゾン       |
## |  8 | Twitter        |
## |  9 | ツイッター     |
## | 10 | Oracle         |
## | 11 | オラクル       |
