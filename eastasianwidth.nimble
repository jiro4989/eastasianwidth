# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "eastasianwidth is library for EastAsianWidth."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.0"

task docs, "Generate document":
  exec "nimble doc src/eastasianwidth.nim -o:doc/html/eastasianwidth.html"

