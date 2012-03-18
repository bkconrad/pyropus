class CongressController < ApplicationController
  skip_before_filter :authorize
  caches_page :query
  include NytCongress

  def index
  end

  def query
    args = params[:args].split("/")
    if args.length < 1
      # error
      return nil
    end
    render json: recent_bills(args[1], "introduced")
  end
end
