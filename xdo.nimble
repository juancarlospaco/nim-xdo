version     = "0.9.0"
author      = "Juan Carlos, Mircea Ilie Ploscaru"
description = "Nim GUI Automation Linux, simulate user interaction, mouse and keyboard."
license     = "MIT"
srcDir      = "src"
requires "nim >= 1.4.0"

import distros

before install:
  foreignDep "xdo"
