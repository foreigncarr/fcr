Rails.application.routes.draw do
  root 'fcr#index'
  get 'index' => 'fcr#index'
end
