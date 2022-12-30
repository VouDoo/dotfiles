function ssh --wraps='TERM=xterm /bin/ssh' --wraps='TERM=xterm /usr/bin/ssh' --description 'alias ssh=TERM=xterm /usr/bin/ssh'
  TERM=xterm /usr/bin/ssh $argv; 
end
