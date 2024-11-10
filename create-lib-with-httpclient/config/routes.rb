Rails.application.routes.draw do
  get 'top/:id', to: 'stories#top'
  get 'tops', to: 'stories#tops'
  get 'topall', to: 'stories#topall'

end
