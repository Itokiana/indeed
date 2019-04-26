require "open-uri"
require "nokogiri"

doc = Nokogiri::HTML(open("http://www.google.com/search?q=pain"))
doc.xpath("//h3/a").each do |node|
  puts node.text
end
