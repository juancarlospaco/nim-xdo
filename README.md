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
move_mouse_random(repetitions = 3)   # Move Mouse randomly, repeat 3 times.
move_mouse_top_100px(repetitions = 5) # Move mouse to Y=0 then move on jumps of 100px.
mouse_move_alternating((x: 99, y: 75), repetitions = 9) # Move Mouse on ZigZag, repeat 9 times.
activate_this_window(pid: 666) # Force to Activate this window by PID.

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
