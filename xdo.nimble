# Package

version       = "0.1.0"
author        = "Juan Carlos"
description   = "Nim GUI Automation Linux, simulate user interaction, mouse and keyboard."
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.19.0"

before install:
  try:
    exec "sh ./check_deps.sh"
  except:
    echo "xdo not found. Aborting..."
    quit()