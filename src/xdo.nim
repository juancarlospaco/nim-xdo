## Nim-Xdo
## =======
##
## - Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.
##
## .. image:: https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg
from strutils import repeat
when not defined(linux): {.warning: "ERROR: XDo is only available for Linux.".}

type XDoActions* = enum
  closeFocusedWindow       = "xdo close -c;"
  hideFocusedWindow        = "xdo hide -c;"
  showFocusedWindow        = "xdo show -c;"
  raiseFocusedWindow       = "xdo raise -c;"
  lowerFocusedWindow       = "xdo lower -c;"
  hideAllButFocusedWindow  = "xdo hide -dr;"
  closeAllButFocusedWindow = "xdo close -dr;"
  raiseAllButFocusedWindow = "xdo raise -dr;"
  lowerAllButFocusedWindow = "xdo lower -dr;"
  showAllButFocusedWindow  = "xdo show -dr;"
  moveMouseTopLeft         = "xdo pointer_motion -x 0 -y 0;"
  mouseLeftClick           = "xdo button_press -k 1;xdo button_release -k 1;"
  mouseMiddleClick         = "xdo button_press -k 2;xdo button_release -k 2;"
  mouseRightClick          = "xdo button_press -k 3;xdo button_release -k 3;"
  mouseDoubleLeftClick     = "xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"
  mouseDoubleMiddleClick   = "xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;"
  mouseDoubleRightClick    = "xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;"
  mouseTripleLeftClick     = "xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"
  mouseTripleMiddleClick   = "xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;"
  mouseTripleRightClick    = "xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;"
  keyBackspace    = "xdo key_press -k 8;xdo key_release -k 8;"
  keyTab          = "xdo key_press -k 9;xdo key_release -k 9;"
  keyEnter        = "xdo key_press -k 13;xdo key_release -k 13;"
  keyShift        = "xdo key_press -k 16;xdo key_release -k 16;"
  keyCtrl         = "xdo key_press -k 17;xdo key_release -k 17;"
  keyCtrlEnter    = "xdo key_press -k 17;xdo key_press -k 36;xdo key_release -k 17;xdo key_release -k 36;"
  keyAlt          = "xdo key_press -k 18;xdo key_release -k 18;"
  keyPause        = "xdo key_press -k 19;xdo key_release -k 19;"
  keyCapslock     = "xdo key_press -k 20;xdo key_release -k 20;"
  keyEsc          = "xdo key_press -k 27;xdo key_release -k 27;"
  keySpace        = "xdo key_press -k 32;xdo key_release -k 32;"
  keyPageup       = "xdo key_press -k 33;xdo key_release -k 33;"
  keyPagedown     = "xdo key_press -k 34;xdo key_release -k 34;"
  keyEnd          = "xdo key_press -k 35;xdo key_release -k 35;"
  keyHome         = "xdo key_press -k 36;xdo key_release -k 36;"
  keyArrowLeft    = "xdo key_press -k 37;xdo key_release -k 37;"
  keyArrowUp      = "xdo key_press -k 38;xdo key_release -k 38;"
  keyArrowRight   = "xdo key_press -k 39;xdo key_release -k 39;"
  keyArrowDown    = "xdo key_press -k 40;xdo key_release -k 40;"
  keyInsert       = "xdo key_press -k 45;xdo key_release -k 45;"
  keyDelete       = "xdo key_press -k 46;xdo key_release -k 46;"
  keyNumlock      = "xdo key_press -k 144;xdo key_release -k 144;"
  keyScrolllock   = "xdo key_press -k 145;xdo key_release -k 145;"
  keyMycomputer   = "xdo key_press -k 182;xdo key_release -k 182;"
  keyMycalculator = "xdo key_press -k 183;xdo key_release -k 183;"
  keyWindows      = "xdo key_press -k 91;xdo key_release -k 91;"
  keyRightclick   = "xdo key_press -k 93;xdo key_release -k 93;"
  keyNumpad0      = "xdo key_press -k 96;xdo key_release -k 96;"
  keyNumpad1      = "xdo key_press -k 97;xdo key_release -k 97;"
  keyNumpad2      = "xdo key_press -k 98;xdo key_release -k 98;"
  keyNumpad3      = "xdo key_press -k 99;xdo key_release -k 99;"
  keyNumpad4      = "xdo key_press -k 100;xdo key_release -k 100;"
  keyNumpad5      = "xdo key_press -k 101;xdo key_release -k 101;"
  keyNumpad6      = "xdo key_press -k 102;xdo key_release -k 102;"
  keyNumpad7      = "xdo key_press -k 103;xdo key_release -k 103;"
  keyNumpad8      = "xdo key_press -k 104;xdo key_release -k 104;"
  keyNumpad9      = "xdo key_press -k 105;xdo key_release -k 105;"
  keyNumpadAsterisk = "xdo key_press -k 106;xdo key_release -k 106;"
  keyNumpadPlus   = "xdo key_press -k 107;xdo key_release -k 107;"
  keyNumpadMinus  = "xdo key_press -k 109;xdo key_release -k 109;"
  keyNumpadDot    = "xdo key_press -k 110;xdo key_release -k 110;"
  keyNumpadSlash  = "xdo key_press -k 111;xdo key_release -k 111;"
  keyF1           = "xdo key_press -k 112;xdo key_release -k 112;"
  keyF2           = "xdo key_press -k 113;xdo key_release -k 113;"
  keyF3           = "xdo key_press -k 114;xdo key_release -k 114;"
  keyF4           = "xdo key_press -k 115;xdo key_release -k 115;"
  keyF5           = "xdo key_press -k 116;xdo key_release -k 116;"
  keyF6           = "xdo key_press -k 117;xdo key_release -k 117;"
  keyF7           = "xdo key_press -k 118;xdo key_release -k 118;"
  keyF8           = "xdo key_press -k 119;xdo key_release -k 119;"
  keyF9           = "xdo key_press -k 120;xdo key_release -k 120;"
  keyF10          = "xdo key_press -k 121;xdo key_release -k 121;"
  keyF11          = "xdo key_press -k 122;xdo key_release -k 122;"
  keyF12          = "xdo key_press -k 123;xdo key_release -k 123;"
  key0            = "xdo key_press -k 48;xdo key_release -k 48;"
  key1            = "xdo key_press -k 49;xdo key_release -k 49;"
  key2            = "xdo key_press -k 50;xdo key_release -k 50;"
  key3            = "xdo key_press -k 51;xdo key_release -k 51;"
  key4            = "xdo key_press -k 52;xdo key_release -k 52;"
  key5            = "xdo key_press -k 53;xdo key_release -k 53;"
  key6            = "xdo key_press -k 54;xdo key_release -k 54;"
  key7            = "xdo key_press -k 55;xdo key_release -k 55;"
  key8            = "xdo key_press -k 56;xdo key_release -k 56;"
  key9            = "xdo key_press -k 57;xdo key_release -k 57;"
  # Left Click, CTRL + a, Delete
  clickCtrlADelete = "xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 17;xdo button_press -k 38;xdo button_release -k 38;xdo key_release -k 17;xdo key_press -k 8;xdo key_release -k 8;"
  # CTRL + Shift + i
  ctrlShiftI      = "xdo key_press -k 17;xdo key_press -k 16;xdo key_press -k 31;xdo key_release -k 31;xdo key_release -k 16;xdo key_release -k 17;"
  # CTRL + f, Delete
  ctrlFDelete     = "xdo key_press -k 17;xdo button_press -k 41;xdo key_release -k 41;xdo key_release -k 17;xdo key_press -k 8;xdo key_release -k 8;"

template withShift(s: static[string]): static[string] =
  "xdo key_press -k 16;" & s & "xdo key_release -k 16;"  # Same Key + Shift

func toCmd*(c: char): string {.noinline.} =
  # https://gist.github.com/rickyzhang82/8581a762c9f9fc6ddb8390872552c250#file-keycode-linux-L33-L137
  case c      # Hard to find the correct values for those keycodes, mac and windows differ too. :(
  of '1':  "xdo key_press -k 10;xdo key_release -k 10;"
  of '2':  "xdo key_press -k 11;xdo key_release -k 11;"
  of '3':  "xdo key_press -k 12;xdo key_release -k 12;"
  of '4':  "xdo key_press -k 13;xdo key_release -k 13;"
  of '5':  "xdo key_press -k 14;xdo key_release -k 14;"
  of '6':  "xdo key_press -k 15;xdo key_release -k 15;"
  of '7':  "xdo key_press -k 16;xdo key_release -k 16;"
  of '8':  "xdo key_press -k 17;xdo key_release -k 17;"
  of '9':  "xdo key_press -k 18;xdo key_release -k 18;"
  of '0':  "xdo key_press -k 19;xdo key_release -k 19;"
  of '-':  "xdo key_press -k 20;xdo key_release -k 20;"
  of '=':  "xdo key_press -k 21;xdo key_release -k 21;"
  of '\t': "xdo key_press -k 23;xdo key_release -k 23;"
  of 'q':  "xdo key_press -k 24;xdo key_release -k 24;"
  of 'w':  "xdo key_press -k 25;xdo key_release -k 25;"
  of 'e':  "xdo key_press -k 26;xdo key_release -k 26;"
  of 'r':  "xdo key_press -k 27;xdo key_release -k 27;"
  of 't':  "xdo key_press -k 28;xdo key_release -k 28;"
  of 'y':  "xdo key_press -k 29;xdo key_release -k 29;"
  of 'u':  "xdo key_press -k 30;xdo key_release -k 30;"
  of 'i':  "xdo key_press -k 31;xdo key_release -k 31;"
  of 'o':  "xdo key_press -k 32;xdo key_release -k 32;"
  of 'p':  "xdo key_press -k 33;xdo key_release -k 33;"
  of '[':  "xdo key_press -k 34;xdo key_release -k 34;"
  of ']':  "xdo key_press -k 35;xdo key_release -k 35;"
  of '\n': "xdo key_press -k 36;xdo key_release -k 36;"
  of 'a':  "xdo key_press -k 38;xdo key_release -k 38;"
  of 's':  "xdo key_press -k 39;xdo key_release -k 39;"
  of 'd':  "xdo key_press -k 40;xdo key_release -k 40;"
  of 'f':  "xdo key_press -k 41;xdo key_release -k 41;"
  of 'g':  "xdo key_press -k 42;xdo key_release -k 42;"
  of 'h':  "xdo key_press -k 43;xdo key_release -k 43;"
  of 'j':  "xdo key_press -k 44;xdo key_release -k 44;"
  of 'k':  "xdo key_press -k 45;xdo key_release -k 45;"
  of 'l':  "xdo key_press -k 46;xdo key_release -k 46;"
  of ';':  "xdo key_press -k 47;xdo key_release -k 47;"
  of '\'': "xdo key_press -k 48;xdo key_release -k 48;"
  of '`':  "xdo key_press -k 49;xdo key_release -k 49;"
  of '\\': "xdo key_press -k 51;xdo key_release -k 51;"
  of 'z':  "xdo key_press -k 52;xdo key_release -k 52;"
  of 'x':  "xdo key_press -k 53;xdo key_release -k 53;"
  of 'c':  "xdo key_press -k 54;xdo key_release -k 54;"
  of 'v':  "xdo key_press -k 55;xdo key_release -k 55;"
  of 'b':  "xdo key_press -k 56;xdo key_release -k 56;"
  of 'n':  "xdo key_press -k 57;xdo key_release -k 57;"
  of 'm':  "xdo key_press -k 58;xdo key_release -k 58;"
  of ',':  "xdo key_press -k 59;xdo key_release -k 59;"
  of '.':  "xdo key_press -k 60;xdo key_release -k 60;"
  of '/':  "xdo key_press -k 61;xdo key_release -k 61;"
  of '*':  "xdo key_press -k 63;xdo key_release -k 63;"
  of ' ':  "xdo key_press -k 65;xdo key_release -k 65;"
  of '+':  "xdo key_press -k 86;xdo key_release -k 86;"
  of '<':  "xdo key_press -k 94;xdo key_release -k 94;"
  of '{':  withShift"xdo key_press -k 34;xdo key_release -k 34;"
  of '}':  withShift"xdo key_press -k 35;xdo key_release -k 35;"
  of '_':  withShift"xdo key_press -k 20;xdo key_release -k 20;"
  of '"':  withShift"xdo key_press -k 48;xdo key_release -k 48;"
  of '~':  withShift"xdo key_press -k 49;xdo key_release -k 49;"
  of '|':  withShift"xdo key_press -k 51;xdo key_release -k 51;"
  of '>':  withShift"xdo key_press -k 60;xdo key_release -k 60;"
  of '!':  withShift"xdo key_press -k 10;xdo key_release -k 10;"
  of '@':  withShift"xdo key_press -k 11;xdo key_release -k 11;"
  of '#':  withShift"xdo key_press -k 12;xdo key_release -k 12;"
  of '$':  withShift"xdo key_press -k 13;xdo key_release -k 13;"
  of '%':  withShift"xdo key_press -k 14;xdo key_release -k 14;"
  of '^':  withShift"xdo key_press -k 15;xdo key_release -k 15;"
  of '&':  withShift"xdo key_press -k 16;xdo key_release -k 16;"
  of '(':  withShift"xdo key_press -k 18;xdo key_release -k 18;"
  of ')':  withShift"xdo key_press -k 19;xdo key_release -k 19;"
  of '?':  withShift"xdo key_press -k 61;xdo key_release -k 61;"
  of ':':  withShift"xdo key_press -k 47;xdo key_release -k 47;"
  of 'Q':  withShift"xdo key_press -k 24;xdo key_release -k 24;"
  of 'W':  withShift"xdo key_press -k 25;xdo key_release -k 25;"
  of 'E':  withShift"xdo key_press -k 26;xdo key_release -k 26;"
  of 'R':  withShift"xdo key_press -k 27;xdo key_release -k 27;"
  of 'T':  withShift"xdo key_press -k 28;xdo key_release -k 28;"
  of 'Y':  withShift"xdo key_press -k 29;xdo key_release -k 29;"
  of 'U':  withShift"xdo key_press -k 30;xdo key_release -k 30;"
  of 'I':  withShift"xdo key_press -k 31;xdo key_release -k 31;"
  of 'O':  withShift"xdo key_press -k 32;xdo key_release -k 32;"
  of 'P':  withShift"xdo key_press -k 33;xdo key_release -k 33;"
  of 'A':  withShift"xdo key_press -k 38;xdo key_release -k 38;"
  of 'S':  withShift"xdo key_press -k 39;xdo key_release -k 39;"
  of 'D':  withShift"xdo key_press -k 40;xdo key_release -k 40;"
  of 'F':  withShift"xdo key_press -k 41;xdo key_release -k 41;"
  of 'G':  withShift"xdo key_press -k 42;xdo key_release -k 42;"
  of 'H':  withShift"xdo key_press -k 43;xdo key_release -k 43;"
  of 'J':  withShift"xdo key_press -k 44;xdo key_release -k 44;"
  of 'K':  withShift"xdo key_press -k 45;xdo key_release -k 45;"
  of 'L':  withShift"xdo key_press -k 46;xdo key_release -k 46;"
  of 'Z':  withShift"xdo key_press -k 52;xdo key_release -k 52;"
  of 'X':  withShift"xdo key_press -k 53;xdo key_release -k 53;"
  of 'C':  withShift"xdo key_press -k 54;xdo key_release -k 54;"
  of 'V':  withShift"xdo key_press -k 55;xdo key_release -k 55;"
  of 'B':  withShift"xdo key_press -k 56;xdo key_release -k 56;"
  of 'N':  withShift"xdo key_press -k 57;xdo key_release -k 57;"
  of 'M':  withShift"xdo key_press -k 58;xdo key_release -k 58;"
  of '\0': ""
  else:    ""

func toCmd*(actions: openArray[XDoActions]): string =
  for action in actions: result.add $action

func toCmd*(actions: openArray[char]): string =
  for action in actions: result.add toCmd(action)

template getPid*(): string =
  ## Get Process ID.
  "xdo pid;"

template getId*(): string =
  ## Get Window ID.
  "xdo id;"

template move_mouse*(x, y: string or int): string =
  ## Move mouse to move position pixel coordinates (X, Y).
  "xdo pointer_motion -x " & $x & " -y " & $y & ';'

template move_window*(x, y: string or int; pid: Positive): string =
  ## Move window to move position pixel coordinates (X, Y).
  "xdo move -x " & $x & " -y " & $y & " -p " & $pid & ';'

template resize_window*(x, y: string or int; pid: Positive): string =
  ## Resize window up to move position pixel coordinates (X, Y).
  "xdo resize -w " & $x & " -h " & $y & " -p " & $pid & ';'

template activate_this_window*(pid: Positive): string =
  ## Force to Activate this window by PID.
  "xdo activate -p " & $pid & ";"

template move_mouse_top_100px*(repetitions: Positive): string =
  ## Move mouse to Top Y=0, then repeat move Bottom on jumps of 100px each.
  "xdo pointer_motion -y 0;" & "xdo pointer_motion -y +100;".repeat(repetitions)

template move_mouse_left_100px*(repetitions: Positive): string =
  ## Move mouse to Left X=0, then repeat move Right on jumps of 100px each.
  "xdo pointer_motion -x 0;" & "xdo pointer_motion -x +100;".repeat(repetitions)

proc mouse_move_alternating*(x, y: string or int; repetitions = 1.Positive): string {.inline.} =
  ## Move mouse alternating to Left/Right Up/Down, AKA Zig-Zag movements.
  for i in 0..repetitions: result.add "xdo pointer_motion -x " & $(if i mod 2 == 0: "+" else: "-" & $x) & " -y " & $(if i mod 2 == 0: "+" else: "-" & $y) & ';'

template mouse_spamm_left_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Left Click as fast as possible.
  "xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions)

template mouse_spamm_middle_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Middle Click as fast as possible.
  "xdo button_press -k 2;xdo button_release -k 2;".repeat(repetitions)

template mouse_spamm_right_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Right Click as fast as possible.
  "xdo button_press -k 3;xdo button_release -k 3;".repeat(repetitions)

template mouse_swipe_horizontal*(x: string or int): string =
  ## Mouse Swipe to Left or Right, Hold Left Click+Drag Horizontally+Release Left Click.
  "xdo button_press -k 1;xdo pointer_motion -x " & $x & ";xdo button_release -k 1;"

template mouse_swipe_vertical*(y: string or int): string =
  ## Mouse Swipe to Up or Down, Hold Left Click+Drag Vertically+Release Left Click.
  "xdo button_press -k 1;xdo pointer_motion -y " & $y & ";xdo button_release -k 1;"

template key_wasd*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,A,S,D as fast as possible (in games,make circles).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 65;xdo key_release -k 65;xdo key_press -k 83;xdo key_release -k 83;xdo key_press -k 68;xdo key_release -k 68;".repeat(repetitions)

template key_spamm_space*(repetitions = 1.Positive): string =
  ## Keyboard Key Space as fast as possible (in games,bunny hop).
  "xdo key_press -k 32;xdo key_release -k 32;".repeat(repetitions)

template key_w_click*(repetitions = 1.Positive): string =
  ## Keyboard Key W and Mouse Left Click as fast as possible (in games,forward+hit).
  "xdo key_press -k 87;xdo key_release -k 87;xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions)

template key_w_space*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,Space as fast as possible (in games, forward+jump).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 32;xdo key_release -k 32;".repeat(repetitions)

template key_w_space_click*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,Space and Mouse Left Click (in games, forward+jump+hit).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 32;xdo key_release -k 32;xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions)

template key_w_e*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,E as fast as possible (in games, forward+use).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 69;xdo key_release -k 69;".repeat(repetitions)

proc key_numbers_click*(repetitions = 1.Positive): string {.inline.} =
  ## This function types the keys like: 1,10clicks,2,10clicks,3,10clicks,etc up to 9 (in games, shoot weapons 1 to 9).
  for _ in 0..repetitions: result.add "xdo key_press -k 49;xdo key_release -k 49;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 50;xdo key_release -k 50;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 51;xdo key_release -k 51;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 52;xdo key_release -k 52;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 53;xdo key_release -k 53;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 54;xdo key_release -k 54;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 55;xdo key_release -k 55;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 56;xdo key_release -k 56;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 57;xdo key_release -k 57;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"


runnableExamples:
  ## XDo works on Linux OS.
  when defined(linux):
    ## Basic example of mouse and keyboard control from code.
    import strutils
    echo get_id()
    echo get_pid()
    echo move_mouse(x = "+99", y = "+99")
    echo move_mouse_left_100px(2)
    echo move_mouse_top_100px(2)
    echo mouse_move_alternating(x = 9, y = 5, 3)
    # echo key_0()
    # echo key_1()
    # echo key_2()
    # echo key_3()
    # echo key_4()
    # echo key_5()
    # echo key_6()
    # echo key_7()
    # echo key_8()
    # echo key_9()
    # echo hide_all_but_focused_window()
    # echo hide_focused_window()
