#!/bin/bash
# Handle quicklaunch:// links in GNOME Wayland
# Usage: app-open-or-raise quicklaunch://<name>
# Files quicklaunch-url.desktop must be found under ~/.local/share/applications
# They must be registered with:
# update-desktop-database ~/.local/share/applications/
# xdg-mime default quicklaunch-url.desktop x-scheme-handler/quicklaunch


echo "Received: $1" >> /tmp/app-handler.log

URL="$1"
APP_NAME="${URL#quicklaunch://}"   # extract part after app://

case "$APP_NAME" in
    thunderbird)
        APP_ID="thunderbird.desktop"
        ;;
    nautilus)
        APP_ID="org.gnome.Nautilus.desktop"
        ;;
    *)
        echo "Unknown app: $APP_NAME"
        exit 1
        ;;
esac

# If app is already running, ask GNOME Shell to raise it
if pgrep -x "${CMD}" >/dev/null; then
    gdbus call \
        --session \
        --dest org.gnome.Shell \
        --object-path /org/gnome/Shell \
        --method org.gnome.Shell.Eval \
        "imports.gi.Shell.AppSystem.get_default().lookup_app('$APP_ID').activate();"
else
    gtk-launch "$APP_ID"
fi
