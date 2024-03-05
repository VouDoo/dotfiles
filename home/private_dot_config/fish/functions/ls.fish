function ls --wraps eza --description 'alias Use eza instead of ls'
  eza --icons --time-style iso --group $argv
end
