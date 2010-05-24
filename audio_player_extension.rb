module AudioPlayer
  PUBLIC_PATH = '/audio'
  ADMIN_PATHS = %w[ /admin/playlists /admin/tracks ]

  class Extension < Radiant::Extension

    extension_config do |config|
      config.gem 'ruby-mp3info', :source => 'http://gemcutter.org', :lib => 'mp3info'
      config.gem 'paperclip', :source => 'http://gemcutter.org'
    end

    version '0.1.0'
    description 'Easily upload mp3 files, manage playlists and embed an audio player on your pages.'
    url 'http://github.com/boof/radiant-audio_player-extension/tree/master'

    def activate
      add_paperclip_interpolations
      include_page_tags

      #tab('Content') { add_item 'Audio', /(?:#{ ADMIN_PATHS.map { |p| Regexp.escape p } * '|' })/ }
      tab('Content') { add_item 'Audio', ADMIN_PATHS.first }
    end

    def add_paperclip_interpolations
      Paperclip::Interpolations.respond_to? :playlist_url or
      Paperclip.interpolates(:playlist_url) { |a, _| a.instance.playlist.url }
      Paperclip::Interpolations.respond_to? :playlist_path or
      Paperclip.interpolates(:playlist_path) { |a, _| a.instance.playlist.path }
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