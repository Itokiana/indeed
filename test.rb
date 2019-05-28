require "open-uri"
require "nokogiri"
require 'spreadsheet'

# doc = Nokogiri::HTML(open("http://www.google.com/search?q=pain"))
# doc.xpath("//h3/a").each do |node|
#   puts node.text
# end

# d = [
#   {:name => "Koto", :age => 23},
#   {:name => "Koto", :age => 23},
#   {:name => "Koto", :age => 23}
# ]

# f = 'test.xls'

# book = Spreadsheet::Workbook.new
# bold = Spreadsheet::Format.new :weight => :bold
# sheet1 = book.create_worksheet :name => 'test'
# sheet1.row(0).set_format(0, bold)
# sheet1.row(0).set_format(1, bold)
# sheet1.row(0).push "just text","another text", "hehe"
# book.write 'test.xls'


arrays = [
['Text 1','Text 2','Text 3'],
['Text 4','Text 5','Text 6'],
['Text 7','Text 8','Text 9']]

book = Spreadsheet::Workbook.new
bold = Spreadsheet::Format.new :weight => :bold
sheet = book.create_worksheet :name => 'test'
sheet.row(0).set_format(0, bold)
sheet.row(0).set_format(1, bold)
sheet.row(0).set_format(2, bold)
sheet.row(0).push "just text","another text", "hehe"

lastRow = sheet.last_row_index + 1
arrays.each_with_index do |row, rowNum|
      row.each_with_index do |cell, cellNum|
          sheet[ rowNum + lastRow, cellNum ] = cell
      end
end
book.write 'test.xls'

# f = './test.xls'
# Spreadsheet.client_encoding = 'UTF-8'
# if File.exist? f
#     book = Spreadsheet.open(f)
#     bold = Spreadsheet::Format.new :weight => :bold
#     sheet = book.worksheet(0)
#     sheet.row(0).set_format(0, bold)
#     sheet.row(0).set_format(1, bold)
#     sheet.row(0).push "just text","another text", "hehe"

#     lastRow = sheet.last_row_index + 1
#     arrays.each_with_index do |row, rowNum|
#           row.each_with_index do |cell, cellNum|
#               sheet[ rowNum + lastRow, cellNum ] = cell
#           end
#     end
#     File.delete f
#     book.write f
# end

# f = './test.xls'
# Spreadsheet.client_encoding = 'UTF-8'
# if File.exist? f
#     book = Spreadsheet.open(f)
#     sheet = book.worksheet(0)

#     lastRow = sheet.last_row_index + 1
#     d.each_with_index do |row, rowNum|
#           row.each_with_index do |cell, cellNum|
#               sheet[ rowNum + lastRow, cellNum ] = cell
#           end
#     end
#     File.delete f
#     book.write f
# end