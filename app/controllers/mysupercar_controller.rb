require 'pry'

class MysupercarController < ApplicationController
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

    @pages = [
        { title: '이용가이드', link: 'pages/guide.html' },
        { title: '대여자격', link: 'pages/qualification.html' },
        { title: '대여 및 반납절차', link: 'pages/process.html' },
        { title: '보험 및 보상안내', link: 'pages/insurance.html' },
        { title: '개인정보취급방침', link: 'pages/privacy.html' }
    ]
    page = @pages.select{|t| t[:title] == params[:page]}.first

    @entrance = {
        brand: params[:brand].presence,
        page: page
    }.compact

    @mysupercar_data = CarData.load
    @car_data = @mysupercar_data['brand'].clone
    (@mysupercar_data['model'] ||[]).each do |k, v|
      begin

        original_price = (v['originalprice'] || '').strip
        discount_price = (v['discountprice'] || '').strip
        discount_price = original_price unless discount_price.present?
        discount = original_price != discount_price

        (@car_data[v['brandcode'].downcase]['models'] ||= []).push(
            {
                brand:         v['brandcode'],
                code:          k,
                name:          v['name'],
                image:         v['image'],
                mileage:       v['mileage'],
                fuel:          v['fuel'],
                originalprice: original_price,
                discountprice: discount_price,
                notice:        v['notice'],
                notice_display: (v['notice'].blank?)? 'none' : 'block',
                discountdisplay: discount ? '':'display:none',
                preorderlink:  v['preorderlink']
            })
      rescue
      end
    end

    stat('초기화면_마이슈퍼카') if @logging
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