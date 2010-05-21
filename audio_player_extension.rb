class AudioPlayerExtension < Radiant::Extension

  version '0.1.0'
  description 'Easily upload mp3 files, and embed them on your site with jPlayer.'
  url 'http://github.com/boof/radiant-audio_player-extension/tree/master'

  def activate
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.uncountable 'audio'
    end if 'audio'.pluralize != 'audio'

    Page.send :include, AudioTags

    tab('Content') { add_item 'Audio', '/admin/audio' }
  end

end
