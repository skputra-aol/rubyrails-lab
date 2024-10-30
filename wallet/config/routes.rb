Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'users/current', to: 'members#index'
  get 'users/all', to: 'members#all'


  resources :orders

  get 'stocks/all', to: 'stocks#index'
  post 'stocks/create', to: 'stocks#create'
  get 'stocks/update', to: 'stocks#update'
  get 'stocks/delete', to: 'stocks#destroy'

  get 'price', to: 'stockprice#price'
  get 'prices', to: 'stockprice#prices'
  get 'priceall', to: 'stockprice#price_all'

  get 'transactions', to: 'transactions#index'


  get 'dashboard/stockwallet', to: 'dashboards#stockwallet'
  get 'dashboard/moneywallet', to: 'dashboards#moneywallet'
  get 'dashboard/myinfo', to: 'dashboards#myinfo'
  get 'dashboard/mytransaction', to: 'dashboards#mytransaction'
  get 'dashboard/mytransactionrecord', to: 'dashboards#mytransactionrecord'

end
