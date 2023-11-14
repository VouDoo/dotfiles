function wifi --wraps=iwd --wraps=iwctl --description 'alias wifi=iwctl'
  iwctl $argv; 
end
