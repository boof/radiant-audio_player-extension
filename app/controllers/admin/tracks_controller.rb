class Admin::TracksController < Admin::ResourceController

  protected

    def load_model
      self.model = if params[:id]
        Track.find params[:id]
      else
        Track.new { |track| track.playlist_id = params[:playlist_id] }
      end
    end

    def continue_url(options)
      options[:redirect_to] || (params[:continue] ? {:action => :edit, :id => model.id} : admin_playlists_path)
    end

end
