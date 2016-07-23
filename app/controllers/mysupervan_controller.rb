require 'pry'

class MysupervanController < ApplicationController
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
    @mysupervan_data = MsvCarData.load
    @car_data = @mysupervan_data['model'].clone

    @pages = [
        { title: '이용가이드', link: 'pages/guide.html' },
        { title: '대여자격', link: 'pages/qualification.html' },
        { title: '대여 및 반납절차', link: 'pages/process.html' },
        { title: '보험 및 보상안내', link: 'pages/insurance.html' },
        { title: '개인정보취급방침', link: 'pages/privacy.html' }
    ]
    page = @pages.select{|t| t[:title] == params[:page]}.first

    @entrance = {
        page: page
    }.compact

    stat('초기화면_마이슈퍼밴') if @logging
  end

  def submit_log
    action_detail = params[:action_detail]
    action_category = params[:action_category].presence || action
    stat(action_detail, action_category)
    render :json => 'OK'
  end
end