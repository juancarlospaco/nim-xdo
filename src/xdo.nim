## Nim-Xdo
## =======
##
## - Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.
##
## .. image:: https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg
from strutils import repeat
when not defined(linux): {.warning: "ERROR: XDo is only available for Linux.".}

func toKeycode*(c: char): int {.noinline.} =
  ## https://gist.github.com/rickyzhang82/8581a762c9f9fc6ddb8390872552c250#file-keycode-linux-L33-L137
  case c      # Hard to find the correct values for those keycodes, mac and windows differ too.
  of '1': 10  # Some values found just looping integers 10..999  :(
  of '2': 11
  of '3': 12
  of '4': 13
  of '5': 14
  of '6': 15
  of '7': 16
  of '8': 17
  of '9': 18
  of '0': 19
  of '-': 20
  of '=': 21
  of '\t': 23
  of 'q': 24
  of 'w': 25
  of 'e': 26
  of 'r': 27
  of 't': 28
  of 'y': 29
  of 'u': 30
  of 'i': 31
  of 'o': 32
  of 'p': 33
  of '[': 34
  of ']': 35
  of '\n': 36
  of 'a': 38
  of 's': 39
  of 'd': 40
  of 'f': 41
  of 'g': 42
  of 'h': 43
  of 'j': 44
  of 'k': 45
  of 'l': 46
  of ';': 47
  of '\'': 48
  of '`': 49
  of '\\': 51
  of 'z': 52
  of 'x': 53
  of 'c': 54
  of 'v': 55
  of 'b': 56
  of 'n': 57
  of 'm': 58
  of ',': 59
  of '.': 60
  of '/': 61
  of '*': 63
  of ' ': 65
  of '+': 86
  of '<': 94
  else: 999

template xdo*(action: string, move: tuple[x: string, y: string] = (x: "0", y: "0"),
          instance_name = "", class_name = "", wm_name = "", pid = 0,
          wait4window = false, same_desktop = true, same_class = true, same_id = true): string =
  ## XDo proc is a very low level wrapper for XDo for advanced developers, almost all arguments are supported.
  assert action in ["close", "kill", "hide", "show", "raise", "lower", "below", "above", "move", "resize", "activate", "id",
  "pid", "key_press", "key_release", "button_press", "button_release", "pointer_motion"] , "Invalid argument for Action"
  (
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
  )

template move_mouse*(move: tuple[x: string, y: string]): string =
  ## Move mouse to move position pixel coordinates (X, Y).
  "xdo pointer_motion -x " & $move.x & " -y " & $move.y & ';'

template move_window*(move: tuple[x: string, y: string], pid: Positive): string =
  ## Move window to move position pixel coordinates (X, Y).
  "xdo move -x " & $move.x & " -y " & $move.y & " -p " & $pid & ';'

template resize_window*(move: tuple[x: string, y: string], pid: Positive): string =
  ## Resize window up to move position pixel coordinates (X, Y).
  "xdo resize -w " & $move.x & " -h " & $move.y & " -p " & $pid & ';'

template close_focused_window*(): string =
  ## Close the current focused window.
  "xdo close -c;"

template hide_focused_window*(): string =
  ## Hide the current focused window. This is NOT Minimize.
  "xdo hide -c;"

template show_focused_window*(): string =
  ## Hide the current focused window. This is NOT Maximize.
  "xdo show -c;"

template raise_focused_window*(): string =
  ## Raise up the current focused window.
  "xdo raise -c;"

template lower_focused_window*(): string =
  ## Lower down the current focused window.
  "xdo lower -c;"

template activate_this_window*(pid: Positive): string =
  ## Force to Activate this window by PID.
  "xdo activate -p " & $pid & ";"

template hide_all_but_focused_window*(): string =
  ## Hide all other windows but leave the current focused window visible.
  "xdo hide -dr;"

template close_all_but_focused_window*(): string =
  ## Close all other windows but leave the current focused window open.
  "xdo close -dr;"

template raise_all_but_focused_window*(): string =
  ## Raise up all other windows but the current focused window.
  "xdo raise -dr;"

template lower_all_but_focused_window*(): string =
  ## Lower down all other windows but the current focused window.
  "xdo lower -dr;"

template show_all_but_focused_window*(): string =
  ## Show all other windows but the current focused window.
  "xdo show -dr;"

template move_mouse_top_left*(): string =
  ## Move mouse to Top Left limits (X=0, Y=0).
  "xdo pointer_motion -x 0 -y 0;"

template move_mouse_top_100px*(repetitions: Positive): string =
  ## Move mouse to Top Y=0, then repeat move Bottom on jumps of 100px each.
  "xdo pointer_motion -y 0;" & "xdo pointer_motion -y +100;".repeat(repetitions)

template move_mouse_left_100px*(repetitions: Positive): string =
  ## Move mouse to Left X=0, then repeat move Right on jumps of 100px each.
  "xdo pointer_motion -x 0;" & "xdo pointer_motion -x +100;".repeat(repetitions)

template get_pid*(): string =
  ## Get PID of a window, integer type.
  "xdo pid;"

template get_id*(): string =
  ## Get ID of a window, integer type.
  "xdo id;"

proc mouse_move_alternating*(move: tuple[x: int, y: int], repetitions = 1.Positive): string {.inline.} =
  ## Move mouse alternating to Left/Right Up/Down, AKA Zig-Zag movements.
  for i in 0..repetitions: result.add "xdo pointer_motion -x " & $(if i mod 2 == 0: "+" else: "-" & $move.x) & " -y " & $(if i mod 2 == 0: "+" else: "-" & $move.y) & ';'

template mouse_left_click*(): string =
  ## Mouse Left Click.
  "xdo button_press -k 1;xdo button_release -k 1;"

template mouse_middle_click*(): string =
  ## Mouse Middle Click.
  "xdo button_press -k 2;xdo button_release -k 2;"

template mouse_right_click*(): string =
  ## Mouse Right Click.
  "xdo button_press -k 3;xdo button_release -k 3;"

template mouse_double_left_click*(): string =
  ## Mouse Double Left Click.
  "xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"

template mouse_double_middle_click*(): string =
  ## Mouse Double Middle Click.
  "xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;"

template mouse_double_right_click*(): string =
  ## Mouse Double Right Click.
  "xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;"

template mouse_triple_left_click*(): string =
  ## Mouse Triple Left Click.
  "xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"

template mouse_triple_middle_click*(): string =
  ## Mouse Triple Middle Click.
  "xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;"

template mouse_triple_right_click*(): string =
  ## Mouse Triple Right Click.
  "xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;"

template mouse_spamm_left_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Left Click as fast as possible.
  "xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions)

template mouse_spamm_middle_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Middle Click as fast as possible.
  "xdo button_press -k 2;xdo button_release -k 2;".repeat(repetitions)

template mouse_spamm_right_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Right Click as fast as possible.
  "xdo button_press -k 3;xdo button_release -k 3;".repeat(repetitions)

template mouse_swipe_horizontal*(x: string): string =
  ## Mouse Swipe to Left or Right, Hold Left Click+Drag Horizontally+Release Left Click.
  "xdo button_press -k 1;xdo pointer_motion -x " & $x & ";xdo button_release -k 1;"

template mouse_swipe_vertical*(y: string): string =
  ## Mouse Swipe to Up or Down, Hold Left Click+Drag Vertically+Release Left Click.
  "xdo button_press -k 1;xdo pointer_motion -y " & $y & ";xdo button_release -k 1;"

template key_backspace*(): string =
  ## Keyboard Key Backspace.
  "xdo key_press -k 8;xdo key_release -k 8;"

template key_tab*(): string =
  ## Keyboard Key Tab.
  "xdo key_press -k 9;xdo key_release -k 9;"

template key_enter*(): string =
  ## Keyboard Key Enter.
  "xdo key_press -k 13;xdo key_release -k 13;"

template key_shift*(): string =
  ## Keyboard Key Shift.
  "xdo key_press -k 16;xdo key_release -k 16;"

template key_ctrl*(): string =
  ## Keyboard Key Ctrl.
  "xdo key_press -k 17;xdo key_release -k 17;"

template key_alt*(): string =
  ## Keyboard Key Alt.
  "xdo key_press -k 18;xdo key_release -k 18;"

template key_pause*(): string =
  ## Keyboard Key Pause.
  "xdo key_press -k 19;xdo key_release -k 19;"

template key_capslock*(): string =
  ## Keyboard Key Caps Lock.
  "xdo key_press -k 20;xdo key_release -k 20;"

template key_esc*(): string =
  ## Keyboard Key Esc.
  "xdo key_press -k 27;xdo key_release -k 27;"

template key_space*(): string =
  ## Keyboard Key Space.
  "xdo key_press -k 32;xdo key_release -k 32;"

template key_pageup*(): string =
  ## Keyboard Key Page Up.
  "xdo key_press -k 33;xdo key_release -k 33;"

template key_pagedown*(): string =
  ## Keyboard Key Page Down.
  "xdo key_press -k 34;xdo key_release -k 34;"

template key_end*(): string =
  ## Keyboard Key End.
  "xdo key_press -k 35;xdo key_release -k 35;"

template key_home*(): string =
  ## Keyboard Key Home.
  "xdo key_press -k 36;xdo key_release -k 36;"

template key_arrow_left*(): string =
  ## Keyboard Key Arrow Left.
  "xdo key_press -k 37;xdo key_release -k 37;"

template key_arrow_up*(): string =
  ## Keyboard Key Arrow Up.
  "xdo key_press -k 38;xdo key_release -k 38;"

template key_arrow_right*(): string =
  ## Keyboard Key Arrow Right.
  "xdo key_press -k 39;xdo key_release -k 39;"

template key_arrow_down*(): string =
  ## Keyboard Key Arrow Down.
  "xdo key_press -k 40;xdo key_release -k 40;"

template key_insert*(): string =
  ## Keyboard Key Insert.
  "xdo key_press -k 45;xdo key_release -k 45;"

template key_delete*(): string =
  ## Keyboard Key Delete.
  "xdo key_press -k 46;xdo key_release -k 46;"

template key_numlock*(): string =
  ## Keyboard Key Num Lock.
  "xdo key_press -k 144;xdo key_release -k 144;"

template key_scrolllock*(): string =
  ## Keyboard Key Scroll Lock.
  "xdo key_press -k 145;xdo key_release -k 145;"

template key_mycomputer*(): string =
  ## Keyboard Key My Computer (HotKey thingy of some modern keyboards).
  "xdo key_press -k 182;xdo key_release -k 182;"

template key_mycalculator*(): string =
  ## Keyboard Key My Calculator (HotKey thingy of some modern keyboards).
  "xdo key_press -k 183;xdo key_release -k 183;"

template key_windows*(): string =
  ## Keyboard Key Windows (AKA Meta Key).
  "xdo key_press -k 91;xdo key_release -k 91;"

template key_rightclick*(): string =
  ## Keyboard Key Right Click (HotKey thingy, fake click from keyboard key).
  "xdo key_press -k 93;xdo key_release -k 93;"

template key_numpad0*(): string =
  ## Keyboard Key Numeric Pad 0.
  "xdo key_press -k 96;xdo key_release -k 96;"

template key_numpad1*(): string =
  ## Keyboard Key Numeric Pad 1.
  "xdo key_press -k 97;xdo key_release -k 97;"

template key_numpad2*(): string =
  ## Keyboard Key Numeric Pad 2.
  "xdo key_press -k 98;xdo key_release -k 98;"

template key_numpad3*(): string =
  ## Keyboard Key Numeric Pad 3.
  "xdo key_press -k 99;xdo key_release -k 99;"

template key_numpad4*(): string =
  ## Keyboard Key Numeric Pad 4.
  "xdo key_press -k 100;xdo key_release -k 100;"

template key_numpad5*(): string =
  ## Keyboard Key Numeric Pad 5.
  "xdo key_press -k 101;xdo key_release -k 101;"

template key_numpad6*(): string =
  ## Keyboard Key Numeric Pad 6.
  "xdo key_press -k 102;xdo key_release -k 102;"

template key_numpad7*(): string =
  ## Keyboard Key Numeric Pad 7.
  "xdo key_press -k 103;xdo key_release -k 103;"

template key_numpad8*(): string =
  ## Keyboard Key Numeric Pad 8.
  "xdo key_press -k 104;xdo key_release -k 104;"

template key_numpad9*(): string =
  ## Keyboard Key Numeric Pad 9.
  "xdo key_press -k 105;xdo key_release -k 105;"

template key_numpad_asterisk*(): string =
  ## Keyboard Key Numeric Pad ``*``.
  "xdo key_press -k 106;xdo key_release -k 106;"

template key_numpad_plus*(): string =
  ## Keyboard Key Numeric Pad ``+``.
  "xdo key_press -k 107;xdo key_release -k 107;"

template key_numpad_minus*(): string =
  ## Keyboard Key Numeric Pad ``-``.
  "xdo key_press -k 109;xdo key_release -k 109;"

template key_numpad_dot*(): string =
  ## Keyboard Key Numeric Pad ``.``.
  "xdo key_press -k 110;xdo key_release -k 110;"

template key_numpad_slash*(): string =
  ## Keyboard Key Numeric Pad ``/``.
  "xdo key_press -k 111;xdo key_release -k 111;"

template key_f1*(): string =
  ## Keyboard Key F1.
  "xdo key_press -k 112;xdo key_release -k 112;"

template key_f2*(): string =
  ## Keyboard Key F2.
  "xdo key_press -k 113;xdo key_release -k 113;"

template key_f3*(): string =
  ## Keyboard Key F3.
  "xdo key_press -k 114;xdo key_release -k 114;"

template key_f4*(): string =
  ## Keyboard Key F4.
  "xdo key_press -k 115;xdo key_release -k 115;"

template key_f5*(): string =
  ## Keyboard Key F5.
  "xdo key_press -k 116;xdo key_release -k 116;"

template key_f6*(): string =
  ## Keyboard Key F6.
  "xdo key_press -k 117;xdo key_release -k 117;"

template key_f7*(): string =
  ## Keyboard Key F7.
  "xdo key_press -k 118;xdo key_release -k 118;"

template key_f8*(): string =
  ## Keyboard Key F8.
  "xdo key_press -k 119;xdo key_release -k 119;"

template key_f9*(): string =
  ## Keyboard Key F9.
  "xdo key_press -k 120;xdo key_release -k 120;"

template key_f10*(): string =
  ## Keyboard Key F10.
  "xdo key_press -k 121;xdo key_release -k 121;"

template key_f11*(): string =
  ## Keyboard Key F11.
  "xdo key_press -k 122;xdo key_release -k 122;"

template key_f12*(): string =
  ## Keyboard Key F12.
  "xdo key_press -k 123;xdo key_release -k 123;"

template key_0*(): string =
  ## Keyboard Key 0.
  "xdo key_press -k 48;xdo key_release -k 48;"

template key_1*(): string =
  ## Keyboard Key 1.
  "xdo key_press -k 49;xdo key_release -k 49;"

template key_2*(): string =
  ## Keyboard Key 2.
  "xdo key_press -k 50;xdo key_release -k 50;"

template key_3*(): string =
  ## Keyboard Key 3.
  "xdo key_press -k 51;xdo key_release -k 51;"

template key_4*(): string =
  ## Keyboard Key 4.
  "xdo key_press -k 52;xdo key_release -k 52;"

template key_5*(): string =
  ## Keyboard Key 5.
  "xdo key_press -k 53;xdo key_release -k 53;"

template key_6*(): string =
  ## Keyboard Key 6.
  "xdo key_press -k 54;xdo key_release -k 54;"

template key_7*(): string =
  ## Keyboard Key 7.
  "xdo key_press -k 55;xdo key_release -k 55;"

template key_8*(): string =
  ## Keyboard Key 8.
  "xdo key_press -k 56;xdo key_release -k 56;"

template key_9*(): string =
  ## Keyboard Key 9.
  "xdo key_press -k 57;xdo key_release -k 57;"

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

template tipe*(letter: char): string =
  ## Type a single letter using keyboard keys from char argument.
  "xdo key_press -k " & $toKeycode(letter) & ";xdo key_release -k " & $toKeycode(letter) & ';'

proc type_hostOS*(): string {.inline.} =
  ## Type the hostOS using keyboard keys.
  for letter in hostOS: result.add tipe(letter)

proc type_hostCPU*(): string {.inline.} =
  ## Type the hostCPU using keyboard keys.
  for letter in hostCPU: result.add tipe(letter)

proc type_NimVersion*(): string {.inline.} =
  ## Type the current NimVersion using keyboard keys.
  for letter in NimVersion: result.add tipe(letter)

proc type_CompileTime*(): string {.inline.} =
  ## Type the CompileDate & CompileTime using keyboard keys.
  for letter in static(CompileDate & "T" & CompileTime): result.add tipe(letter)

proc type_enter*(words: string): string {.inline.} =
  ## Type the words then press Enter at the end using keyboard keys.
  for letter in words: result.add tipe(letter)
  result.add "xdo key_press -k 13;xdo key_release -k 13;"


runnableExamples:
  ## XDo works on Linux OS.
  when defined(linux):
    ## Basic example of mouse and keyboard control from code.
    import strutils
    echo version
    echo get_id()
    echo get_pid()
    echo move_mouse_top_left()
    echo move_mouse((x: "+99", y: "+99"))
    echo move_mouse_left_100px(2)
    echo move_mouse_top_100px(2)
    echo mouse_move_alternating((x: 9, y: 5), 3)
    echo type('a')
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
