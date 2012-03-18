class CongressController < ApplicationController
  include NytCongress
  caches_page :query

  def index
  end

  def query
    if params[:args].length < 1
      # error
      return nil
    end
    render json: recent_bills("house", "introduced")
  end
end
