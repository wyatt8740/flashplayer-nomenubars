/* #include <gtk-2.0/gtk/gtkmenubar.h>*/
#include <gtk/gtk.h>

/* When the standalone projector is run in full-screen on Linux, keyboard
 * controls no longer work. And even if window decorations are turned off on
 * the player normally, the menubar is still visible. Thus, to get a
 * "full screen" while still using keyboard controls, a small hack is needed to
 * prevent the creation of the kinds of GTK+ 2 panels that flashplayer tries
 * to make.

 * This is accomplished by using LD_PRELOAD to inject our own stub functions
 * over the ones that would normally be responsible for creating a panel, by
 * making our own small stub library take precedence over the original libgtk.

 * These are the kinds of GTK widgets that flashplayer tries to create, as 
 * verified using the GTK+ 2 version of 'gtkparasite'.

 * Since GTK+ 2 programs typically use g_free() to free allocated memory, and
 * g_free() does nothing if given a null pointer, it is likely safe in this
 * case to just have the stub functions return 'null' (zero) without ever
 * malloc'ing anything.

 * If this causes any stability issues (like if Adobe's developers decided to
 * use ANSI C's free() instead of glib's g_free()), replace the '\0's with
 * malloc(1).
*/

/* define RET malloc(1)*/
/* alternative,
 * probably-working-but-can't-guarantee-without-flash's-source-code form: */
#define RET '\0'

GtkWidget* gtk_menu_bar_new(void)
{
  return RET;
}

GtkWidget* gtk_label_new (const gchar *str)
{
  return RET;
}

GtkWidget* gtk_entry_new (void)
{
  return RET;
}

GtkWidget * gtk_hbox_new (gboolean homogeneous, gint spacing)
{
  return RET;
}

