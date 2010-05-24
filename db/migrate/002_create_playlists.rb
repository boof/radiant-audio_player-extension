class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :audio_playlists do |playlists|
      playlists.string :title

      playlists.references :created_by
      playlists.references :updated_by

      playlists.timestamps
    end
  end
  
  def self.down
    drop_table :audio_playlists
  end
end
