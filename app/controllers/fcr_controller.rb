require 'pry'

class FcrController < ApplicationController
  include StatLogger
  before_filter :preprocess_cookie
  skip_before_filter :verify_authenticity_token

  def preprocess_cookie
    @fcr_user ||= cookies[:_fcr_user]
    unless @fcr_user
      @fcr_user = SecureRandom.uuid
      cookies[:_fcr_user] = { :value => SecureRandom.uuid, :expires => 365.days.from_now }
    end
    @logging = if (last_visited = cookies[:_fcr_last_visited])
                 Time.now - Time.parse(last_visited) > 300
               else
                 true
               end
    cookies[:_fcr_last_visited] = { :value => Time.now.to_s, :expires => 365.days.from_now }
  end

  def index
    @fcr_data = CarData.load
    @car_data = @fcr_data['brand'].clone;
    (@fcr_data['model'] ||[]).each do |k, v|
      begin
        (@car_data[v['brandcode'].downcase]['models'] ||= []).push(
            {
                brand:   v['brandcode'],
                code:    k,
                name:    v['name'],
                image:   v['image'],
                mileage: v['mileage'],
                fuel:    v['fuel'],
                price:   v['price']
            })
      rescue
      end
    end

    stat('초기화면') if @logging
  end

  def rental_guide
    stat('이용가이드')
  end

  def rental_condition
    stat('대여조건')
  end

  def rental_process
    stat('대여절차')
  end

  def return_process
    stat('반납절차')
  end

  def insurance_guide
    stat('보험안내')
  end

  def submit_log
    action_detail = params[:action_detail]
    action_category = params[:action_category].presence || action
    stat(action_detail, action_category)
    render :json => 'OK'
  end
end