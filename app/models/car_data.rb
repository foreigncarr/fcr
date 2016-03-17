class CarData

  def self.load
    data = redis.get('fcr_data') || self.save({
                                           brand:  fetch_brand_data,
                                           model:  fetch_model_data,
                                           banner: fetch_banner_data,
                                           event:  fetch_event_data
                                       })
    Oj.load data
  end

  def self.clear_cache
    redis.del('fcr_data')
  end

  def self.save data
    redis.set('fcr_data', data.to_json)
    redis.get('fcr_data')
  end

  def self.fetch_brand_data
    url = 'https://spreadsheets.google.com/feeds/list/1jUtKI4UhHgBv2NrX0TQFFGBuqw7LpY2Li2VCo6EE5tA/od6/public/values?alt=json'
    raw = Oj.load RestClient.get url
    bland = Hash[extract_entry_from(raw, %w(brandcode title logo)).map do |h|
      [h['brandcode'], {title: h['title'], models: [], logo: h['logo']}]
    end]
  end

  def self.fetch_model_data
    url = 'https://spreadsheets.google.com/feeds/list/1tb0Fy74CxayHuSBUCd9OO5_hpvvXKuTCe8nOgNDi87M/od6/public/values?alt=json'
    raw = Oj.load RestClient.get url
    model = Hash[extract_entry_from(raw, %w(brandcode modelcode modelname image mileage fuel price)).map do |h|
      [h['modelcode'], {brandcode: h['brandcode'], name: h['modelname'], image: h['image'], mileage: h['mileage'], fuel: h['fuel'], price: h['price']}]
    end]
  end

  def self.fetch_banner_data

  end

  def self.fetch_event_data

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