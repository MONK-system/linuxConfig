source /monk/system/monkenv/bin/activate
cd /monk/system/monksystem

gunicorn --bind 127.0.0.0:8000 monksystem.wsgi:application &

if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi
