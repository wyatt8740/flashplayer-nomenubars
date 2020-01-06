# Flashplayer-NoWidgets
## Standalone Flash Player, now without menu bars.

When Adobe's standalone Flash player projector is run in full-screen on Linux,
keyboard controls no longer work. And even if window decorations are turned off
on the player normally, the menubar is still visible. Thus, a small hack is
needed to prevent the manifestation of the kinds of GTK+ 2 panels that
flashplayer attempts to create.

Once this hack is active, a flexible window manager can be set to maximize the
window and hide all window decorations, effectively equating to full-screen
mode but with a fully functional keyboard.

I use FVWM, and already had it configured so a keyboard shortcut could turn
off all decorations for a given window.

### Installation

```
make
make install
```
will put the library in `~/lib`. To change the install path, edit the Makefile.
Then, you can run flash, either with `flashplayer_nomenu.sh` or manually:

```
LD_PRELOAD=$HOME/lib/flash_nomenus_override.so flashplayer [args]
```

Ignore the console warnings about stuff like `invalid (NULL) pointer instance`;
this is a side-effect of the library stub and shouldn't impact the ability to
play flash files. Either pass the .swf as a command-line argument, or use
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
`g_free()` does nothing if given a null pointer, it is likely safe in this
case to just have the stub functions return 'null' (zero) without ever
`malloc`'ing anything.

In my experience this has worked, but I opted to use malloc(1) in the version
I am sharing because it's a little less fragile and assumes the worst from
Adobe (that Adobe's developers used ANSI C free() instead of g_free() from
glib). This is not out ouf malice towards Adobe, but out of being cautious.
Without source code to refer to, it is hard to know which they used and
malloc(1) should be more tolerant of either free() variant.

To save maybe a couple of bytes of RAM, change the definition of `RET` from
`malloc(1)` to `'\0'` inside of `override.c`.

I don't expect others will use this, but if you do, have fun!
