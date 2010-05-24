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
  validates_uniqueness_of :title, :scope => :playlist_id

  def to_param
    "#{ id }-#{ slug }"
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

    audio.path == file_was.path or
    audio.queued_for_write[:original] = file_was
  end

  def title
    string = read_attribute :title

    if string.blank?
      if string = read_tag(:title)
        artist = read_tag :artist
        string = "#{ artist } - #{ string }" if artist
      else
        string = 'Track %i' % position || playlist.tracks.count + 1
      end

      write_attribute :title, string
    end

    string
  end

  def read_tag(name)
    mp3info.tag[name.to_s] if audio.file?
  end

  def slug
    slug = title.downcase
    slug.gsub!(/[^a-z0-9\-]/, '-')
    slug.gsub!(/(?:^-|-$)/, '')
    slug.squeeze! '-'

    slug
  end

  protected

    def mp3info
      object = audio.dirty?? audio.queued_for_write[:original] : audio
      @mp3info ||= Mp3Info.new object.path
    end

end
