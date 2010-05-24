ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.with_options :path_prefix => '/admin/audio' do |audio|
      audio.resources :playlists, :member => { :remove => :get } do |playlists|
        playlists.resources :tracks, :only => %w[ new create ]
      end
      audio.resources :tracks, :member => { :remove => :get }, :except => %[ index new create ]
      audio.root :controller => 'playlists'
    end
  end

end
