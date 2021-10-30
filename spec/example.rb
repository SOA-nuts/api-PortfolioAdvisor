require 'nokogiri'
require 'open-uri'
url = 'https://www.nytimes.com/2021/10/29/nyregion/cuomo-charged-brittany-commisso.html'
#用 Nokogiri 打開網址
page = Nokogiri::HTML(URI.open( url ))
#爬梳文章標題
title = page.xpath('//title').text
# puts title
#爬梳 og:image
ogimage_address = page.xpath('/html/head/meta[@property="og:image"]/@content').text

#爬梳文章摘要（每家網站的 meta tag 寫法結構不同，需針對網站調整）
short_description = page.xpath('/html/head/meta[@name="description"]/@content').text
# puts short_description

#爬梳文章主文
result = page.xpath("//article[@id='story']").text
puts result
#若只要純文字則可以這樣寫
result = page.xpath("//div[@class='post-main-content mb-3 mb-md-5']").text