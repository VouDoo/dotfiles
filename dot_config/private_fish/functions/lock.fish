function lock --description 'lock X session'
  XSECURELOCK_NO_COMPOSITE=1 xsecurelock; 
end
