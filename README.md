# nim-xdo

Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.

![Keyboard](https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg "Keyboard typing simulation for everyone")


# install

- `nimble install xdo`


# Requirements

- [XDo](https://github.com/baskerville/xdo#xdo1) *(20 Kilobytes pure C lib with no dependencies)*


# Use

<details open >

```nim
import xdo

echo xdo_version # XDo Version (SemVer) when compiled.
xdo_get_id()     # Get current focused window ID.
xdo_get_pid()    # Get current focused window PID.

xdo_move_mouse((x: "1000", y: "500"))    # Move Mouse by Absolute Coordinates.
xdo_move_mouse((x: "+50", y: "-75"))     # Move Mouse by Relative Delta.
xdo_move_window((x: "500", y: "1000"))   # Move Window by Absolute Coordinates.
xdo_resize_window((x: "1024", y: "768")) # Resize Window by Absolute Coordinates.
xdo_close_focused_window()               # Close current focused window.
xdo_move_mouse_top_left()                # Move Mouse to 0,0 Coordinates.
xdo_move_mouse_random(repetitions = 3)   # Move Mouse randomly, repeat 3 times.
xdo_move_mouse_top_100px(repetitions = 5) # Move mouse to Y=0 then move on jumps of 100px.
xdo_mouse_move_alternating((x: 99, y: 75), repetitions = 9) # Move Mouse on ZigZag, repeat 9 times.
xdo_hide_focused_window()          # Hide the current focused window. This is NOT Minimize.
xdo_show_focused_window()          # Hide the current focused window. This is NOT Maximize.
xdo_raise_focused_window()         # Raise up the current focused window.
xdo_lower_focused_window()         # Lower down the current focused window.
xdo_activate_this_window(pid: 666) # Force to Activate this window by PID.
xdo_raise_all_but_focused_window() # Raise up all other windows but the current focused window.
xdo_lower_all_but_focused_window() # Lower down all other windows but the current focused window.
xdo_show_all_but_focused_window()  # Show all other windows but the current focused window.

xdo_mouse_left_click()           # Mouse Left Click.
xdo_mouse_middle_click()         # Mouse Middle Click.
xdo_mouse_right_click()          # Mouse Right Click.
xdo_mouse_double_left_click()    # Mouse Double Left Click.
xdo_mouse_double_middle_click()  # Mouse Double Middle Click.
xdo_mouse_double_right_click()   # Mouse Double Right Click.
xdo_mouse_triple_left_click()    # Mouse Triple Left Click.
xdo_mouse_triple_middle_click()  # Mouse Triple Middle Click.
xdo_mouse_triple_right_click()   # Mouse Triple Right Click.
xdo_mouse_spamm_left_click(100)  # Spamm Mouse Left Click as fast as possible.
xdo_mouse_spamm_middle_click(9)  # Spamm Mouse Middle Click as fast as possible.
xdo_mouse_spamm_right_click(50)  # Spamm Mouse Right Click as fast as possible.
xdo_mouse_swipe_horizontal("+9") # Mouse Swipe to Left or Right.
xdo_mouse_swipe_vertical("-99")  # Mouse Swipe to Up or Down.

xdo_key_backspace()    # Keyboard Key Backspace.
xdo_key_tab()          # Keyboard Key Tab.
xdo_key_enter()        # Keyboard Key Enter.
xdo_key_shift()        # Keyboard Key Shift.
xdo_key_ctrl()         # Keyboard Key Ctrl.
xdo_key_alt()          # Keyboard Key Alt.
xdo_key_pause()        # Keyboard Key Pause.
xdo_key_capslock()     # Keyboard Key Caps Lock.
xdo_key_esc()          # Keyboard Key Esc.
xdo_key_space()        # Keyboard Key Space.
xdo_key_pageup()       # Keyboard Key Page Up.
xdo_key_pagedown()     # Keyboard Key Page Down.
xdo_key_end()          # Keyboard Key End.
xdo_key_home()         # Keyboard Key Home.
xdo_key_arrow_left()   # Keyboard Key Arrow Left.
xdo_key_arrow_up()     # Keyboard Key Arrow Up.
xdo_key_arrow_right()  # Keyboard Key Arrow Right.
xdo_key_arrow_down()   # Keyboard Key Arrow Down.
xdo_key_insert()       # Keyboard Key Insert.
xdo_key_delete()       # Keyboard Key Delete.
xdo_key_numlock()      # Keyboard Key Num Lock.
xdo_key_scrolllock()   # Keyboard Key Scroll Lock.
xdo_key_mycomputer()   # Keyboard Key My Computer (HotKey thingy).
xdo_key_mycalculator() # Keyboard Key My Calculator (HotKey thingy).
xdo_key_windows()      # Keyboard Key Windows (AKA Meta Key).
xdo_key_rightclick()   # Keyboard Key Right Click (HotKey thingy).

xdo_key_numpad0()         # Keyboard Key Numeric Pad 0.
xdo_key_numpad1()         # Keyboard Key Numeric Pad 1.
xdo_key_numpad2()         # Keyboard Key Numeric Pad 2.
xdo_key_numpad3()         # Keyboard Key Numeric Pad 3.
xdo_key_numpad4()         # Keyboard Key Numeric Pad 4.
xdo_key_numpad5()         # Keyboard Key Numeric Pad 5.
xdo_key_numpad6()         # Keyboard Key Numeric Pad 6.
xdo_key_numpad7()         # Keyboard Key Numeric Pad 7.
xdo_key_numpad8()         # Keyboard Key Numeric Pad 8.
xdo_key_numpad9()         # Keyboard Key Numeric Pad 9.
xdo_key_numpad_asterisk() # Keyboard Key Numeric Pad "*".
xdo_key_numpad_plus()     # Keyboard Key Numeric Pad "+".
xdo_key_numpad_minus()    # Keyboard Key Numeric Pad "-".
xdo_key_numpad_dot()      # Keyboard Key Numeric Pad ".".
xdo_key_numpad_slash()    # Keyboard Key Numeric Pad "/".

xdo_key_f1()      # Keyboard Key F1.
xdo_key_f2()      # Keyboard Key F2.
xdo_key_f3()      # Keyboard Key F3.
xdo_key_f4()      # Keyboard Key F4.
xdo_key_f5()      # Keyboard Key F5.
xdo_key_f6()      # Keyboard Key F6.
xdo_key_f7()      # Keyboard Key F7.
xdo_key_f8()      # Keyboard Key F8.
xdo_key_f9()      # Keyboard Key F9.
xdo_key_f10()     # Keyboard Key F10.
xdo_key_f11()     # Keyboard Key F11.
xdo_key_f12()     # Keyboard Key F12.

xdo_key_0()       # Keyboard Key 0.
xdo_key_1()       # Keyboard Key 1.
xdo_key_2()       # Keyboard Key 2.
xdo_key_3()       # Keyboard Key 3.
xdo_key_4()       # Keyboard Key 4.
xdo_key_5()       # Keyboard Key 5.
xdo_key_6()       # Keyboard Key 6.
xdo_key_7()       # Keyboard Key 7.
xdo_key_8()       # Keyboard Key 8.
xdo_key_9()       # Keyboard Key 9.

# This Procs are oriented to multipurpose automation, scripting, etc.
xdo_type('a')           # Any letter of Keyboard Keys as char.
xdo_type_temp_dir()     # Type the system temporary directory full path using keyboard keys.
xdo_type_current_dir()  # Type the current working directory full path using keyboard keys.
xdo_type_hostOS()       # Type the hostOS using keyboard keys.
xdo_type_hostCPU()      # Type the hostCPU using keyboard keys.
xdo_type_NimVersion()   # Type the current NimVersion using keyboard keys.
xdo_type_CompileTime()  # Type the CompileDate & CompileTime using keyboard keys.
xdo_type_enter("words") # Type the words then press Enter at the end using keyboard keys.

# This Procs are oriented to Gaming, Game Bots, Game Macros, Game Automation, Streamers, etc.
xdo_key_wasd(10)         # Keyboard Keys W,A,S,D as fast as possible (in games,make circles).
xdo_key_spamm_space(9)   # Keyboard Key Space as fast as possible (in games,bunny hop).
xdo_key_w_click(100)     # Keyboard Key W and Mouse Left Click as fast as possible (in games,forward+hit).
xdo_key_w_space(120)     # Keyboard Keys W,Space as fast as possible (in games, forward+jump).
xdo_key_w_e(125)         # Keyboard Keys W,E as fast as possible (in games, forward+use).
xdo_key_w_space_click(9) # Keyboard Keys W,Space and Mouse Left Click (in games, forward+jump+hit).
xdo_key_wasd_random(100) # Keyboard Keys W,A,S,D,space Randomly as fast as possible.
xdo_key_numbers_click(9) # 1,10clicks,2,10clicks,3,10clicks,etc up to 9 (in games, shoot weapons 1 to 9).

# xdo() is also available as a very low level wrapper for XDo for advanced developers.
```

</details>

Theres 2 JSON `keycode2char` and `char2keycode` to convert KeyCodes integers to/from Characters strings (human readable keyboard keys).

- **Pull Requests are very welcome!.**
- Run `nim doc xdo.nim` for more documentation.
- Run the module itself for an Example.
- [Nim GUI Automation on Windows OS.](https://nimble.directory/pkg/autome)
