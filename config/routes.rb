require './lib/domain_constraint.rb'

Rails.application.routes.draw do

  constraints DomainConstraint::MySuperCar.new do
    root to:'mysupercar#index', as: nil
    match '/' => 'mysupercar#index', via: [:get, :post]
    match 'log/submit' => 'mysupercar#submit_log', via: [:post]
    match 'admin' => 'admin#admin', via: [:get, :post]

    match 'admin/load_brand_data' => 'admin#load_brand_data', via: [:get, :post]
    match 'admin/load_model_data' => 'admin#load_model_data', via: [:get, :post]
    match 'admin/load_banner_data' => 'admin#load_banner_data', via: [:get, :post]
    match 'admin/load_event_data' => 'admin#load_event_data', via: [:get, :post]
    match 'admin/update_data_model' => 'admin#update_data_model', via: [:get, :post]
  end

  constraints DomainConstraint::MySuperVan.new do
    root to: 'mysupervan#index', as: nil
    match '/' => 'mysupervan#index', via: [:get, :post]
    match 'log/submit' => 'mysupervan#submit_log', via: [:post]
    match 'admin' => 'mysupervan_admin#admin', via: [:get, :post]

    match 'admin/load_brand_data' => 'mysupervan_admin#load_brand_data', via: [:get, :post]
    match 'admin/load_model_data' => 'mysupervan_admin#load_model_data', via: [:get, :post]
    match 'admin/load_banner_data' => 'mysupervan_admin#load_banner_data', via: [:get, :post]
    match 'admin/load_event_data' => 'mysupervan_admin#load_event_data', via: [:get, :post]
    match 'admin/update_data_model' => 'mysupervan_admin#update_data_model', via: [:get, :post]
  end
end
