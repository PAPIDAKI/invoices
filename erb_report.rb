require 'date'
require 'erb'
require_relative 'invoices_rb/invoices.rb'

x = 42
today =  Date.today
june30 = Date.new(2021,6,30)
aug30 = Date.new(2021,8,30)

pdf =PdfImport.new('allsales.pdf')
sales=pdf.sales
#returns = pdf.returns
sales_yearly_kgs = sales.group_by{ |s| s[0].year}.transform_values{|v| v.transpose[5].sum}.sort.reverse
template = ERB.new <<-EOF

<%=today.strftime("%d/%m/%y")%>            to June end: <%=(june30-today).to_i %> days  to Sept begin: <%=(aug30 - today).to_i %> days
Sales invoices: <%=sales.count%>  From: <%= sales.sort.first[0]%> 
Return invoives: 
       
SALES  yearly-kgs ttm-kgs  avg sale price /kg avg buy price/kg buys sales diff%  value
yearly by month 
<% sales_yearly_kgs.each do |sale_by_year| %>
<%= sale_by_year%>
<% end %> 
monthly 
forcast till end june end of season 
sales expected sales in june august etc 
net sales invoiced-returns  + 6tos 

RETURNS  num of invoices    return kgs phones  palets  return value 


The value of x is <%= x%>
    
    EOF

puts template.result(binding)

