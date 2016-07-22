class MsvCarData
  def self.load
    data = redis.get('msv_data') || self.save({
                                                  model:  fetch_model_data,
                                                  banner: fetch_banner_data,
                                                  event:  fetch_event_data
                                              })
    Oj.load data
  end

  def self.clear_cache
    redis.del('msv_data')
  end

  def self.save data
    redis.set('msv_data', data.to_json)
    redis.get('msv_data')
  end

  def self.fetch_model_data
    url = 'https://spreadsheets.google.com/feeds/list/15WxnRfK1S2bzPC2yGpMNwavkkIty6dM9ZSZob1Xd5OA/od6/public/values?alt=json'
    raw = Oj.load RestClient.get url
    Hash[extract_entry_from(raw, %w(brandcode modelcode modelname image notice mileage fuel price originalprice discountprice preorderlink)).map do |h|
      multiline_notice =  h['notice'].split("\n")

      notice1 = multiline_notice[0]
      notice2, notice2_style = '', 'none'
      if multiline_notice.size > 1
        notice2, notice2_style = multiline_notice[1], 'block'
      end

      price = h['price'].presence || h['discountprice'].presence || h['originalprice']

      [h['modelcode'], {modelcode: h['modelcode'], brandcode: h['brandcode'], name: h['modelname'], image: h['image'], mileage: h['mileage'], fuel: h['fuel'], notice: h['notice'], notice1: notice1, notice2: notice2, notice2_style: notice2_style, price: price, originalprice: h['originalprice'], discountprice: h['discountprice'], preorderlink: h['preorderlink']}]
    end]
  end

  def self.fetch_banner_data
    url = 'https://spreadsheets.google.com/feeds/list/1NFzIlja48ooGku6MxBsDdqKBnC_xynPQnN2K1a8kH30/od6/public/values?alt=json'
    raw = Oj.load RestClient.get url
    Hash[extract_entry_from(raw, %w(image link alt enable)).map.with_index do |h, i|
      ["banner_#{i}", {image: h['image'], link: h['link'], alt: h['alt'], enable: h['enable']}]
    end]
  end

  def self.fetch_event_data
    url = 'https://spreadsheets.google.com/feeds/list/1kLnuYfxs3Hu7-ab0ipXzDWYEjXaOY6rMZ8CNyFcXuFg/od6/public/values?alt=json'
    raw = Oj.load RestClient.get url
    Hash[extract_entry_from(raw, %w(image link alt enable)).map.with_index do |h, i|
      ["event_#{i}", {image: h['image'], link: h['link'], alt: h['alt'], enable: h['enable']}]
    end]
  end

  private

  def self.redis
    @@redis ||= Redis.new(host: 'localhost', port: Rails.env == 'development' ? 6879 : 6379)
  end


  def self.extract_entry_from(docs, keys)
    docs['feed']['entry'].map do |d|
      Hash[keys.map {|k| [k, d["gsx$#{k}"]['$t']] }] rescue nil
    end.compact
  end
end