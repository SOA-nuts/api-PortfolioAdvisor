require 'rubygems'
require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(URI.open('https://www.nytimes.com/2021/10/29/nyregion/cuomo-charged-brittany-commisso.html'))

doc.at('div').each do |el|
   puts el.text
end