ActiveSupport::Inflector.inflections do |inflect|
  inflect.uncountable "audio" # cause 'audios' just sounds wrong!
end

class AudioPlayerExtensionError < StandardError; end

class AudioPlayerExtension < Radiant::Extension
  version "0.1"
  description "Easily upload mp3 files, and embed them on your site with a Flash audio player."
  url "http://github.com/nelstrom/radiant-audio_player-extension/tree/master"

  def activate
    tab "Content" do
      add_item "Audio", "/admin/audio"
    end
    Page.send :include, AudioTags
    AudioPage
  end

end
