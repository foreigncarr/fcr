class AdminController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def admin
    @authorized = false
    if ( params[:password] == 'fpdlajs' || cookies[:login] == 'authorized' )
      @authorized = true
      cookies[:login] = { :value => 'authorized', :expires => 30.minute.from_now }
    end
  end

  def load_brand_data
    render :json => {code: 'ok'}
  end

  def load_model_data
    render :json => {code: 'ok'}
  end

  def load_banner_data
    render :json => {code: 'ok'}
  end

  def load_event_data
    render :json => {code: 'ok'}
  end

  def update_data_model
    render :json => {code: 'ok'}
  end

end