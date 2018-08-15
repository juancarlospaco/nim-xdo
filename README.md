# nim-xdo

Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.

![Keyboard](https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg "Keyboard typing simulation for everyone")


# install

- `nimble install xdo`


# Requirements

- [XDo](https://github.com/baskerville/xdo#xdo1) *(20 Kilobytes pure C lib with no dependencies)*


# Use

```nim
import xdo
echo xdo_version                         # XDo Version (SemVer) when compiled.
xdo_get_id()                             # Get current focused window ID.
xdo_get_pid()                            # Get current focused window PID.
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
```

Theres 2 JSON `keycode2char` and `char2keycode` to convert KeyCodes integers to/from Characters strings (human readable keyboard keys).

- **Pull Requests are very welcome!.**
- Run `nim doc xdo.nim` for more documentation.
- Run the module itself for an Example.
- [Nim GUI Automation on Windows OS.](https://nimble.directory/pkg/autome)
