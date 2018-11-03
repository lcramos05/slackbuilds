#!/bin/sh

config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

update_desktop_database() {
  if [ -x /usr/bin/update-desktop-database ]; then
    /usr/bin/update-desktop-database -q /usr/share/applications >/dev/null 2>&1
  fi
}

update_mime_database() {
  if [ -x /usr/bin/update-mime-database ]; then
    /usr/bin/update-mime-database /usr/share/mime >/dev/null 2>&1
  fi
}

update_gnome_icon_theme() {
  if [ -e usr/share/icons/gnome/icon-theme.cache ]; then
    if [ -x /usr/bin/gtk-update-icon-cache ]; then
      /usr/bin/gtk-update-icon-cache /usr/share/icons/gnome >/dev/null 2>&1
    fi
  fi
}

compile_glib2_schemas() {
  if [ -x /usr/bin/glib-compile-schemas -a -d /usr/share/glib-2.0/schemas ]; then
    /usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas/
  fi
}


# main entry point
update_desktop_database
update_gnome_icon_theme
compile_glib2_schemas

