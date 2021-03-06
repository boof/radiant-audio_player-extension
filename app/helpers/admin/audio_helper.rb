module Admin::AudioHelper
  include Admin::NodeHelper

  def render_tracks(object, locals = nil)
    locals = { :level => 1, :simple => false } unless Hash === locals

    render Track === object ?
        { :partial => 'track', :object => object, :locals => locals } :
        { :partial => 'track', :collection => object, :locals => locals }
  end

  def include_audio_player
    include_javascript %w[ http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js audio-player/jquery.jplayer.min audio-player/audio-player ]
    include_stylesheet 'admin/audio-player.css'
  end

end
