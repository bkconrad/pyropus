class PfxedController < ApplicationController
  skip_before_filter :authorize

  def index
    page_title "Particle Effects"
  end
end
