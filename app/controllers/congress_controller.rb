class CongressController < ApplicationController
  skip_before_filter :authorize
  caches_page :query
  include NytCongress

  def index
    page_title "Congress Info"
  end

  def query
    args = params[:args].split("/")
    if args.length < 1
      # error
      return nil
    end
    method_symbol = args.shift.tr("-","_").to_sym
    NytCongress.method_defined?(method_symbol)
    result = self.method(method_symbol).call(*args)
    if result
      render json: result
    else
      head :not_found
    end
 
  end
end
