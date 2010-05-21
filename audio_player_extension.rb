module AudioPlayer
  class Extension < Radiant::Extension

    extension_config do |config|
      config.gem 'ruby-mp3info', :source => 'http://gemcutter.org', :lib => 'mp3info'
      config.gem 'paperclip', :source => 'http://gemcutter.org'
    end

    version '0.1.0'
    description 'Easily upload mp3 files, and embed them on your site with jPlayer.'
    url 'http://github.com/boof/radiant-audio_player-extension/tree/master'

    def activate
      set_audio_uncountable if 'audio'.pluralize != 'audio'
      Page.send :include, AudioTags
      tab('Content') { add_item 'Audio', '/admin/audio' }
    end

    def set_audio_uncountable
      ActiveSupport::Inflector.inflections { |inf| inf.uncountable 'audio' }
    end

  end
end

AudioPlayerExtension = AudioPlayer::Extension