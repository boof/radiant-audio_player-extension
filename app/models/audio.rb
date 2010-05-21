class Audio < ActiveRecord::Base

  has_attached_file :track,
    :url => "/:class/:id/:basename.:extension",
    :path => ":rails_root/public/:class/:id/:basename.:extension"
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  validates_presence_of :title
  validates_uniqueness_of :title, :message => 'name already in use'
  # mp3 MIME types taken from: http://filext.com/file-extension/MP3
  validates_format_of :track_content_type, 
                      :with => /(audio|application)\/(x-)?(mpe?g|mp3|mpeg3|mpegaudio)/,
                      :message => "must be an mp3"

  def to_param
    [id, slug_from_title(title)].join("-")
  end
  
  def path
    movie_pages = Page.find_all_by_class_name("AudioPage")
    return nil unless movie_pages.size == 1
    movie_page = movie_pages.first
    path = [movie_page.url, to_param].join()
  end
  
  def description_with_filter
    if filter
      f = TextFilter.descendants.find { |tf| tf.filter_name == filter }
      f.filter(description)
    else
      description
    end
  end
  
  def url
    track.url
  end
  
  private
  
  def slug_from_title(title)
    title.downcase.split.join("-")
  end
  
end
