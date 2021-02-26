require_relative 'invoices'


#module Enumerable
  class Array  
  def sum
    self.inject(0){|accum,i| accum+i}
  end

  def mean 
    self.sum/self.length.to_f
  end

  def sample_variance
    m=self.mean
    sum=self.inject(0){|accum,i| accum+(i-m)**2 }
    sum/(self.length-1).to_f
  end

  def standard_deviation
    Math.sqrt(self.sample_variance)
  end
  
  def comulative_sum
    sum = 0
    self.map{|x| sum +=x }
  end

  def running_total
    self.inject([]){|result,element| result << result.last.to_i + element}
  end

 def group_elements_every(n)
   self.each_slice(n).to_a #easy 
 end
end


 def commas(x)
   str=x.to_s.reverse
   str.gsub!(/([0-9]{3})/,"\\1,")
   str.gsub(/,$/,"").reverse
 end

 #def yearly_sales
  # sales.group_by{|i| i[0].year}.transform_values{|value| value.map{|v| v[5].to_i}.sum}.sort.reverse.to_h
 #end
 def yearly_returns

 end
 def yearly_net
   #ysh.merge(ysr){|k,s,r| s-r}
 end
