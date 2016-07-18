require 'pry'

class MysupervanController < ApplicationController

  def index
    @mysupervan_data = {
        'banner' => {
            'banner_0'=>{'image'=>'bn_open_coffee.png', 'link'=>'http://blog.naver.com/mysupercar', 'alt'=>'선예약 상담 이벤트', 'enable'=>'YES'}
        },
        'event' => {
            'event_0'=>{'image'=>'img_recommend_1.png', 'link'=>'http://blog.naver.com/mysupercar', 'alt'=>'가족여행(개인)', 'enable'=>'YES'},
            'event_1'=>{'image'=>'img_recommend_1.png', 'link'=>'http://blog.naver.com/mysupercar', 'alt'=>'가족여행(개인)', 'enable'=>'YES'},
            'event_2'=>{'image'=>'img_recommend_1.png', 'link'=>'http://blog.naver.com/mysupercar', 'alt'=>'가족여행(개인)', 'enable'=>'YES'}
        },
        'car' => [
            {'name' => '카니발 하이리무진', 'image' => 'cars_1.jpg', 'mileage' => '7.6~11.1 km/L', 'price' => '00000원', 'detaillink' => 'http://blog.naver.com/mysupercar', 'preorderlink' => 'http://goo.gl/forms/sxytFdF0hC'},
            {'name' => '카니발2', 'image' => 'cars_2.jpg', 'mileage' => '7.6~11.1 km/L', 'price' => '00000원', 'detaillink' => 'http://blog.naver.com/mysupercar', 'preorderlink' => 'http://goo.gl/forms/sxytFdF0hC'},
            {'name' => '카니발3', 'image' => 'cars_3.jpg', 'mileage' => '7.6~11.1 km/L', 'price' => '00000원', 'detaillink' => 'http://blog.naver.com/mysupercar', 'preorderlink' => 'http://goo.gl/forms/sxytFdF0hC'},
            {'name' => '카니발4', 'image' => 'cars_4.jpg', 'mileage' => '7.6~11.1 km/L', 'price' => '00000원', 'detaillink' => 'http://blog.naver.com/mysupercar', 'preorderlink' => 'http://goo.gl/forms/sxytFdF0hC'},
            {'name' => '카니발5', 'image' => 'cars_5.jpg', 'mileage' => '7.6~11.1 km/L', 'price' => '00000원', 'detaillink' => 'http://blog.naver.com/mysupercar', 'preorderlink' => 'http://goo.gl/forms/sxytFdF0hC'}
        ]
    }
    @car_data = @mysupervan_data['car'].clone

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

  end
end