## Nim-Xdo
## =======
##
## - Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.
##
## .. image:: https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg
from strutils import repeat
when not defined(linux): {.warning: "ERROR: XDo is only available for Linux.".}

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

template xdo_move_mouse*(move: tuple[x: string, y: string]): string =
  ## Move mouse to move position pixel coordinates (X, Y).
  "xdo pointer_motion -x " & $move.x & " -y " & $move.y & ";"

template xdo_move_window*(move: tuple[x: string, y: string], pid: Positive): string =
  ## Move window to move position pixel coordinates (X, Y).
  "xdo move -x " & $move.x & " -y " & $move.y & " -p " & $pid & ";"

template xdo_resize_window*(move: tuple[x: string, y: string], pid: Positive): string =
  ## Resize window up to move position pixel coordinates (X, Y).
  "xdo resize -w " & $move.x & " -h " & $move.y & " -p " & $pid & ";"

template xdo_close_focused_window*(): string =
  ## Close the current focused window.
  "xdo close -c;"

template xdo_hide_focused_window*(): string =
  ## Hide the current focused window. This is NOT Minimize.
  "xdo hide -c;"

template xdo_show_focused_window*(): string =
  ## Hide the current focused window. This is NOT Maximize.
  "xdo show -c;"

template xdo_raise_focused_window*(): string =
  ## Raise up the current focused window.
  "xdo raise -c;"

template xdo_lower_focused_window*(): string =
  ## Lower down the current focused window.
  "xdo lower -c;"

template xdo_activate_this_window*(pid: Positive): string =
  ## Force to Activate this window by PID.
  "xdo activate -p " & $pid & ";"

template xdo_hide_all_but_focused_window*(): string =
  ## Hide all other windows but leave the current focused window visible.
  "xdo hide -dr;"

template xdo_close_all_but_focused_window*(): string =
  ## Close all other windows but leave the current focused window open.
  "xdo close -dr;"

template xdo_raise_all_but_focused_window*(): string =
  ## Raise up all other windows but the current focused window.
  "xdo raise -dr;"

template xdo_lower_all_but_focused_window*(): string =
  ## Lower down all other windows but the current focused window.
  "xdo lower -dr;"

template xdo_show_all_but_focused_window*(): string =
  ## Show all other windows but the current focused window.
  "xdo show -dr;"

template xdo_move_mouse_top_left*(): string =
  ## Move mouse to Top Left limits (X=0, Y=0).
  "xdo pointer_motion -x 0 -y 0;"

template xdo_move_mouse_top_100px*(repetitions: Positive): string =
  ## Move mouse to Top Y=0, then repeat move Bottom on jumps of 100px each.
  "xdo pointer_motion -y 0;" & "xdo pointer_motion -y +100;".repeat(repetitions)

template xdo_move_mouse_left_100px*(repetitions: Positive): string =
  ## Move mouse to Left X=0, then repeat move Right on jumps of 100px each.
  "xdo pointer_motion -x 0;" & "xdo pointer_motion -x +100;".repeat(repetitions)

template xdo_get_pid*(): string =
  ## Get PID of a window, integer type.
  "xdo pid;"

template xdo_get_id*(): string =
  ## Get ID of a window, integer type.
  "xdo id;"

proc xdo_mouse_move_alternating*(move: tuple[x: int, y: int], repetitions = 1.Positive): string {.inline.} =
  ## Move mouse alternating to Left/Right Up/Down, AKA Zig-Zag movements.
  for i in 0..repetitions: result.add "xdo pointer_motion -x " & $(if i mod 2 == 0: "+" else: "-" & $move.x) & " -y " & $(if i mod 2 == 0: "+" else: "-" & $move.y) & ";"

template xdo_mouse_left_click*(): string =
  ## Mouse Left Click.
  "xdo button_press -k 1;xdo button_release -k 1;"

template xdo_mouse_middle_click*(): string =
  ## Mouse Middle Click.
  "xdo button_press -k 2;xdo button_release -k 2;"

template xdo_mouse_right_click*(): string =
  ## Mouse Right Click.
  "xdo button_press -k 3;xdo button_release -k 3;"

template xdo_mouse_double_left_click*(): string =
  ## Mouse Double Left Click.
  "xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"

template xdo_mouse_double_middle_click*(): string =
  ## Mouse Double Middle Click.
  "xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;"

template xdo_mouse_double_right_click*(): string =
  ## Mouse Double Right Click.
  "xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;"

template xdo_mouse_triple_left_click*(): string =
  ## Mouse Triple Left Click.
  "xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"

template xdo_mouse_triple_middle_click*(): string =
  ## Mouse Triple Middle Click.
  "xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;xdo button_press -k 2;xdo button_release -k 2;"

template xdo_mouse_triple_right_click*(): string =
  ## Mouse Triple Right Click.
  "xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;xdo button_press -k 3;xdo button_release -k 3;"

template xdo_mouse_spamm_left_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Left Click as fast as possible.
  "xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions)

template xdo_mouse_spamm_middle_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Middle Click as fast as possible.
  "xdo button_press -k 2;xdo button_release -k 2;".repeat(repetitions)

template xdo_mouse_spamm_right_click*(repetitions = 1.Positive): string =
  ## Spamm Mouse Right Click as fast as possible.
  "xdo button_press -k 3;xdo button_release -k 3;".repeat(repetitions)

template xdo_mouse_swipe_horizontal*(x: string): string =
  ## Mouse Swipe to Left or Right, Hold Left Click+Drag Horizontally+Release Left Click.
  "xdo button_press -k 1;xdo pointer_motion -x " & $x & ";xdo button_release -k 1;"

template xdo_mouse_swipe_vertical*(y: string): string =
  ## Mouse Swipe to Up or Down, Hold Left Click+Drag Vertically+Release Left Click.
  "xdo button_press -k 1;xdo pointer_motion -y " & $y & ";xdo button_release -k 1;"

template xdo_key_backspace*(): string =
  ## Keyboard Key Backspace.
  "xdo key_press -k 8;xdo key_release -k 8;"

template xdo_key_tab*(): string =
  ## Keyboard Key Tab.
  "xdo key_press -k 9;xdo key_release -k 9;"

template xdo_key_enter*(): string =
  ## Keyboard Key Enter.
  "xdo key_press -k 13;xdo key_release -k 13;"

template xdo_key_shift*(): string =
  ## Keyboard Key Shift.
  "xdo key_press -k 16;xdo key_release -k 16;"

template xdo_key_ctrl*(): string =
  ## Keyboard Key Ctrl.
  "xdo key_press -k 17;xdo key_release -k 17;"

template xdo_key_alt*(): string =
  ## Keyboard Key Alt.
  "xdo key_press -k 18;xdo key_release -k 18;"

template xdo_key_pause*(): string =
  ## Keyboard Key Pause.
  "xdo key_press -k 19;xdo key_release -k 19;"

template xdo_key_capslock*(): string =
  ## Keyboard Key Caps Lock.
  "xdo key_press -k 20;xdo key_release -k 20;"

template xdo_key_esc*(): string =
  ## Keyboard Key Esc.
  "xdo key_press -k 27;xdo key_release -k 27;"

template xdo_key_space*(): string =
  ## Keyboard Key Space.
  "xdo key_press -k 32;xdo key_release -k 32;"

template xdo_key_pageup*(): string =
  ## Keyboard Key Page Up.
  "xdo key_press -k 33;xdo key_release -k 33;"

template xdo_key_pagedown*(): string =
  ## Keyboard Key Page Down.
  "xdo key_press -k 34;xdo key_release -k 34;"

template xdo_key_end*(): string =
  ## Keyboard Key End.
  "xdo key_press -k 35;xdo key_release -k 35;"

template xdo_key_home*(): string =
  ## Keyboard Key Home.
  "xdo key_press -k 36;xdo key_release -k 36;"

template xdo_key_arrow_left*(): string =
  ## Keyboard Key Arrow Left.
  "xdo key_press -k 37;xdo key_release -k 37;"

template xdo_key_arrow_up*(): string =
  ## Keyboard Key Arrow Up.
  "xdo key_press -k 38;xdo key_release -k 38;"

template xdo_key_arrow_right*(): string =
  ## Keyboard Key Arrow Right.
  "xdo key_press -k 39;xdo key_release -k 39;"

template xdo_key_arrow_down*(): string =
  ## Keyboard Key Arrow Down.
  "xdo key_press -k 40;xdo key_release -k 40;"

template xdo_key_insert*(): string =
  ## Keyboard Key Insert.
  "xdo key_press -k 45;xdo key_release -k 45;"

template xdo_key_delete*(): string =
  ## Keyboard Key Delete.
  "xdo key_press -k 46;xdo key_release -k 46;"

template xdo_key_numlock*(): string =
  ## Keyboard Key Num Lock.
  "xdo key_press -k 144;xdo key_release -k 144;"

template xdo_key_scrolllock*(): string =
  ## Keyboard Key Scroll Lock.
  "xdo key_press -k 145;xdo key_release -k 145;"

template xdo_key_mycomputer*(): string =
  ## Keyboard Key My Computer (HotKey thingy of some modern keyboards).
  "xdo key_press -k 182;xdo key_release -k 182;"

template xdo_key_mycalculator*(): string =
  ## Keyboard Key My Calculator (HotKey thingy of some modern keyboards).
  "xdo key_press -k 183;xdo key_release -k 183;"

template xdo_key_windows*(): string =
  ## Keyboard Key Windows (AKA Meta Key).
  "xdo key_press -k 91;xdo key_release -k 91;"

template xdo_key_rightclick*(): string =
  ## Keyboard Key Right Click (HotKey thingy, fake click from keyboard key).
  "xdo key_press -k 93;xdo key_release -k 93;"

template xdo_key_numpad0*(): string =
  ## Keyboard Key Numeric Pad 0.
  "xdo key_press -k 96;xdo key_release -k 96;"

template xdo_key_numpad1*(): string =
  ## Keyboard Key Numeric Pad 1.
  "xdo key_press -k 97;xdo key_release -k 97;"

template xdo_key_numpad2*(): string =
  ## Keyboard Key Numeric Pad 2.
  "xdo key_press -k 98;xdo key_release -k 98;"

template xdo_key_numpad3*(): string =
  ## Keyboard Key Numeric Pad 3.
  "xdo key_press -k 99;xdo key_release -k 99;"

template xdo_key_numpad4*(): string =
  ## Keyboard Key Numeric Pad 4.
  "xdo key_press -k 100;xdo key_release -k 100;"

template xdo_key_numpad5*(): string =
  ## Keyboard Key Numeric Pad 5.
  "xdo key_press -k 101;xdo key_release -k 101;"

template xdo_key_numpad6*(): string =
  ## Keyboard Key Numeric Pad 6.
  "xdo key_press -k 102;xdo key_release -k 102;"

template xdo_key_numpad7*(): string =
  ## Keyboard Key Numeric Pad 7.
  "xdo key_press -k 103;xdo key_release -k 103;"

template xdo_key_numpad8*(): string =
  ## Keyboard Key Numeric Pad 8.
  "xdo key_press -k 104;xdo key_release -k 104;"

template xdo_key_numpad9*(): string =
  ## Keyboard Key Numeric Pad 9.
  "xdo key_press -k 105;xdo key_release -k 105;"

template xdo_key_numpad_asterisk*(): string =
  ## Keyboard Key Numeric Pad ``*``.
  "xdo key_press -k 106;xdo key_release -k 106;"

template xdo_key_numpad_plus*(): string =
  ## Keyboard Key Numeric Pad ``+``.
  "xdo key_press -k 107;xdo key_release -k 107;"

template xdo_key_numpad_minus*(): string =
  ## Keyboard Key Numeric Pad ``-``.
  "xdo key_press -k 109;xdo key_release -k 109;"

template xdo_key_numpad_dot*(): string =
  ## Keyboard Key Numeric Pad ``.``.
  "xdo key_press -k 110;xdo key_release -k 110;"

template xdo_key_numpad_slash*(): string =
  ## Keyboard Key Numeric Pad ``/``.
  "xdo key_press -k 111;xdo key_release -k 111;"

template xdo_key_f1*(): string =
  ## Keyboard Key F1.
  "xdo key_press -k 112;xdo key_release -k 112;"

template xdo_key_f2*(): string =
  ## Keyboard Key F2.
  "xdo key_press -k 113;xdo key_release -k 113;"

template xdo_key_f3*(): string =
  ## Keyboard Key F3.
  "xdo key_press -k 114;xdo key_release -k 114;"

template xdo_key_f4*(): string =
  ## Keyboard Key F4.
  "xdo key_press -k 115;xdo key_release -k 115;"

template xdo_key_f5*(): string =
  ## Keyboard Key F5.
  "xdo key_press -k 116;xdo key_release -k 116;"

template xdo_key_f6*(): string =
  ## Keyboard Key F6.
  "xdo key_press -k 117;xdo key_release -k 117;"

template xdo_key_f7*(): string =
  ## Keyboard Key F7.
  "xdo key_press -k 118;xdo key_release -k 118;"

template xdo_key_f8*(): string =
  ## Keyboard Key F8.
  "xdo key_press -k 119;xdo key_release -k 119;"

template xdo_key_f9*(): string =
  ## Keyboard Key F9.
  "xdo key_press -k 120;xdo key_release -k 120;"

template xdo_key_f10*(): string =
  ## Keyboard Key F10.
  "xdo key_press -k 121;xdo key_release -k 121;"

template xdo_key_f11*(): string =
  ## Keyboard Key F11.
  "xdo key_press -k 122;xdo key_release -k 122;"

template xdo_key_f12*(): string =
  ## Keyboard Key F12.
  "xdo key_press -k 123;xdo key_release -k 123;"

template xdo_key_0*(): string =
  ## Keyboard Key 0.
  "xdo key_press -k 48;xdo key_release -k 48;"

template xdo_key_1*(): string =
  ## Keyboard Key 1.
  "xdo key_press -k 49;xdo key_release -k 49;"

template xdo_key_2*(): string =
  ## Keyboard Key 2.
  "xdo key_press -k 50;xdo key_release -k 50;"

template xdo_key_3*(): string =
  ## Keyboard Key 3.
  "xdo key_press -k 51;xdo key_release -k 51;"

template xdo_key_4*(): string =
  ## Keyboard Key 4.
  "xdo key_press -k 52;xdo key_release -k 52;"

template xdo_key_5*(): string =
  ## Keyboard Key 5.
  "xdo key_press -k 53;xdo key_release -k 53;"

template xdo_key_6*(): string =
  ## Keyboard Key 6.
  "xdo key_press -k 54;xdo key_release -k 54;"

template xdo_key_7*(): string =
  ## Keyboard Key 7.
  "xdo key_press -k 55;xdo key_release -k 55;"

template xdo_key_8*(): string =
  ## Keyboard Key 8.
  "xdo key_press -k 56;xdo key_release -k 56;"

template xdo_key_9*(): string =
  ## Keyboard Key 9.
  "xdo key_press -k 57;xdo key_release -k 57;"

template xdo_key_wasd*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,A,S,D as fast as possible (in games,make circles).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 65;xdo key_release -k 65;xdo key_press -k 83;xdo key_release -k 83;xdo key_press -k 68;xdo key_release -k 68;".repeat(repetitions)

template xdo_key_spamm_space*(repetitions = 1.Positive): string =
  ## Keyboard Key Space as fast as possible (in games,bunny hop).
  "xdo key_press -k 32;xdo key_release -k 32;".repeat(repetitions)

template xdo_key_w_click*(repetitions = 1.Positive): string =
  ## Keyboard Key W and Mouse Left Click as fast as possible (in games,forward+hit).
  "xdo key_press -k 87;xdo key_release -k 87;xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions)

template xdo_key_w_space*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,Space as fast as possible (in games, forward+jump).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 32;xdo key_release -k 32;".repeat(repetitions)

template xdo_key_w_space_click*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,Space and Mouse Left Click (in games, forward+jump+hit).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 32;xdo key_release -k 32;xdo button_press -k 1;xdo button_release -k 1;".repeat(repetitions)

template xdo_key_w_e*(repetitions = 1.Positive): string =
  ## Keyboard Keys W,E as fast as possible (in games, forward+use).
  "xdo key_press -k 87;xdo key_release -k 87;xdo key_press -k 69;xdo key_release -k 69;".repeat(repetitions)

proc xdo_key_numbers_click*(repetitions = 1.Positive): string {.inline.} =
  ## This function types the keys like: 1,10clicks,2,10clicks,3,10clicks,etc up to 9 (in games, shoot weapons 1 to 9).
  for _ in 0..repetitions: result.add "xdo key_press -k 49;xdo key_release -k 49;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 50;xdo key_release -k 50;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 51;xdo key_release -k 51;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 52;xdo key_release -k 52;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 53;xdo key_release -k 53;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 54;xdo key_release -k 54;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 55;xdo key_release -k 55;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 56;xdo key_release -k 56;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo key_press -k 57;xdo key_release -k 57;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;xdo button_press -k 1;xdo button_release -k 1;"

template xdo_type*(letter: char): string =
  ## Type a single letter using keyboard keys from char argument.
  "xdo key_press -k " & $ord(letter) & ";xdo key_release -k " & $ord(letter) & ";"

proc xdo_type_hostOS*(): string {.inline.} =
  ## Type the hostOS using keyboard keys.
  for letter in hostOS: result.add xdo_type(letter)

proc xdo_type_hostCPU*(): string {.inline.} =
  ## Type the hostCPU using keyboard keys.
  for letter in hostCPU: result.add xdo_type(letter)

proc xdo_type_NimVersion*(): string {.inline.} =
  ## Type the current NimVersion using keyboard keys.
  for letter in NimVersion: result.add xdo_type(letter)

proc xdo_type_CompileTime*(): string {.inline.} =
  ## Type the CompileDate & CompileTime using keyboard keys.
  for letter in static(CompileDate & "T" & CompileTime): result.add xdo_type(letter)

proc xdo_type_enter*(words: string): string {.inline.} =
  ## Type the words then press Enter at the end using keyboard keys.
  for letter in words: result.add xdo_type(letter)
  result.add "xdo key_press -k 13;xdo key_release -k 13;"


runnableExamples:
  ## XDo works on Linux OS.
  when defined(linux):
    ## Basic example of mouse and keyboard control from code.
    import strutils
    echo xdo_version
    echo xdo_get_id()
    echo xdo_get_pid()
    echo xdo_move_mouse_top_left()
    echo xdo_move_mouse((x: "+99", y: "+99"))
    echo xdo_move_mouse_left_100px(2)
    echo xdo_move_mouse_top_100px(2)
    echo xdo_mouse_move_alternating((x: 9, y: 5), 3)
    echo xdo_type('a')
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
