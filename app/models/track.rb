class Track < ActiveRecord::Base
  set_table_name :audio_tracks
  default_scope :order => :position

  has_attached_file :audio,
    :url  => File.join(':playlist_url', ':track_slug.:extension'),
    :path => File.join(':playlist_path', ':track_slug.:extension')

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  # MIME types taken from: http://filext.com/
  validates_attachment_content_type :audio,
      :content_type => /a(?:udio|pplication)\/(?:x-)?mp(?:e?g|3|eg3|egaudio)/

  belongs_to :playlist, :touch => true
  validates_presence_of :playlist_id
  validates_numericality_of :position
  validates_uniqueness_of :title, :scope => :playlist_id

  def to_param
    "#{ id }-#{ to_slug }"
  end

  def path
    return if Page.count(:class_name => 'AudioPage') != 1
    "#{ Page.find_by_class_name('AudioPage').first.url }#{ to_param }"
  end

  def description_with_filter
    if filter = TextFilter.descendants.find { |f| f.filter_name == filter }
      filter.filter description
    else
      description
    end
  end

  delegate :url, :to => :audio

  def title=(new_title)
    file_was = audio.to_file
    write_attribute :title, new_title
    audio.path == file_was.path or self.audio = file_was
  end

  def read_tag(name)
    mp3info.tag[name.to_s] if audio.file?
  end
  delegate :bitrate, :samplerate, :to => :mp3info

  def channel_mode
    translate "channel_modes.#{ mp3info.channel_mode }"
  end

  def artist
    read_tag :artist
  end
  def album
    read_tag :album
  end
  def title
    string = read_attribute :title

    if string.blank?
      string = read_tag(:title) || generate_title
      write_attribute :title, string
    end

    string
  end

  def to_slug
    slug = title.downcase
    slug.gsub!(/[^a-z0-9\-]/, '-')
    slug.gsub!(/(?:^-|-$)/, '')
    slug.squeeze! '-'

    slug
  end

  def size
    audio_file_size
  end
  def length
    mp3info.length.to_i
  end
  def vbr?
    mp3info.vbr
  end

  def position
    integer = read_attribute :position

    unless integer
      if max = Track.maximum(:position, :conditions => "playlist_id = #{ playlist_id }")
        integer = write_attribute :position, max + 1
      else
        integer = write_attribute :position, 0
      end
    end

    integer
  end

  protected

    def translate(key, opts = {})
      I18n.translate "audio-player.playlist.track.#{ key }", opts
    end

    def generate_title
      'Track %i' % position || playlist.tracks.count + 1
    end

    def mp3info
      object = audio.dirty?? audio.queued_for_write[:original] : audio
      @mp3info ||= Mp3Info.new object.path
    end

end
