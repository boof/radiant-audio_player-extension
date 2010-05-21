class Audio < ActiveRecord::Base

  has_attached_file :track,
    :url  => File.join('', %w[ audio :playlist_slug :track_slug.:extension ]),
    :path => File.join(%w[ :rails_root public audio :playlist_slug :track_slug.:extension ])

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  validates_presence_of :title
  validates_uniqueness_of :title

  # MIME types taken from: http://filext.com/
  validates_attachment_content_type :track,
      :content_type => /a(?:udio|pplication)\/(?:x-)?mp(?:e?g|3|eg3|egaudio)/

  # TODO replace this stub with association
  PLAYLIST = 'Playlist'
  def PLAYLIST.slug; 'playlist' end
  def playlist; PLAYLIST end

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

  delegate :url, :to => :track

  def title
    string = read_attribute :title

    if string.blank? and string = read_tag(:title)
      write_attribute :title, string
    end

    string
  end

  def read_tag(name)
    mp3info.tag[name.to_s] if track.file?
  end

  def slug
    title.downcase.split * '-'
  end

  protected

    def mp3info
      object = track.dirty?? track.queued_for_write[:original] : track
      @mp3info ||= Mp3Info.new object.path
    end

end
