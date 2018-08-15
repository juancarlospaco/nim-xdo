import osproc, strformat, strutils, terminal, random

const version* = staticExec("xdo -v")  ## XDo Version (SemVer).

type
  Actions* {.pure.} = enum             ## All Actions.
    close          = "close"           ## Close the window.
    kill           = "kill"            ## Kill the client.
    hide           = "hide"            ## Unmap the window.
    show           = "show"            ## Map the window.
    raize          = "raise"           ## Raise the window.
    lower          = "lower"           ## Lower the window.
    below          = "below"           ## Put the window below the target.
    above          = "above"           ## Put the window above the target.
    move           = "move"            ## Move the window.
    resize         = "resize"          ## Resize the window.
    activate       = "activate"        ## Activate the window.
    id             = "id"              ## Print the window’s ID.
    pid            = "pid"             ## Print the window PID.
    key_press      = "key_press"       ## Simulate a key press event.
    key_release    = "key_release"     ## Simulate a key release event.
    button_press   = "button_press"    ## Simulate a button press event.
    button_release = "button_release"  ## Simulate a button release event.
    pointer_motion = "pointer_motion"  ## Simulate a pointer motion event.
randomize()

proc xdo*(action: Actions, move: tuple[x: string, y: string] = (x: "0", y: "0"),
          instance_name = "", class_name = "", wm_name = "", pid = 0,
          wait4window = false, same_desktop = true, same_class = true, same_id = true): tuple =
  ## XDo low level wrapping proc, almost all arguments are supported.
  let
    a = if wait4window: "m" else: ""
    b = if same_id: "" else: "r"
    c = if same_desktop: 'd' else: 'D'
    d = if same_class: 'c' else: 'C'
    e = if instance_name != "": fmt" -n {instance_name} " else: ""
    f = if class_name != "": fmt" -N {class_name} " else: ""
    g = if wm_name != "": fmt" -a {wm_name} " else: ""
    h = if pid != 0: fmt" -p {pid} " else: ""
    i = if move != ("0", "0"): fmt" -x {move.x} -y {move.y} " else: ""
    cmd = fmt"xdo {action} -{a}{b}{c}{d}{e}{f}{g}{h}{i}"
  execCmdEx(cmd)

proc xdo_move_mouse*(move: tuple[x: string, y: string]): tuple =
  ## Move mouse to move position pixel coordinates (X, Y).
  execCmdEx(fmt"xdo pointer_motion -x {move.x} -y {move.y}")

proc xdo_move_window*(move: tuple[x: string, y: string], pid: int): tuple =
  ## Move window to move position pixel coordinates (X, Y).
  execCmdEx(fmt"xdo move -x {move.x} -y {move.y} -p {pid}")

proc xdo_resize_window*(move: tuple[x: string, y: string], pid: int): tuple =
  ## Resize window up to move position pixel coordinates (X, Y).
  execCmdEx(fmt"xdo resize -w {move.x} -h {move.y} -p {pid}")

proc xdo_close_focused_window*(): tuple =
  ## Close the current focused window.
  execCmdEx("xdo close -c")

proc xdo_hide_focused_window*(): tuple =
  ## Hide the current focused window.
  execCmdEx("xdo hide -c")

proc xdo_hide_all_but_focused_window*(): tuple =
  ## Hide all other windows but leave the current focused window visible.
  execCmdEx("xdo hide -dr")

proc xdo_close_all_but_focused_window*(): tuple =
  ## Close all other windows but leave the current focused window open.
  execCmdEx("xdo close -dr")

proc xdo_move_mouse_top_left*(): tuple =
  ## Move mouse to Top Left limits (X=0, Y=0).
  execCmdEx("xdo pointer_motion -x 0 -y 0")

proc xdo_move_mouse_random*(maxx = 1024, maxy = 768, repetitions: int8 = 0): tuple =
  ## Move mouse to Random positions, repeat 0 to repetitions times.
  if repetitions != 0:
    for i in 0..repetitions:
      execCmdEx(fmt"xdo pointer_motion -x {maxx.rand} -y {maxy.rand}")
  else:
    execCmdEx(fmt"xdo pointer_motion -x {maxx.rand} -y {maxy.rand}")

proc xdo_move_window_random*(pid: int, maxx = 1024, maxy = 768): tuple =
  ## Move Window to Random positions.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_move_mouse_terminal_size*(): tuple =
  ## Move mouse to the detected current Terminal Size.
  execCmdEx(fmt"xdo pointer_motion -x {terminalWidth()} -y {terminalHeight()}")

proc xdo_move_mouse_top_100px*(repetitions: int8): tuple =
  ## Move mouse to Top Y=0, then repeat move Bottom on jumps of 100px each.
  execCmdEx("xdo pointer_motion -y 0")
  for i in 0..repetitions:
    execCmdEx("xdo pointer_motion -y +100")

proc xdo_move_mouse_left_100px*(repetitions: int8): tuple =
  ## Move mouse to Left X=0, then repeat move Right on jumps of 100px each.
  execCmdEx("xdo pointer_motion -x 0")
  for i in 0..repetitions:
    execCmdEx("xdo pointer_motion -x +100")

discard """
get_pid()

get_id()

proc xdo_mouse_move_alternating*(): tuple =
  ## Move mouse alternating to Left and Right, AKA ZigZag move.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_mouse_left_click*(): tuple =
  ## Mouse Left Click, 1 repetitions.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_mouse_right_click*(): tuple =
  ## Mouse Right Click, 1 repetitions.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_mouse_double_left_click*(): tuple =
  ## Mouse Left Click, 2 repetitions (Double Click).
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_mouse_triple_left_click*(): tuple =
  ## Mouse Left Click, 3 repetitions (Triple Click).
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

pproc xdo_mouse_double_left_click*(): tuple =
  ## Mouse Left Click, 2 repetitions (Double Click).
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")roc xdo_type_double_left_click*(): tuple =
  ## Mouse Left Click, 2 repetitions (Double Click).
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_type*(words: string, repetitions = 0): tuple =
  ## Type words using keyboard keys.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_type_temp_dir*(): tuple =
  ## Type the system temporary directory full path using keyboard keys.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_type_current_dir*(): tuple =
  ## Type the current working directory full path using keyboard keys.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")

proc xdo_type_datetime*(): tuple =
  ## Type the current Date & Time (ISO-Format) using keyboard keys.
  execCmdEx(fmt"xdo move -x {maxx.rand} -y {maxy.rand} -p {pid}")
"""

when is_main_module:
  echo version
  echo xdo(Actions.pid)
  echo xdo_move_mouse((x: "+9", y: "-9"))
