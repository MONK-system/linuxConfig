cd ~/system/monksystem/
python3 manage.py runserver &

if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then 
  exec startx
fi
