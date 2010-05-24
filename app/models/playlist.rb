class Playlist < ActiveRecord::Base
  set_table_name :audio_playlists

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  has_many :tracks, :dependent => :destroy, :order => :position do

    def update_positions(positions)
      transaction do
        positions.to_s.split(',').map { |id| id.to_i }.
        each_with_index do |id, index|
          Track.update_all "position = #{ index + 1 }", :id => id
        end
        proxy_owner.touch
      end
    end

  end

  validates_presence_of :title
  def to_s; read_attribute :title end

  def self.slug(title)
    slug = title.downcase
    slug.gsub!(/[^a-z0-9\-]/, '-')
    slug.gsub!(/(?:^-|-$)/, '')
    slug.squeeze! '-'

    slug
  end
  def slug
    Playlist.slug title
  end
  def self.url(title)
    "#{ AudioPlayer::PUBLIC_PATH }/#{ slug title }"
  end
  def url
    Playlist.url title
  end
  def self.path(title)
    File.join Rails.public_path, url(title).split('/')
  end
  def path
    Playlist.path title
  end

  protected

    def queue_path_update
      @old_path = Playlist.path(title_was) if title_changed?
    end
    before_update :queue_path_update
    def update_path
      return unless @old_path

      FileUtils.mv @old_path, path
      @old_path = nil
    end
    after_update :update_path

end
