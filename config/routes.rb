Rails.application.routes.draw do
  root to: 'application#index'
  get "/bonus_counter", to: "application#bonus_counter"
end
