# Package

version       = "0.2.2"
author        = "Juan Carlos, Mircea Ilie Ploscaru"
description   = "Nim GUI Automation Linux, simulate user interaction, mouse and keyboard."
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.20.0"


import distros

before install:
  if detectOs(Windows):
    quit("Cannot run on Windows, but you can try Docker for Windows: http://docs.docker.com/docker-for-windows")

  foreignDep "xdo"

  # try:
  #   exec "sh ./check_deps.sh"
  # except:
  #   echo "xdo not found. Aborting..."
  #   quit()
