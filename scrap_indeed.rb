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

def get_result_links_from_indeed(city)
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

def get_result_content_from_indeed(city)
  pages = ["10","20","30","40","50"]
  results = []
  titles = []
  enterprises = []
  regions = []
  descriptions = []
  doc = Nokogiri::HTML(open("https://www.indeed.fr/emplois?q=commercial+et%2Fou+rh&l=" + city))
  i = 0

  get_titles = doc.css("td#resultsCol div div.title a")
  get_enterprises = doc.css("td#resultsCol div.sjcl span.company")
  get_regions = doc.css("td#resultsCol div.sjcl span.location")
  get_descriptions = doc.css("td#resultsCol div.summary")

  get_titles.each do |title|
    titles.push(title.content[13..-1])
  end

  get_enterprises.each do |e|
    enterprises.push(e.content.delete("\n").delete(" "))
  end

  get_regions.each do |r|
    regions.push(r.content)
  end

  get_descriptions.each do |d|
    descriptions.push(d.content[13..-1])
  end  

  titles.each do |t|
    results.push({
      :title => t, 
      :enterprise => enterprises[i], 
      :region => regions[i], 
      :description => descriptions[i] 
    })
    i = i + 1
  end

  pages.each do |p|
    titles = []
    enterprises = []
    regions = []
    descriptions = []
    doc = Nokogiri::HTML(open("https://www.indeed.fr/emplois?q=commercial+et%2Fou+rh&l=" + city + "&start="+ p))
    i = 0
    get_titles = doc.css("td#resultsCol div div.title a")
    get_enterprises = doc.css("td#resultsCol div.sjcl span.company")
    get_regions = doc.css("td#resultsCol div.sjcl span.location")
    get_descriptions = doc.css("td#resultsCol div.summary")

    get_titles.each do |title|
      titles.push(title.content[13..-1])
    end

    get_enterprises.each do |e|
      enterprises.push(e.content.delete("\n").delete(" "))
    end

    get_regions.each do |r|
      regions.push(r.content)
    end

    get_descriptions.each do |d|
      descriptions.push(d.content[13..-1])
    end  

    titles.each do |t|
      results.push({
        :title => t, 
        :enterprise => enterprises[i], 
        :region => regions[i], 
        :description => descriptions[i] 
      })
      i = i + 1
    end
  end

  results
end



# json = JSON.pretty_generate(get_french_cities())
# File.open("data.json", 'w') { |file| file.write(json) }
# a = get_result_cols_from_indeed('Nice')
b = get_result_content_from_indeed('Nice')

puts b