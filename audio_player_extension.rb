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
      set_audio_uncountable
      add_paperclip_interpolations
      include_page_tags

      tab('Content') { add_item 'Audio', '/admin/audio' }
    end

    def set_audio_uncountable
      'audio'.pluralize == 'audio' or
      ActiveSupport::Inflector.inflections { |inf| inf.uncountable 'audio' }
    end
    def add_paperclip_interpolations
      Paperclip::Interpolations.respond_to? :playlist_slug or
      Paperclip.interpolates(:playlist_slug) { |a, _| a.instance.playlist.slug }
      Paperclip::Interpolations.respond_to? :track_slug or
      Paperclip.interpolates(:track_slug) { |a, _| a.instance.slug }
    end
    def include_page_tags
      Page < AudioTags or
      Page.send :include, AudioTags
    end

  end
end

AudioPlayerExtension = AudioPlayer::Extension