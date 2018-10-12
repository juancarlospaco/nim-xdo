#!/usr/bin/bash

# check if xdo is installed
if hash xdo 2> /dev/null; then
  exit 0

else
  echo "xdo is not installed"
  if hash git 2> /dev/null; then
    # Prompt if user wants to install xdo
    echo "Do you want to install xdo? (y/n) "
    read input

    if [[ $input != "n" ]]; then
      echo "xdo is installing..."
      cd /tmp  # Move to the Temp folder.
      git clone -q https://github.com/baskerville/xdo # clone te repo
      cd xdo # go into dir
      make              # > /dev/null # If you dont want to see the info uncomment
      sudo make install # > /dev/null # sudo will prompt user for password

      cd ..; rm -rf xdo # cleanup
      echo "Done! xdo should now be installed."

    else
      echo "OK. Aborting..."; exit 1
    fi

  else
    echo "ERR: git is not installed. Aborting..."; exit 1
  fi
fi
