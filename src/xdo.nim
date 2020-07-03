## Nim-Xdo
## =======
##
## - Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.
##
## .. image:: https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg

import os, osproc, strutils, random, tables

when not defined(linux): quit("ERROR: XDo is only available for Linux.")
const
  xdo_version* = staticExec("xdo -v")  ## XDo Version (SemVer) when compiled.
  char2keycode* = {
    "A":65,"B":66,"C":67,"D":68,"E":69,"F":70,"G":71,"H":72,"I":73,"J":74,
    "K":75,"L":76,"M":77,"N":78,"O":78,"P":80,"Q":81,"R":82,"S":83,"U":85,
    "V":86,"W":87,"X":88,"Y":89,"Z":90,"0":48,"1":49,"2":50,"3":51,"4":52,
    "5":53,"6":54,"7":55,"8":56,"9":57,"a":65,"b":66,"c":67,"d":68,"e":69,
    "f":70,"g":71,"h":72,"i":73,"j":74,"k":75,"l":76,"m":77,"n":78,"o":79,
    "p":80,"q":81,"r":82,"s":83,"t":84,"u":85,"v":86,"w":87,"x":88,"y":89,
    "z":90," ":32,";":186,"=":187,",":188,"-":189,".":190,"/":191,"`":192,
    "[":219,"\\":220,"]":221,"'":222
  }.toTable  ## Statically compiled JSON that maps Keys strings Versus KeyCodes integers.
  keycode2char* = {
    "8":"backspace","9":"tab","13":"enter","16":"shift","17":"ctrl","18":"alt",
    "19":"pause/break","20":"caps lock","27":"esc","32":"space","33":"page up",
    "34":"page down","35":"end","36":"home","37":"left","38":"up","39":"right",
    "40":"down","45":"insert","46":"delete","48":"0","49":"1","50":"2","51":"3",
    "52":"4","53":"5","54":"6","55":"7","56":"8","57":"9","65":"a","66":"b",
    "67":"c","68":"d","69":"e","70":"f","71":"g","72":"h","73":"i","74":"j",
    "75":"k","76":"l","77":"m","78":"n","79":"o","80":"p","81":"q","82":"r",
    "83":"s","84":"t","85":"u","86":"v","87":"w","88":"x","89":"y","90":"z","91":"windows",
    "93":"right click","96":"numpad 0","97":"numpad 1","98":"numpad 2",
    "99":"numpad 3","100":"numpad 4","101":"numpad 5","102":"numpad 6",
    "103":"numpad 7","104":"numpad 8","105":"numpad 9","106":"numpad *",
    "107":"numpad +","109":"numpad -","110":"numpad .","111":"numpad /",
    "112":"f1","113":"f2","114":"f3","115":"f4","116":"f5","117":"f6",
    "118":"f7","119":"f8","120":"f9","121":"f10","122":"f11","123":"f12",
    "144":"num lock","145":"scroll lock","182":"my computer",
    "183":"my calculator","186":";","187":"=","188":",","189":"-","190":".",
    "191":"/","192":"`","219":"[","220":"\\","221":"]","222":"'"
  }.toTable  ## Statically compiled JSON that maps KeyCodes integers Versus Keys strings.
  valid_actions* = [
   "close",           ## Close the window.
    "kill",           ## Kill the client.
    "hide",           ## Unmap the window.
    "show",           ## Map the window.
    "raise",          ## Raise the window.
    "lower",          ## Lower the window.
    "below",          ## Put the window below the target.
    "above",          ## Put the window above the target.
    "move",           ## Move the window.
    "resize",         ## Resize the window.
    "activate",       ## Activate the window.
    "id",             ## Print the window’s ID.
    "pid",            ## Print the window PID.
    "key_press",      ## Simulate a key press event.
    "key_release",    ## Simulate a key release event.
    "button_press",   ## Simulate a button press event.
    "button_release", ## Simulate a button release event.
    "pointer_motion", ## Simulate a pointer motion event.
  ]  ## Static list of all XDo Valid Actions as strings.


template xdo*(action: string, move: tuple[x: string, y: string] = (x: "0", y: "0"),
          instance_name = "", class_name = "", wm_name = "", pid = 0,
          wait4window = false, same_desktop = true, same_class = true, same_id = true): tuple[output: TaintedString, exitCode: int] =
  ## XDo proc is a very low level wrapper for XDo for advanced developers, almost all arguments are supported.
  assert action in valid_actions, "Invalid argument for Action, must be one of " & $valid_actions
  execCmdEx((
    "xdo " & action & " -" &
    (if wait4window: "m" else: "") &
    (if same_id: "" else: "r") &
    (if same_desktop: 'd' else: 'D') &
    (if same_class: 'c' else: 'C') &
    (if instance_name != "": " -n " & $instance_name & " " else: "") &
    (if class_name != "": " -N " & $class_name & " " else: "") &
    (if wm_name != "": " -a " & $wm_name & " " else: "") &
    (if pid != 0: " -p " & $pid & " " else: "") &
    (if move != ("0", "0"): " -x " & $move.x & " -y " & $move.y & " " else: "") & ";"
  ))

template xdo_move_mouse*(move: tuple[x: string, y: string]): tuple[output: TaintedString, exitCode: int] =
  ## Move mouse to move position pixel coordinates (X, Y).
  execCmdEx("xdo pointer_motion -x " & $move.x & " -y " & $move.y)

template xdo_move_window*(move: tuple[x: string, y: string], pid: Positive): tuple[output: TaintedString, exitCode: int] =
  ## Move window to move position pixel coordinates (X, Y).
  execCmdEx("xdo move -x " & $move.x & " -y " & $move.y & " -p " & $pid)

template xdo_resize_window*(move: tuple[x: string, y: string], pid: Positive): tuple[output: TaintedString, exitCode: int] =
  ## Resize window up to move position pixel coordinates (X, Y).
  execCmdEx("xdo resize -w " & $move.x & " -h " & $move.y & " -p " & $pid)

template xdo_close_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Close the current focused window.
  execCmdEx("xdo close -c")

template xdo_hide_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Hide the current focused window. This is NOT Minimize.
  execCmdEx("xdo hide -c")

template xdo_show_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Hide the current focused window. This is NOT Maximize.
  execCmdEx("xdo show -c")

template xdo_raise_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Raise up the current focused window.
  execCmdEx("xdo raise -c")

template xdo_lower_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Lower down the current focused window.
  execCmdEx("xdo lower -c")

template xdo_activate_this_window*(pid: Positive): tuple[output: TaintedString, exitCode: int] =
  ## Force to Activate this window by PID.
  execCmdEx("xdo activate -p " & $pid)

template xdo_hide_all_but_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Hide all other windows but leave the current focused window visible.
  execCmdEx("xdo hide -dr")

template xdo_close_all_but_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Close all other windows but leave the current focused window open.
  execCmdEx("xdo close -dr")

template xdo_raise_all_but_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Raise up all other windows but the current focused window.
  execCmdEx("xdo raise -dr")

template xdo_lower_all_but_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Lower down all other windows but the current focused window.
  execCmdEx("xdo lower -dr")

template xdo_show_all_but_focused_window*(): tuple[output: TaintedString, exitCode: int] =
  ## Show all other windows but the current focused window.
  execCmdEx("xdo show -dr")

template xdo_move_mouse_top_left*(): tuple[output: TaintedString, exitCode: int] =
  ## Move mouse to Top Left limits (X=0, Y=0).
  execCmdEx("xdo pointer_motion -x 0 -y 0")

proc xdo_move_mouse_random*(maxx = 1024, maxy = 768, repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Move mouse to Random positions, repeat 0 to repetitions times.
  let cmd = create(string, sizeOf string)
  for i in 0..repetitions: cmd[].add "xdo pointer_motion -x " & $rand(maxx) & " -y " & $rand(maxy)
  result = execCmdEx(cmd[])
  dealloc cmd

template xdo_move_window_random*(pid: Positive, maxx = 1024, maxy = 768): tuple[output: TaintedString, exitCode: int] =
  ## Move Window to Random positions.
  execCmdEx("xdo move -x " & $maxx.rand & " -y " & $maxy.rand & " -p " & $pid)

proc xdo_move_mouse_top_100px*(repetitions: Positive): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Move mouse to Top Y=0, then repeat move Bottom on jumps of 100px each.
  if likely(execCmdEx("xdo pointer_motion -y 0").exitCode == 0):
    result = execCmdEx("xdo pointer_motion -y +100;".repeat(repetitions))

proc xdo_move_mouse_left_100px*(repetitions: Positive): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Move mouse to Left X=0, then repeat move Right on jumps of 100px each.
  if likely(execCmdEx("xdo pointer_motion -x 0").exitCode == 0):
    result = execCmdEx("xdo pointer_motion -x +100;".repeat(repetitions))

template xdo_get_pid*(): string =
  ## Get PID of a window, integer type.
  execCmdEx("xdo pid").output.strip

template xdo_get_id*(): string =
  ## Get ID of a window, integer type.
  execCmdEx("xdo id").output.strip

proc xdo_mouse_move_alternating*(move: tuple[x: int, y: int], repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Move mouse alternating to Left/Right Up/Down, AKA Zig-Zag movements.
  let cmd = create(string, sizeOf string)
  for i in 0..repetitions:
    cmd[].add "xdo pointer_motion -x " & $(if i mod 2 == 0: "+" else: "-" & $move.x) & " -y " & $(if i mod 2 == 0: "+" else: "-" & $move.y)
  result = execCmdEx(cmd[])
  dealloc cmd

template xdo_mouse_left_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Left Click.
  execCmdEx("xdo button_press -k 1; xdo button_release -k 1")

template xdo_mouse_middle_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Middle Click.
  execCmdEx("xdo button_press -k 2; xdo button_release -k 2")

template xdo_mouse_right_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Right Click.
  execCmdEx("xdo button_press -k 3; xdo button_release -k 3")

template xdo_mouse_double_left_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Double Left Click.
  execCmdEx("xdo button_press -k 1; xdo button_release -k 1; xdo button_press -k 1; xdo button_release -k 1")

template xdo_mouse_double_middle_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Double Middle Click.
  execCmdEx("xdo button_press -k 2; xdo button_release -k 2; xdo button_press -k 2; xdo button_release -k 2")

template xdo_mouse_double_right_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Double Right Click.
  execCmdEx("xdo button_press -k 3; xdo button_release -k 3; xdo button_press -k 3; xdo button_release -k 3")

template xdo_mouse_triple_left_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Triple Left Click.
  execCmdEx("xdo button_press -k 1; xdo button_release -k 1; xdo button_press -k 1; xdo button_release -k 1; xdo button_press -k 1; xdo button_release -k 1")

template xdo_mouse_triple_middle_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Triple Middle Click.
  execCmdEx("xdo button_press -k 2; xdo button_release -k 2; xdo button_press -k 2; xdo button_release -k 2; xdo button_press -k 2; xdo button_release -k 2")

template xdo_mouse_triple_right_click*(): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Triple Right Click.
  execCmdEx("xdo button_press -k 3; xdo button_release -k 3; xdo button_press -k 3; xdo button_release -k 3; xdo button_press -k 3; xdo button_release -k 3")

template xdo_mouse_spamm_left_click*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Spamm Mouse Left Click as fast as possible.
  execCmdEx("xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions))

template xdo_mouse_spamm_middle_click*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Spamm Mouse Middle Click as fast as possible.
  execCmdEx("xdo button_press -k 2;xdo button_release -k 2;".repeat(repetitions))

template xdo_mouse_spamm_right_click*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Spamm Mouse Right Click as fast as possible.
  execCmdEx("xdo button_press -k 3;xdo button_release -k 3;".repeat(repetitions))

template xdo_mouse_swipe_horizontal*(x: string): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Swipe to Left or Right, Hold Left Click+Drag Horizontally+Release Left Click.
  execCmdEx("xdo button_press -k 1;xdo pointer_motion -x " & $x & ";xdo button_release -k 1")

template xdo_mouse_swipe_vertical*(y: string): tuple[output: TaintedString, exitCode: int] =
  ## Mouse Swipe to Up or Down, Hold Left Click+Drag Vertically+Release Left Click.
  execCmdEx("xdo button_press -k 1;xdo pointer_motion -y " & $y & ";xdo button_release -k 1")

template xdo_key_backspace*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Backspace.
  execCmdEx("xdo key_press -k 8; xdo key_release -k 8")

template xdo_key_tab*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Tab.
  execCmdEx("xdo key_press -k 9; xdo key_release -k 9")

template xdo_key_enter*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Enter.
  execCmdEx("xdo key_press -k 13; xdo key_release -k 13")

template xdo_key_shift*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Shift.
  execCmdEx("xdo key_press -k 16; xdo key_release -k 16")

template xdo_key_ctrl*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Ctrl.
  execCmdEx("xdo key_press -k 17; xdo key_release -k 17")

template xdo_key_alt*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Alt.
  execCmdEx("xdo key_press -k 18; xdo key_release -k 18")

template xdo_key_pause*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Pause.
  execCmdEx("xdo key_press -k 19; xdo key_release -k 19")

template xdo_key_capslock*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Caps Lock.
  execCmdEx("xdo key_press -k 20; xdo key_release -k 20")

template xdo_key_esc*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Esc.
  execCmdEx("xdo key_press -k 27; xdo key_release -k 27")

template xdo_key_space*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Space.
  execCmdEx("xdo key_press -k 32; xdo key_release -k 32")

template xdo_key_pageup*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Page Up.
  execCmdEx("xdo key_press -k 33; xdo key_release -k 33")

template xdo_key_pagedown*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Page Down.
  execCmdEx("xdo key_press -k 34; xdo key_release -k 34")

template xdo_key_end*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key End.
  execCmdEx("xdo key_press -k 35; xdo key_release -k 35")

template xdo_key_home*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Home.
  execCmdEx("xdo key_press -k 36; xdo key_release -k 36")

template xdo_key_arrow_left*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Arrow Left.
  execCmdEx("xdo key_press -k 37; xdo key_release -k 37")

template xdo_key_arrow_up*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Arrow Up.
  execCmdEx("xdo key_press -k 38; xdo key_release -k 38")

template xdo_key_arrow_right*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Arrow Right.
  execCmdEx("xdo key_press -k 39; xdo key_release -k 39")

template xdo_key_arrow_down*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Arrow Down.
  execCmdEx("xdo key_press -k 40; xdo key_release -k 40")

template xdo_key_insert*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Insert.
  execCmdEx("xdo key_press -k 45; xdo key_release -k 45")

template xdo_key_delete*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Delete.
  execCmdEx("xdo key_press -k 46; xdo key_release -k 46")

template xdo_key_numlock*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Num Lock.
  execCmdEx("xdo key_press -k 144; xdo key_release -k 144")

template xdo_key_scrolllock*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Scroll Lock.
  execCmdEx("xdo key_press -k 145; xdo key_release -k 145")

template xdo_key_mycomputer*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key My Computer (HotKey thingy of some modern keyboards).
  execCmdEx("xdo key_press -k 182; xdo key_release -k 182")

template xdo_key_mycalculator*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key My Calculator (HotKey thingy of some modern keyboards).
  execCmdEx("xdo key_press -k 183; xdo key_release -k 183")

template xdo_key_windows*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Windows (AKA Meta Key).
  execCmdEx("xdo key_press -k 91; xdo key_release -k 91")

template xdo_key_rightclick*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Right Click (HotKey thingy, fake click from keyboard key).
  execCmdEx("xdo key_press -k 93; xdo key_release -k 93")

template xdo_key_numpad0*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 0.
  execCmdEx("xdo key_press -k 96; xdo key_release -k 96")

template xdo_key_numpad1*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 1.
  execCmdEx("xdo key_press -k 97; xdo key_release -k 97")

template xdo_key_numpad2*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 2.
  execCmdEx("xdo key_press -k 98; xdo key_release -k 98")

template xdo_key_numpad3*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 3.
  execCmdEx("xdo key_press -k 99; xdo key_release -k 99")

template xdo_key_numpad4*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 4.
  execCmdEx("xdo key_press -k 100; xdo key_release -k 100")

template xdo_key_numpad5*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 5.
  execCmdEx("xdo key_press -k 101; xdo key_release -k 101")

template xdo_key_numpad6*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 6.
  execCmdEx("xdo key_press -k 102; xdo key_release -k 102")

template xdo_key_numpad7*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 7.
  execCmdEx("xdo key_press -k 103; xdo key_release -k 103")

template xdo_key_numpad8*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 8.
  execCmdEx("xdo key_press -k 104; xdo key_release -k 104")

template xdo_key_numpad9*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad 9.
  execCmdEx("xdo key_press -k 105; xdo key_release -k 105")

template xdo_key_numpad_asterisk*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad ``*``.
  execCmdEx("xdo key_press -k 106; xdo key_release -k 106")

template xdo_key_numpad_plus*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad ``+``.
  execCmdEx("xdo key_press -k 107; xdo key_release -k 107")

template xdo_key_numpad_minus*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad ``-``.
  execCmdEx("xdo key_press -k 109; xdo key_release -k 109")

template xdo_key_numpad_dot*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad ``.``.
  execCmdEx("xdo key_press -k 110; xdo key_release -k 110")

template xdo_key_numpad_slash*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Numeric Pad ``/``.
  execCmdEx("xdo key_press -k 111; xdo key_release -k 111")

template xdo_key_f1*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F1.
  execCmdEx("xdo key_press -k 112; xdo key_release -k 112")

template xdo_key_f2*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F2.
  execCmdEx("xdo key_press -k 113; xdo key_release -k 113")

template xdo_key_f3*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F3.
  execCmdEx("xdo key_press -k 114; xdo key_release -k 114")

template xdo_key_f4*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F4.
  execCmdEx("xdo key_press -k 115; xdo key_release -k 115")

template xdo_key_f5*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F5.
  execCmdEx("xdo key_press -k 116; xdo key_release -k 116")

template xdo_key_f6*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F6.
  execCmdEx("xdo key_press -k 117; xdo key_release -k 117")

template xdo_key_f7*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F7.
  execCmdEx("xdo key_press -k 118; xdo key_release -k 118")

template xdo_key_f8*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F8.
  execCmdEx("xdo key_press -k 119; xdo key_release -k 119")

template xdo_key_f9*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F9.
  execCmdEx("xdo key_press -k 120; xdo key_release -k 120")

template xdo_key_f10*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F10.
  execCmdEx("xdo key_press -k 121; xdo key_release -k 121")

template xdo_key_f11*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F11.
  execCmdEx("xdo key_press -k 122; xdo key_release -k 122")

template xdo_key_f12*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key F12.
  execCmdEx("xdo key_press -k 123; xdo key_release -k 123")

template xdo_key_0*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 0.
  execCmdEx("xdo key_press -k 48; xdo key_release -k 48")

template xdo_key_1*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 1.
  execCmdEx("xdo key_press -k 49; xdo key_release -k 49")

template xdo_key_2*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 2.
  execCmdEx("xdo key_press -k 50; xdo key_release -k 50")

template xdo_key_3*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 3.
  execCmdEx("xdo key_press -k 51; xdo key_release -k 51")

template xdo_key_4*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 4.
  execCmdEx("xdo key_press -k 52; xdo key_release -k 52")

template xdo_key_5*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 5.
  execCmdEx("xdo key_press -k 53; xdo key_release -k 53")

template xdo_key_6*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 6.
  execCmdEx("xdo key_press -k 54; xdo key_release -k 54")

template xdo_key_7*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 7.
  execCmdEx("xdo key_press -k 55; xdo key_release -k 55")

template xdo_key_8*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 8.
  execCmdEx("xdo key_press -k 56; xdo key_release -k 56")

template xdo_key_9*(): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key 9.
  execCmdEx("xdo key_press -k 57; xdo key_release -k 57")

template xdo_key_wasd*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Keys W,A,S,D as fast as possible (in games,make circles).
  execCmdEx("xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 65;xdo key_release -k 65;xdo key_press -k 83;xdo key_release -k 83;xdo key_press -k 68;xdo key_release -k 68;".repeat(repetitions))

template xdo_key_spamm_space*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key Space as fast as possible (in games,bunny hop).
  execCmdEx("xdo key_press -k 32;xdo key_release -k 32;".repeat(repetitions))

template xdo_key_w_click*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Key W and Mouse Left Click as fast as possible (in games,forward+hit).
  execCmdEx("xdo key_press -k 87; xdo key_release -k 87; xdo button_press -k 1; xdo button_release -k 1;".repeat(repetitions))

template xdo_key_w_space*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Keys W,Space as fast as possible (in games, forward+jump).
  execCmdEx("xdo key_press -k 87; xdo key_release -k 87; xdo key_press -k 32; xdo key_release -k 32;".repeat(repetitions))

template xdo_key_w_space_click*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Keys W,Space and Mouse Left Click (in games, forward+jump+hit).
  execCmdEx("xdo key_press -k 87; xdo key_release -k 87; xdo key_press -k 32; xdo key_release -k 32; xdo button_press -k 1; xdo button_release -k 1;".repeat(repetitions))

proc xdo_key_wasd_random*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Keyboard Keys W,A,S,D,space Randomly as fast as possible.
  let cmd = create(string, sizeOf string)
  for i in 0..repetitions:
    cmd[].add "xdo key_press -k " & $sample([87, 65, 83, 68, 32]) & "; xdo key_release -k " & $sample([87, 65, 83, 68, 32]) & ";"
  result = execCmdEx(cmd[])
  dealloc cmd

template xdo_key_w_e*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] =
  ## Keyboard Keys W,E as fast as possible (in games, forward+use).
  execCmdEx("xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 69; xdo key_release -k 69;".repeat(repetitions))

proc xdo_key_numbers_click*(repetitions = 1.Positive): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## This function types the keys like: 1,10clicks,2,10clicks,3,10clicks,etc up to 9 (in games, shoot weapons 1 to 9).
  let cmd = create(string, sizeOf string)
  for _ in 0..repetitions:
    for i in 49..57:
      cmd[].add "xdo key_press -k " & $i & ";xdo key_release -k " & $i & ";" & static(
        "xdo button_press -k 1;xdo button_release -k 1;".repeat(9))
  result = execCmdEx(cmd[])
  dealloc cmd

template xdo_type*(letter: char): tuple[output: TaintedString, exitCode: int] =
  ## Type a single letter using keyboard keys from char argument.
  execCmdEx("xdo key_press -k " & $char2keycode[$letter] & "; xdo key_release -k " & $char2keycode[$letter])

proc xdo_type_temp_dir*(): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Type the system temporary directory full path using keyboard keys.
  for letter in getTempDir(): result = xdo_type(letter)

proc xdo_type_current_dir*(): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Type the current working directory full path using keyboard keys.
  for letter in getCurrentDir(): result = xdo_type(letter)

proc xdo_type_hostOS*(): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Type the hostOS using keyboard keys.
  for letter in hostOS: result = xdo_type(letter)

proc xdo_type_hostCPU*(): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Type the hostCPU using keyboard keys.
  for letter in hostCPU: result = xdo_type(letter)

proc xdo_type_NimVersion*(): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Type the current NimVersion using keyboard keys.
  for letter in NimVersion: result = xdo_type(letter)

proc xdo_type_CompileTime*(): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Type the CompileDate & CompileTime using keyboard keys.
  for letter in static(CompileDate & "T" & CompileTime): result = xdo_type(letter)

proc xdo_type_enter*(words: string): tuple[output: TaintedString, exitCode: int] {.inline.} =
  ## Type the words then press Enter at the end using keyboard keys.
  for letter in words: discard xdo_type(letter)
  result = execCmdEx("xdo key_press -k 13; xdo key_release -k 13")


runnableExamples:
  ## XDo works on Linux OS.
  when defined(linux):
    ## Basic example of mouse and keyboard control from code.
    import os, osproc, strformat, strutils, terminal, random, json, times, tables
    echo xdo_version
    echo xdo_get_id()
    echo xdo_get_pid()
    echo xdo_move_mouse_random()
    echo xdo_move_mouse_top_left()
    echo xdo_move_mouse((x: "+99", y: "+99"))
    echo xdo_move_mouse_left_100px(2)
    echo xdo_move_mouse_top_100px(2)
    echo xdo_mouse_move_alternating((x: 9, y: 5), 3)
    echo xdo_type('a')
    echo xdo_type_current_dir()
    echo xdo_type_temp_dir()
    # echo xdo_key_0()
    # echo xdo_key_1()
    # echo xdo_key_2()
    # echo xdo_key_3()
    # echo xdo_key_4()
    # echo xdo_key_5()
    # echo xdo_key_6()
    # echo xdo_key_7()
    # echo xdo_key_8()
    # echo xdo_key_9()
    # echo xdo_hide_all_but_focused_window()
    # echo xdo_hide_focused_window()
