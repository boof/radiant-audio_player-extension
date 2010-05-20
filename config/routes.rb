ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.resources :audio, :except => :show, :member => { :remove => :get }, :collection => { :list => :get, :sort => :put }
    admin.audio 'audio', :controller => 'audio', :action => 'index'
    admin.resources :audio_player_config
  end

end
