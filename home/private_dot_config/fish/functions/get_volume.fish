function get_volume --description 'Get current audio volume'
  wpctl get-volume @DEFAULT_AUDIO_SINK@
end
