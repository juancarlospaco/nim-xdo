# nim-xdo

Nim XDO is a GUI Automation Wrapper for Linux to simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.

![Keyboard](https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg "Keyboard typing simulation for everyone")


# Requirements

You need to install [xdo](https://github.com/baskerville/xdo) before using `nim-xdo`.

The [`check_deps.sh`](./check_deps.sh) script will run to check if you have [xdo](https://github.com/baskerville/xdo) installed and help you install it.
The script runs at `nimble install` automatically.

If you want to install it manually, do:

```bash
git clone https://github.com/baskerville/xdo
cd xdo # go into dir
make
sudo make install

# cleanup
cd ..; rm -rf xdo
```


## Install

- There are two ways of installing **nim-xdo**

### From Nimble
*(recommended)*

```bash
nimble install xdo
```

### From Github

```bash
git clone https://github.com/juancarlospaco/nim-xdo.git
cd xdo
nimble install
```


# Use

<details open >

```nim
import xdo

echo version # XDo Version (SemVer) when compiled.
get_id()     # Get current focused window ID.
get_pid()    # Get current focused window PID.

move_mouse((x: "1000", y: "500"))    # Move Mouse by Absolute Coordinates.
move_mouse((x: "+50", y: "-75"))     # Move Mouse by Relative Delta.
move_window((x: "500", y: "1000"))   # Move Window by Absolute Coordinates.
resize_window((x: "1024", y: "768")) # Resize Window by Absolute Coordinates.
close_focused_window()               # Close current focused window.
move_mouse_top_left()                # Move Mouse to 0,0 Coordinates.
move_mouse_random(repetitions = 3)   # Move Mouse randomly, repeat 3 times.
move_mouse_top_100px(repetitions = 5) # Move mouse to Y=0 then move on jumps of 100px.
mouse_move_alternating((x: 99, y: 75), repetitions = 9) # Move Mouse on ZigZag, repeat 9 times.
hide_focused_window()          # Hide the current focused window. This is NOT Minimize.
show_focused_window()          # Hide the current focused window. This is NOT Maximize.
raise_focused_window()         # Raise up the current focused window.
lower_focused_window()         # Lower down the current focused window.
activate_this_window(pid: 666) # Force to Activate this window by PID.
raise_all_but_focused_window() # Raise up all other windows but the current focused window.
lower_all_but_focused_window() # Lower down all other windows but the current focused window.
show_all_but_focused_window()  # Show all other windows but the current focused window.

mouse_left_click()           # Mouse Left Click.
mouse_middle_click()         # Mouse Middle Click.
mouse_right_click()          # Mouse Right Click.
mouse_double_left_click()    # Mouse Double Left Click.
mouse_double_middle_click()  # Mouse Double Middle Click.
mouse_double_right_click()   # Mouse Double Right Click.
mouse_triple_left_click()    # Mouse Triple Left Click.
mouse_triple_middle_click()  # Mouse Triple Middle Click.
mouse_triple_right_click()   # Mouse Triple Right Click.
mouse_spamm_left_click(100)  # Spamm Mouse Left Click as fast as possible.
mouse_spamm_middle_click(9)  # Spamm Mouse Middle Click as fast as possible.
mouse_spamm_right_click(50)  # Spamm Mouse Right Click as fast as possible.
mouse_swipe_horizontal("+9") # Mouse Swipe to Left or Right.
mouse_swipe_vertical("-99")  # Mouse Swipe to Up or Down.

key_backspace()    # Keyboard Key Backspace.
key_tab()          # Keyboard Key Tab.
key_enter()        # Keyboard Key Enter.
key_shift()        # Keyboard Key Shift.
key_ctrl()         # Keyboard Key Ctrl.
key_alt()          # Keyboard Key Alt.
key_pause()        # Keyboard Key Pause.
key_capslock()     # Keyboard Key Caps Lock.
key_esc()          # Keyboard Key Esc.
key_space()        # Keyboard Key Space.
key_pageup()       # Keyboard Key Page Up.
key_pagedown()     # Keyboard Key Page Down.
key_end()          # Keyboard Key End.
key_home()         # Keyboard Key Home.
key_arrow_left()   # Keyboard Key Arrow Left.
key_arrow_up()     # Keyboard Key Arrow Up.
key_arrow_right()  # Keyboard Key Arrow Right.
key_arrow_down()   # Keyboard Key Arrow Down.
key_insert()       # Keyboard Key Insert.
key_delete()       # Keyboard Key Delete.
key_numlock()      # Keyboard Key Num Lock.
key_scrolllock()   # Keyboard Key Scroll Lock.
key_mycomputer()   # Keyboard Key My Computer (HotKey thingy).
key_mycalculator() # Keyboard Key My Calculator (HotKey thingy).
key_windows()      # Keyboard Key Windows (AKA Meta Key).
key_rightclick()   # Keyboard Key Right Click (HotKey thingy).

key_numpad0()         # Keyboard Key Numeric Pad 0.
key_numpad1()         # Keyboard Key Numeric Pad 1.
key_numpad2()         # Keyboard Key Numeric Pad 2.
key_numpad3()         # Keyboard Key Numeric Pad 3.
key_numpad4()         # Keyboard Key Numeric Pad 4.
key_numpad5()         # Keyboard Key Numeric Pad 5.
key_numpad6()         # Keyboard Key Numeric Pad 6.
key_numpad7()         # Keyboard Key Numeric Pad 7.
key_numpad8()         # Keyboard Key Numeric Pad 8.
key_numpad9()         # Keyboard Key Numeric Pad 9.
key_numpad_asterisk() # Keyboard Key Numeric Pad "*".
key_numpad_plus()     # Keyboard Key Numeric Pad "+".
key_numpad_minus()    # Keyboard Key Numeric Pad "-".
key_numpad_dot()      # Keyboard Key Numeric Pad ".".
key_numpad_slash()    # Keyboard Key Numeric Pad "/".

key_f1()      # Keyboard Key F1.
key_f2()      # Keyboard Key F2.
key_f3()      # Keyboard Key F3.
key_f4()      # Keyboard Key F4.
key_f5()      # Keyboard Key F5.
key_f6()      # Keyboard Key F6.
key_f7()      # Keyboard Key F7.
key_f8()      # Keyboard Key F8.
key_f9()      # Keyboard Key F9.
key_f10()     # Keyboard Key F10.
key_f11()     # Keyboard Key F11.
key_f12()     # Keyboard Key F12.

key_0()       # Keyboard Key 0.
key_1()       # Keyboard Key 1.
key_2()       # Keyboard Key 2.
key_3()       # Keyboard Key 3.
key_4()       # Keyboard Key 4.
key_5()       # Keyboard Key 5.
key_6()       # Keyboard Key 6.
key_7()       # Keyboard Key 7.
key_8()       # Keyboard Key 8.
key_9()       # Keyboard Key 9.

tipe('a')           # Any letter of Keyboard Keys as char.

# This Procs are oriented to multipurpose automation, scripting, etc.
type_temp_dir()     # Type the system temporary directory full path using keyboard keys.
type_current_dir()  # Type the current working directory full path using keyboard keys.
type_hostOS()       # Type the hostOS using keyboard keys.
type_hostCPU()      # Type the hostCPU using keyboard keys.
type_NimVersion()   # Type the current NimVersion using keyboard keys.
type_CompileTime()  # Type the CompileDate & CompileTime using keyboard keys.
type_enter("words") # Type the words then press Enter at the end using keyboard keys.

# This Procs are oriented to Gaming, Game Bots, Game Macros, Game Automation, Streamers, etc.
key_wasd(10)         # Keyboard Keys W,A,S,D as fast as possible (in games,make circles).
key_spamm_space(9)   # Keyboard Key Space as fast as possible (in games,bunny hop).
key_w_click(100)     # Keyboard Key W and Mouse Left Click as fast as possible (in games,forward+hit).
key_w_space(120)     # Keyboard Keys W,Space as fast as possible (in games, forward+jump).
key_w_e(125)         # Keyboard Keys W,E as fast as possible (in games, forward+use).
key_w_space_click(9) # Keyboard Keys W,Space and Mouse Left Click (in games, forward+jump+hit).
key_wasd_random(100) # Keyboard Keys W,A,S,D,space Randomly as fast as possible.
key_numbers_click(9) # 1,10clicks,2,10clicks,3,10clicks,etc up to 9 (in games, shoot weapons 1 to 9).

# xdo() is also available as a very low level wrapper for XDo for advanced developers.
```

</details>

- **Pull Requests are very welcome!.**
- [Check Docs on Nimble.](https://nimble.directory/docs/xdo//xdo.html)
- Run `nim doc xdo.nim` for more documentation.
- Run the module itself for an Example.
- [Nim GUI Automation on Windows OS.](https://nimble.directory/pkg/autome)


# Dependencies

- [XDo](https://github.com/baskerville/xdo#xdo1) *(20 Kilobytes pure C lib with no dependencies)*
