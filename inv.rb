require 'Date'
require_relative 'invoice'


Invoice =Struct.new("Invoice",:date,:number,:code,:name,:afm,:kgs,:value) do 
    def avg_price
      value/kgs
    end
end



module InvoiceLedger

  INVOICES=[]

  puts @stripped_array

  def self.random
    INVOICES.sample
  end
end

if __FILE__ == $0
  puts InvoiceLedger::INVOICES
  invoice =InvoiceLedger.random
  puts "Your random invoice is #{invoice.name} - #{invoice.kgs} - #{invoice.date}"
end

