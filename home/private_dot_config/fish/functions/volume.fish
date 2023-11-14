function volume --wraps='wpctl get-volume @DEFAULT_AUDIO_SINK@' --description 'alias volume=wpctl get-volume @DEFAULT_AUDIO_SINK@'
  wpctl get-volume @DEFAULT_AUDIO_SINK@ $argv; 
end
