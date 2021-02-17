#!/usr/local/bin/ruby 
#require 'rubygems'
puts "pdf to txt"

class PdfImport 
      require 'yomu'
    attr_accessor :pdf_file
    
    def initialize (pdf_file)
      @pdf_file = pdf_file
    end

    def to_string
      data = File.read @pdf_file
      text = Yomu.read :text, data
      #puts text
    end

def clean_string
  to_string.gsub(/\.|\r|\n|\"/,"")
end

def scan_regex
   clean_string.scan(/(?<date>\d{2}\/\d{2}\/\d{4})(?<invoice>\s+\d+)(?<code>\s.\W?\d+\W)(?<customer>\W+\({0,1}\W{0,1}\d{0,1}\W+\){0,1})(?<vat>\b\d+\b)(?<kgs>\s{0,2}\d{0,7},\d{2})(?<value>\s{0,2}\d{0,5},\d{2})/)
end

def to_array
  #invoices_array = clean_string.scan(scan_regex)
  invoices_array =  clean_string.scan(/(?<date>\d{2}\/\d{2}\/\d{4})(?<invoice>\s+\d+)(?<code>\s.\W?\d+\W)(?<customer>\W+\({0,1}\W{0,1}\d{0,1}\W+\){0,1})(?<vat>\b\d+\b)(?<kgs>\s{0,2}\d{0,7},\d{2})(?<value>\s{0,2}\d{0,5},\d{2})/)
  stripped_array=invoices_array.map{|element| element.map{|l| l.strip}}
#  stripped_array.each{|invoice| invoice.pop }
end

def ready_array
  #date string to date date strings to floats 
  to_array.map{|i| [Date.parse(i[0]),i[1],i[2].to_i,i[3],i[4],i[5].to_f,i[6].to_f] }
end



def return_discount_codes
  [1311,1321,1700]
end 

def returns
  ready_array.select{|i| return_discount_codes.include?(i[2])}
end


def sale_codes
  [1011,1014,1017,1041]
end

def sales
  ready_array.select{|i| sale_codes.include?(i[2])}
end



def raisins_array
  #select only raisin codes  1011,1311,1321, 1640 ,1621,1700
end



end

class Array 
  def invoices_by_code
    group_by{|i| i[2]}
  end

  def invoices_size_by_code
      invoices_by_code.transform_values{|v| v.count}.to_h 
   end
end 
class Customer
   attr_accessor :name,:invoices,:phone
   def initialize(name)
     @name =name
     @orders = []
   end

   def add_order(date,kgs,value)
     new_order = Order.new(date,kgs,value)
     @orders << new_order
     new_order 
   end
end


class Order 
  attr_accessor :date,:number,:customer,:kgs,:value
  def initialize(date,number,customer,kgs,value)
    @date = date
    @number = number 
    @customer = customer
    @kgs = kgs 
    @value = value 
  end
end

class Invoice
  require 'date'
  attr_accessor :date, :number,:code, :customer,:afm,:net_value,:kgs, :area

  def initialize(date,number,code, customer, afm, net_value,kgs,area)
    @date = Date.parse(date)
    @number = number
    @code = code
    @customer = customer.strip
    @afm = afm 
    @net_value = net_value.to_f
    @kgs = kgs.to_f 
    @area = area.strip
  end
 
  def to_s
    "#{@date} #{@customer} #{area}  #{@number}-#{@code} #{afm}   #{@net_value}€ #{@kgs}kg"
  end
  
  def steal_kg
    @kgs -=10
  end

  def steal_price
     @net_value -=100
  end
end

class InvoiceList
  require 'date'

  attr_accessor :name,:invoices
  
  def initialize(name)
     @name= name
     @invoices =[]
  end

  def process_original_file(file)
    #.pdf-> .txt-> [scan -> array of arrays ] 
  end

  def import_text(file)
     File.open(file) do |file|
       #open whole file in one go as a string ,delete  the 1.000,00 to 1000,00
       clean_text= file.read.gsub!(/\./,"")
       #scan the string using regex to present records and scan converts it to array of arrays 
     #invoices_array= clean_text.scan(/(?<date>\d{2}\/\d{2}\/\d{4})(?<invoice_no>\s+\d{11})(\s+\d{4})(?<customer>\D+)(?<afm>\d{9})\D+(?<net_value>\d{0,9}\,\d{2})\s+\d{0,9}\,\d{2}\s+\d{0,9}\,\d{2}\s+(?<kgs>\d{0,9}\,\d{2})/)
   #  regex = /(?<date>\d{2}\/\d{2}\/\d{4})(?<invoice_no>\s+\d{11})(\s+\d{4})(?<company>\D+)\d{0,9}(?<value>\s+\d{0,9}.\d{0,9})(?<kgs>\s+\d{0,9}.\d{0,9})(?<area>\D+)/
     invoices_array= clean_text.scan(/(?<date>\d{2}\/\d{2}\/\d{4})(?<invoice_no>\s+\d{11})(?<code>\s+\d{4})(?<company>\D+)(?<afm>\d{0,9})(?<value>\s+\d{0,9}.\d{0,9})(?<kgs>\s+\d{0,9}.\d{0,9})(?<area>\D+)/)
     #convert the array lines into Invoice objects and fill up the @invoices array 
     @invoices=[]
     invoices_array.each {|line| @invoices << Invoice.new(date=line[0],number=line[1],code=line[2],customer=line[3],afm=line[4],net_value=line[5],kgs=line[6],area=line[7])}
     end
  end

  def total_kgs
    @invoices.reduce(0){ |t,l| t + l.kgs }
  end
 def total_money
   @invoices.reduce(0){|t,l| t + l.net_value}
 end

 def avg_price
   total_money/total_kgs
 end
end
