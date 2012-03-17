class CongressController < ApplicationController
  include NytCongress

  def index
    @bills = recent_bills
  end
end
