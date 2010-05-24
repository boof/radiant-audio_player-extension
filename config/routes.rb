ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.resources :playlists, :member => { :remove => :get } do |playlists|
      playlists.resources :tracks, :shallow => true, :except => :index, :member => { :remove => :get }
    end
  end

end
