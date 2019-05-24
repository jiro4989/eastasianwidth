# Package

version       = "1.1.0"
author        = "jiro4989"
description   = "eastasianwidth is library for EastAsianWidth."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.0"

task docs, "Generate document":
  exec "nimble doc src/eastasianwidth.nim -o:docs/eastasianwidth.html"

task examples, "Run example codes":
  exec "nim c -r examples/table.nim"

task ci, "Run CI tasks":
  exec "nimble test"
  exec "nimble docs"
  exec "nimble examples"
