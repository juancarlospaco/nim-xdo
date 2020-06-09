version       = "0.2.5"
author        = "Juan Carlos, Mircea Ilie Ploscaru"
description   = "Nim GUI Automation Linux, simulate user interaction, mouse and keyboard."
license       = "MIT"
srcDir        = "src"

requires "nim >= 1.2.0"


import distros

before install:
  foreignDep "xdo"
