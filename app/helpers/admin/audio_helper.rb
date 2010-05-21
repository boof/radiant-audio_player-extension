module Admin::AudioHelper

  def render_tracks(object, locals = nil)
    locals = { :level => 1, :simple => false } unless Hash === locals

    render Array === object ?
        { :partial => 'track', :collection => object, :locals => locals } :
        { :partial => 'track', :object => object, :locals => locals }
  end

  def include_jplayer
    include_javascript %w[ http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js audio-player/jquery.jplayer.min audio-player/audio-player ]
    include_stylesheet 'admin/audio-player.css'
  end

end

__END__
player_params = ["autostart=no","loop=no"]
player_params += ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
