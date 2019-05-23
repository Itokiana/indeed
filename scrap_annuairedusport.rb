require "open-uri"
require "nokogiri"

def all_links
  doc = Nokogiri::HTML(open("http://www.annuairedusport.fr/resultat.php?numero=13&NOM_COMMUNE=alldep&discipline=allsprt&Handi=0&adapt=0&rch_by_comcom=0&cartoCom&fbclid=IwAR3uW12TFzlo97w-Rjp1EcbNN36pw68ikLIIN5jnth3ZtSP6r0wr9sK3WVk"))
  links = []
  get_links = doc.css("#affich_tab_result tr td#td:nth-child(5) a")
  get_links.each{ |link| links.push(link['href']) }
  links
end

def get_details(link)
  doc = Nokogiri::HTML(open("http://www.annuairedusport.fr/" + link))
  details = {}
  get_details = doc.css("#nav_asso_detail_body")
  details = {
    :federation => get_details.css("center")[1].css("a")[0].content,
    :headquarter => get_details.css("center")[2].content,
    :phone => get_details.css("center")[3].css("a")[0] == nil ? get_details.css("center")[3].content : "NON RENSEIGNER",
    :email => get_details.css("center")[4].css("a")[0] != nil ? get_details.css("center")[4].css("a")[0].content : "NON RENSEIGNER"
  }
end

l = all_links()
# d = []

# l.each do |x|
#   d.push(get_details(x))
# end
d = get_details(l[3])

puts d