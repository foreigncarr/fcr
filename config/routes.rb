Rails.application.routes.draw do
  root 'fcr#index'
  match 'index' => 'fcr#index', via: [:get, :post]
  match 'guide' => 'fcr#rental_guide', via: [:get, :post]
  match 'guide/condition' => 'fcr#rental_condition', via: [:get, :post]
  match 'guide/process' => 'fcr#rental_process', via: [:get, :post]
  match 'guide/return' => 'fcr#return_process', via: [:get, :post]
  match 'guide/insurance' => 'fcr#insurance_guide', via: [:get, :post]

  match 'admin' => 'admin#admin', via: [:get, :post]

  match 'admin/load_brand_data' => 'admin#load_brand_data', via: [:get, :post]
  match 'admin/load_model_data' => 'admin#load_model_data', via: [:get, :post]
  match 'admin/load_banner_data' => 'admin#load_banner_data', via: [:get, :post]
  match 'admin/load_event_data' => 'admin#load_event_data', via: [:get, :post]
  match 'admin/update_data_model' => 'admin#update_data_model', via: [:get, :post]


end
