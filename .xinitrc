export DISPLAY=:0
export WEBKIT_DISABLE_COMPOSITING_MODE=1
exec dwm &

surf -F -K -n 127.0.0.1:8000
