module Titles

  def page_title(arg = nil)
   if !arg
     return @title || ""
   else
     @title = arg 
   end
  end
  
end
