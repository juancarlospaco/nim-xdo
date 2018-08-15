# nim-xdo

Nim GUI Automation Linux, simulate user interaction, mouse and keyboard control from Nim code, procs for common actions.


# install

- `nimble install xdo`


# Requirements

- [XDo](https://github.com/baskerville/xdo#xdo1)


# Use

```nim
import xdo
xdo_get_id()
xdo_get_pid()
xdo_move_mouse((x: "1000", y: "500"))
xdo_move_window((x: "500", y: "1000"))
xdo_resize_window((x: "1024", y: "768"))
xdo_close_focused_window()
xdo_move_mouse_top_left()
xdo_move_mouse_random(repetitions = 3)
xdo_move_mouse_top_100px(repetitions = 5)
xdo_mouse_move_alternating((x: 99, y: 75), repetitions = 9)
```

- **Pull Requests are very welcome!.**
- Run `nim doc xdo.nim` for more documentation.
- Run the module itself for an Example.
