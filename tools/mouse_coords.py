from time import sleep    # XDo do not have a mouse coord query command so use this.
from Xlib import display  # pip install python-xlib
screen = display.Display().screen()
while True:
  data = screen.root.query_pointer()._data
  print("X: ", data["root_x"], "\tY: ", data["root_y"])
  sleep(1)
