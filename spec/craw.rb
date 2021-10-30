# require 'nokogiri'
# require 'open-uri'

# url = 'https://www.bbc.co.uk/news/world-asia-china-58313387'
# #用 Nokogiri 打開網址
# page = Nokogiri::HTML(URI.open( url ))
# #爬梳文章標題
# title = page.xpath('//title').text
# #爬梳 og:image
# ogimage_address = page.xpath('/html/head/meta[@property="og:image"]/@content').text

# #爬梳文章摘要（每家網站的 meta tag 寫法結構不同，需針對網站調整）
# short_description = page.xpath('/html/head/meta[@name="description"]/@content').text

# #爬梳文章主文
# result = page.xpath("//div[@class='post-main-content mb-3 mb-md-5']").to_s

# #若只要純文字則可以這樣寫
# result = page.text
# puts result


require 'open-uri'
require 'nokogiri'

url = 'http://www.bbc.co.uk/sport/football/tables'
doc = Nokogiri::HTML.parse(URI.open url)
teams = doc.search('tbody tr.team')

keys = teams.first.search('td').map do |k|
  k['class'].gsub('-', '_').to_sym
end

hsh = teams.flat_map do |team|
  Hash[keys.zip(team.search('td').map(&:text))]
end

puts hsh