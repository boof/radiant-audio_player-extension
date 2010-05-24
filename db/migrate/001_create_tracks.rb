class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :audio_tracks do |tracks|
      tracks.string :title
      tracks.text :description
      tracks.string :filter

      tracks.references :playlist
      tracks.integer :position

      tracks.references :created_by
      tracks.references :updated_by

      tracks.string :audio_file_name
      tracks.string :audio_content_type
      tracks.integer :audio_file_size

      tracks.timestamps
    end
    add_index :audio_tracks, :playlist_id
  end

  def self.down
    drop_table :audio_tracks
  end
end
