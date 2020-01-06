#! /bin/sh
# If your flash binary isn't in your $PATH, or if you named it differently,
# you may need to edit the following line to either be a full path to the
# program (if not in $PATH) or else your alternate name (if in $PATH already).
FLASH_BINARY='flashplayer'

# Simple wrapper script to make the Adobe Flash Player projector for Linux
# load without a menubar or URL bar.

# When the standalone projector is run in full-screen on Linux, keyboard
# controls no longer work. And even if window decorations are turned off on
# the player normally, the menubar is still visible. Thus, to get "full screen"
# while keeping keyboard controls working, a small hack is needed to prevent
# the creation of some GTK+ 2 panels.

# This is accomplished by using LD_PRELOAD to inject our own stub functions
# over the ones that would normally be responsible for creating a panel.



OVERRIDE_LIB_PATH="$HOME"'/lib/flash_nomenus_override.so'

if [ ! -z "$LD_PRELOAD" ]; then
  LD_PRELOAD="$OVERRIDE_LIB_PATH"':'"$LD_PRELOAD"
  export LD_PRELOAD
else
  LD_PRELOAD="$OVERRIDE_LIB_PATH"
  export LD_PRELOAD
fi
"$FLASH_BINARY" $@
