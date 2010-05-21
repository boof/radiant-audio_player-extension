ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.resources :audio, :except => :show, :member => { :remove => :get }, :collection => { :list => :get, :sort => :put }
    admin.audio_home 'audio', :controller => 'audio', :action => 'index'
  end

end
