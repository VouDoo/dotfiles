function lock_x_session --wraps xsecurelock --description 'lock X session'
  XSECURELOCK_NO_COMPOSITE=1 xsecurelock $argv
end
