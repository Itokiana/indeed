require "open-uri"
require "nokogiri"
require 'json'

def get_french_cities
  doc = Nokogiri::HTML(open("http://www.meteoservices.be/fr/be/home/meteo/meteo-dans-le-monde/liste-de-villes/country/33/france/ch/345b7531bd52e00dd41b67c3445423b6.html"))
  cities = []
  get_cities = doc.css("tr.row_0 td.left a")
  get_cities.each{ |link| cities.push(link.content) }
  cities
end

def get_result_cols_from_indeed(city)
  pages = ["10","20","30","40","50"]
  doc = Nokogiri::HTML(open("https://www.indeed.fr/emplois?q=commercial+et%2Fou+rh&l=" + city))
  links = []
  get_links = doc.css("td#resultsCol div div.title a")
  get_links.each do |link| 
    if link['href'][-29] == "&"
      links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-1])
    else
      links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-30] + "&" + link['href'][-28..-1])
    end
  end

  pages.each do |p|
    doc = Nokogiri::HTML(open("https://www.indeed.fr/emplois?q=commercial+et%2Fou+rh&l=" + city + "&start="+ p))
    get_links = doc.css("td#resultsCol div div.title a")
    get_links.each do |link| 
      if link['href'][-29] == "&"
        links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-1])
      else
        links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-30] + "&" + link['href'][-28..-1])
      end
    end
  end

  links
end



# json = JSON.pretty_generate(get_french_cities())
# File.open("data.json", 'w') { |file| file.write(json) }
a = get_result_cols_from_indeed('Nice')

puts a