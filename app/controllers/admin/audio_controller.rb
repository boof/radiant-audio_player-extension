class Admin::AudioController < Admin::ResourceController

  helper 'Admin::Node'

  def load_models
    self.models = Audio.all :order => :position
  end

  def list
    @audio = Audio.find :all, :order => :position
  end

  def sort
    if sort_order = params[:sort_order]
      ids = sort_order.split(',').map { |id| id.to_i }

      Audio.transaction do
        list = Audio.find(ids).inject({}) { |m, a| m[a.id] = a }
        list.size.times do |i|
          audio = list.fetch ids[i]
          audio.update_attributes! position => i + 1
        end
      end

    end

    redirect_to admin_audio_index_path
  end

end
