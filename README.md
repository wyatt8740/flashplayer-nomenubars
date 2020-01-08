# Flashplayer-menuless

When Adobe's standalone Flash player projector is run in full-screen on Linux,
keyboard controls no longer work. And even if window decorations are turned off
on the player normally, the menubar is still visible. Thus, a small hack is
needed to prevent the manifestation of the kinds of GTK+ 2 panels that
flashplayer attempts to create.

Once this hack is active, a flexible window manager can be set to maximize the
window and hide all window decorations, effectively equating to full-screen
mode but with a fully functional keyboard.

I use FVWM, and already had it configured so a keyboard shortcut could turn
off all decorations for a given window. Other WM's may have different
mechanisms for doing this.

It's also nice for just having a less-cluttered window in general.

### Installation

```
make
make install
```
will put the library in `$INSTDIR/lib` and `flashplayer_nomenu` in
`$INSTDIR/bin`. $INSTDIR defaults to `/usr/local`.
To change the install path, edit the Makefile or run
`make install INSTDIR=/path/to/install`.
Then, you can run flash, either with `flashplayer_nomenu` (a wrapper script;
treat it like invoking `flashplayer` from the CLI normally) or manually with:

```
LD_PRELOAD=/path/to/lib/flash_nomenus_override.so flashplayer [args]
```

Do note that the script assumes `flashplayer` is the name of your projector
binary, and that it is in a directory in your $PATH variable.

Ignore the console warnings about stuff like `invalid (NULL) pointer instance`;
this is a side-effect of the library stub and shouldn't impact the ability to
play flash files. Or add `2>/dev/null` to the beginning of the line in the
script that invokes the player to hide the warning messages.

Either pass the .swf as a command-line argument, or use
`ctrl-O` to open one after launching the player.

### A few details (what I learned doing this)
This was my first time trying to substitute functions in C; I'd seen it
done before for things like ['gtk3-nocsd'](https://github.com/PCMan/gtk3-nocsd)
but I had never tried to do it myself. It was surprisingly simple, actually;
more than I'd anticipated it being.

This hack is accomplished by using LD_PRELOAD to inject our own stub
functions over the ones that would normally be responsible for creating
certain GTK widgets. Due to LD_PRELOAD, our own small stub functions take
precedence over the original libgtk's function implementations.

The kinds of GTK widgets that flashplayer tries to create were checked using 
the final GTK+ 2 version of ['gtkparasite'](https://github.com/chipx86/gtkparasite/tree/0a0c90b7098d8c5b8bc06ecc88459520ad533601)
(0.2.0.71).

Since GTK+ 2 programs typically use `g_free()` to free allocated memory, and
`g_free()` does nothing if given a null pointer, it is safe in this
case to just have the stub functions return 'null' (zero) without ever
`malloc`'ing anything as the real functions would normally do.

In my experience this has worked fine.

I don't expect others will use this, but if you do, have fun!