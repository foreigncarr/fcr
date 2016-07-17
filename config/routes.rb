require './lib/domain_constraint.rb'

Rails.application.routes.draw do
  root 'common#index'

  constraints DomainConstraint::MySuperCar.new do
    match 'index' => 'mysupercar#index', via: [:get, :post]
    match 'log/submit' => 'mysupercar#submit_log', via: [:post]
    match 'admin' => 'admin#admin', via: [:get, :post]

    match 'admin/load_brand_data' => 'admin#load_brand_data', via: [:get, :post]
    match 'admin/load_model_data' => 'admin#load_model_data', via: [:get, :post]
    match 'admin/load_banner_data' => 'admin#load_banner_data', via: [:get, :post]
    match 'admin/load_event_data' => 'admin#load_event_data', via: [:get, :post]
    match 'admin/update_data_model' => 'admin#update_data_model', via: [:get, :post]
  end

  constraints DomainConstraint::MySuperVan.new do
    match 'index' => 'mysupervan#index', via: [:get, :post]
  end
end
