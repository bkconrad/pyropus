module Titles

  def page_title(arg = nil)
   if !arg
     return @title || params[:action].capitalize + " " + params[:controller].chomp("s")
   else
     @title = arg 
   end
  end
  
end
