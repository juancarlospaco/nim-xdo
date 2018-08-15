# nim-xdo

Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.

![Keyboard](https://raw.githubusercontent.com/juancarlospaco/nim-xdo/master/keyboard_kitten.jpg "Keyboard typing simulation for everyone")


# install

- `nimble install xdo`


# Requirements

- [XDo](https://github.com/baskerville/xdo#xdo1 "Tiny pure C lib")


# Use

```nim
import xdo
xdo_get_id()                             # Get current focused window ID.
xdo_get_pid()                            # Get current focused window PID.
xdo_move_mouse((x: "1000", y: "500"))    # Move Mouse by Absolute Coordinates.
xdo_move_mouse((x: "+50", y: "-75"))     # Move Mouse by Relative Delta.
xdo_move_window((x: "500", y: "1000"))   # Move Window by Absolute Coordinates.
xdo_resize_window((x: "1024", y: "768")) # Resize Window by Absolute Coordinates.
xdo_close_focused_window()               # Close current focused window.
xdo_move_mouse_top_left()                # Move Mouse to 0,0 Coordinates.
xdo_move_mouse_random(repetitions = 3)   # Move Mouse randomly, repeat 3 times.
xdo_move_mouse_top_100px(repetitions = 5) # Move mouse to 0,0 then move on jumps of 100px.
xdo_mouse_move_alternating((x: 99, y: 75), repetitions = 9) # Move Mouse on ZigZag.
```

- **Pull Requests are very welcome!.**
- Run `nim doc xdo.nim` for more documentation.
- Run the module itself for an Example.
