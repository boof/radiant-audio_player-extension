module Admin::AudioHelper

  def render_tracks(object, locals = nil)
    locals = { :level => 1, :simple => false } unless Hash === locals

    render Array === object ?
        { :partial => 'track', :collection => object, :locals => locals } :
        { :partial => 'track', :object => object, :locals => locals }
  end

end

__END__
def admin_player_params(audio_track)

  if config = AudioPlayerConfig.find_by_name("Admin")
    player_params = config.parameters_for_player
  else
    player_params = ["autostart=no","loop=no"]
  end

  if audio_track.class == Audio
    player_params += ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
  else
    player_params += ["playerID=example","soundFile=#{audio_track}"]
  end

  player_params.join("&amp;")
end
