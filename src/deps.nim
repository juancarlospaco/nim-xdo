from os import execShellCmd
from strutils import strip, toLowerAscii

template run(cmd) =
  try:
    discard execShellCmd(cmd)
  except:
    echo "ERR: Something went wrong..."
    quit(1)

let xdo_exists* = execShellCmd("hash xdo 2> /dev/null")
let git_exists* = execShellCmd("hash git 2> /dev/null")

# Feel free to add any extra distros which have xdo in their native repositories
type
  Distro* = enum
    Arch
    Ubuntu
    Other

let curr_distro =
  if execShellCmd("hash pacman 2> /dev/null"):
    return Arch

  elif execShellCmd("hash apt-get 2> /dev/null"):
    return Ubuntu
  
  else:
    return Other

proc install_xdo* =
  write(stdout, "Do you want to install xdo? (y/n) ")

  let input = readLine(stdin).strip.toLowerAscii
  if input.contains "n":
    quit(1)

  var install:string
  case curr_distro:
    of Arch:
      install = "sudo pacman -Sy xdo"

    of Ubuntu:
      install = "sudo apt-get install -y xdo"

    of Other:
      if git_exists != 1:
        echo "ERR: git not found"
        quit(1)

      let clone_repo = "git clone -q https://github.com/baskerville/xdo;"
      let enter_dir = "cd xdo;"
      let make_install = "make > /dev/null; sudo make install > /dev/null;" 
      let cleanup = "cd ..; rm -rf xdo;"
      install = clone_repo & enter_dir & make_install & cleanup

  run(install)
