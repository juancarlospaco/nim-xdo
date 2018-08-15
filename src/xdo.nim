import osproc, strformat, strutils, terminal, random, json

const version* = staticExec("xdo -v")  ## XDo Version (SemVer).

let
  keycode2char* = %* {
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
  }  ## Statically compiled JSON that maps KeyCodes integers Versus Keys strings.
  char2keycode* = %* {
    "backspace":8,"tab":9,"enter":13,"shift":16,"ctrl":17,"alt":18,
    "pause/break":19,"caps lock":20,"esc":27,"space":32,"page up":33,
    "page down":34,"end":35,"home":36,"left":37,"up":38,"right":39,"down":40,
    "insert":45,"delete":46,"0":48,"1":49,"2":50,"3":51,"4":52,"5":53,"6":54,
    "7":55,"8":56,"9":57,"a":65,"b":66,"c":67,"d":68,"e":69,"f":70,"g":71,
    "h":72,"i":73,"j":74,"k":75,"l":76,"m":77,"n":78,"o":79,"p":80,"q":81,
    "r":82,"s":83,"t":84,"u":85,"v":86,"w":87,"x":88,"y":89,"z":90,"windows":91,
    "right click":93,"numpad 0":96,"numpad 1":97,"numpad 2":98,"numpad 3":99,
    "numpad 4":100,"numpad 5":101,"numpad 6":102,"numpad 7":103,"numpad 8":104,
    "numpad 9":105,"numpad *":106,"numpad +":107,"numpad -":109,"numpad .":110,
    "numpad /":111,"f1":112,"f2":113,"f3":114,"f4":115,"f5":116,"f6":117,
    "f7":118,"f8":119,"f9":120,"f10":121,"f11":122,"f12":123,"num lock":144,
    "scroll lock":145,"my computer":182,"my calculator":183,";":186,"=":187,
    ",":188,"-":189,".":190,"/":191,"`":192,"[":219,"\\":220,"]":221,"'":222
  }  ## Statically compiled JSON that maps Keys strings Versus KeyCodes integers.

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
      result = execCmdEx(fmt"xdo pointer_motion -x {rand(maxx)} -y {rand(maxy)}")
  else:
    result = execCmdEx(fmt"xdo pointer_motion -x {rand(maxx)} -y {rand(maxy)}")

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
    result = execCmdEx("xdo pointer_motion -y +100")

proc xdo_move_mouse_left_100px*(repetitions: int8): tuple =
  ## Move mouse to Left X=0, then repeat move Right on jumps of 100px each.
  execCmdEx("xdo pointer_motion -x 0")
  for i in 0..repetitions:
    execCmdEx("xdo pointer_motion -x +100")

proc xdo_get_pid*(): string =
  ## Get PID of a window, integer type.
  parseHexStr(execCmdEx("xdo pid").output.strip)

proc xdo_get_id*(): string =
  ## Get ID of a window, integer type.
  execCmdEx("xdo id").output.strip

proc xdo_mouse_move_alternating*(move: tuple[x: int, y: int], repetitions: int8): tuple =
  ## Move mouse alternating to Left/Right Up/Down, AKA Zig-Zag movements.
  var xx, yy: string
  for i in 0..repetitions:
    xx = if i mod 2 == 0: "+" else: "-" & $move.x
    yy = if i mod 2 == 0: "+" else: "-" & $move.y
    result = execCmdEx(fmt"xdo pointer_motion -x {xx} -y {yy}")


discard """
proc xdo_mouse_left_click*(): tuple =
  ## Mouse Left Click, 1 repetitions.
  execCmdEx(fmt"")

proc xdo_mouse_right_click*(): tuple =
  ## Mouse Right Click, 1 repetitions.
  execCmdEx(fmt"")

proc xdo_mouse_double_left_click*(): tuple =
  ## Mouse Left Click, 2 repetitions (Double Click).
  execCmdEx(fmt"")

proc xdo_mouse_triple_left_click*(): tuple =
  ## Mouse Left Click, 3 repetitions (Triple Click).
  execCmdEx(fmt"")

pproc xdo_mouse_double_left_click*(): tuple =
  ## Mouse Left Click, 2 repetitions (Double Click).
  execCmdEx(fmt"")

proc xdo_type*(words: string, repetitions = 0): tuple =
  ## Type words using keyboard keys.
  execCmdEx(fmt"")

proc xdo_type_temp_dir*(): tuple =
  ## Type the system temporary directory full path using keyboard keys.
  execCmdEx(fmt"")

proc xdo_type_current_dir*(): tuple =
  ## Type the current working directory full path using keyboard keys.
  execCmdEx(fmt"")

proc xdo_type_datetime*(): tuple =
  ## Type the current Date & Time (ISO-Format) using keyboard keys.
  execCmdEx(fmt"")
"""


when is_main_module:
  echo version
  echo xdo_get_id()
  echo xdo_get_pid()
  echo xdo_move_mouse_random()
  echo xdo_move_mouse_top_left()
  echo xdo_move_mouse((x: "+9", y: "-9"))
