require 'pry'

class FcrController < ApplicationController
  def index
    @fcr_data = CarData.load
    @car_data = @fcr_data['brand'].clone;
    (@fcr_data['model'] ||[]).each do |k, v|
      begin
        (@car_data[v['brandcode'].downcase]['models'] ||= []).push(
            {
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
  end

  def rental_guide

  end

  def rental_condition

  end

  def rental_process

  end

  def return_process

  end

  def insurance_guide

  end
end