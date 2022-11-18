function ls --wraps='exa --icons --time-style iso --group' --description 'alias ls=exa --icons --time-style iso --group'
  exa --icons --time-style iso --group $argv; 
end
