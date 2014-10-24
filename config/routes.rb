Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  namespace :admin do

    match 'whoallarecoming' => 'splash#index', via: [:get]
    match 'splash/import' => 'splash#import', via: [:get]
    match 'splash/export' => 'splash#export', via: [:get]
    get '', to: redirect('')
  end

  namespace :api do
    get ':action'
  end

  match 'rsvp' => 'home#rsvp', via: [:get]


end
