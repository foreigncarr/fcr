module ImageHelper
  def self.url(name, category=nil)
    return name if name.downcase.start_with? 'http'
    prefix = 'http://d39imkxg0jo8t9.cloudfront.net'
    prefix = "#{prefix}/#{category.to_s}" if category
    "#{prefix}/#{name}"
  end
end