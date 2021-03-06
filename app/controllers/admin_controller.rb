require 'rest-client'
require 'oj'
require 'redis'

class AdminController < ApplicationController
  layout 'mysupercar'
  skip_before_filter :verify_authenticity_token

  def admin
    @authorized = false
    if ( params[:password] == '레이먼' || params[:password] == 'fpdlajs' || cookies[:login] == 'authorized' )
      @authorized = true
      cookies[:login] = { :value => 'authorized', :expires => 30.minute.from_now }
    end
  end

  def load_brand_data
    render :json => CarData.fetch_brand_data
  end

  def load_model_data
    render :json => CarData.fetch_model_data
  end

  def load_banner_data
    render :json => CarData.fetch_banner_data
  end

  def load_event_data
    render :json => CarData.fetch_event_data
  end

  def update_data_model
    car_data = params[:car_data]
    CarData.save(car_data);
    render :json => {:code => 'ok'}
  end
end