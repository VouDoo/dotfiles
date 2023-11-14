function ll --wraps=ls --wraps='ls --long' --description 'alias ll=ls --long'
  ls --long $argv; 
end
