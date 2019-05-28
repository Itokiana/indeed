require "open-uri"
require "nokogiri"
require 'spreadsheet'

def all_links
  doc = Nokogiri::HTML(open("http://www.annuairedusport.fr/resultat.php?numero=13&NOM_COMMUNE=alldep&discipline=allsprt&Handi=0&adapt=0&rch_by_comcom=0&cartoCom&fbclid=IwAR3uW12TFzlo97w-Rjp1EcbNN36pw68ikLIIN5jnth3ZtSP6r0wr9sK3WVk"))
  links = []
  get_links = doc.css("#affich_tab_result tr td#td:nth-child(5) a")
  get_links.each{ |link| links.push(link['href']) }
  links
end

def get_details(link)
  doc = Nokogiri::HTML(open("http://www.annuairedusport.fr/" + link))
  details = []
  get_details = doc.css("#nav_asso_detail_body")
  federation = get_details.css("center")[1].css("a")[0] != nil ? get_details.css("center")[1].css("a")[0].content : get_details.css("center")[1].content
  headquarter = get_details.css("center")[2].content
  phone = get_details.css("center")[3].css("a")[0] == nil ? get_details.css("center")[3].content : "NON RENSEIGNER"
  email = get_details.css("center")[4] != nil && get_details.css("center")[4].css("a")[0] != nil ? get_details.css("center")[4].css("a")[0].content : "NON RENSEIGNER"
  more = "http://www.annuairedusport.fr/" + link
  details.push([
    federation,
    headquarter,
    phone,
    email,
    more,
  ])
  details
end

l = all_links()

d = []

l.each do |k|
  d.push(get_details(k))
end


book = Spreadsheet::Workbook.new
bold = Spreadsheet::Format.new :weight => :bold
sheet = book.create_worksheet :name => 'annuaire du sport'
sheet.row(0).set_format(0, bold)
sheet.row(0).set_format(1, bold)
sheet.row(0).set_format(2, bold)
sheet.row(0).set_format(3, bold)
sheet.row(0).set_format(4, bold)
sheet.row(0).push "Fédération","Siège social", "Téléphone", "E-mail", "Détails"

lastRow = sheet.last_row_index + 1
d.each_with_index do |row, rowNum|
      row.each_with_index do |cell, cellNum|
          sheet[ rowNum + lastRow, cellNum ] = cell
      end
end
book.write 'annuairedusport.xls'

# puts d
# puts get_details(l[3])