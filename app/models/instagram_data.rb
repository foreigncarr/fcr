class InstagramData
  def self.load
    data = redis.get('instagram_data')
    if (data.blank? or ((json_data = Oj.load data)['timestamp'] and json_data['timestamp'] < Time.now - 1.minute))
      data = self.save({
                           data: fetch_instagram_data,
                           timestamp: Time.now
                       })
    end
    Oj.load data
  rescue
    {}
  end

  def self.clear_cache
    redis.del('instagram_data')
  end

  def self.save data
    redis.set('instagram_data', data.to_json)
    redis.get('instagram_data')
  end

  def self.fetch_instagram_data
    access_token = '3618576176.38964fc.3f73acacef3941ab8c42ff58319fb609'
    url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=#{access_token}"
    raw = Oj.load RestClient.get url
    Hash[raw['data'].map.with_index do |h, i|
      ["instagram_#{i}", {
          image: h['images']['low_resolution']['url'],
          width: h['images']['low_resolution']['width'],
          height: h['images']['low_resolution']['height'],
          link: h['link']}]
    end]
  end

  private

  def self.redis
    @@redis ||= Redis.new(host: 'localhost', port: Rails.env == 'development' ? 6879 : 6379)
  end
end