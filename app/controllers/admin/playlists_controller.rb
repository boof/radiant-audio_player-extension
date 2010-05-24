class Admin::PlaylistsController < Admin::ResourceController

  helper 'Admin::Node'

  def load_models
    self.models = Playlist.all :include => :tracks, :order => :title
  end

  def update_positions
    raise NotImplementedError
    @playlist.tracks.update_positions params[:positions]
    redirect_to admin_playlists
  end

end
