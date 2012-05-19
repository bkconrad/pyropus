class PfxedController < ApplicationController
  skip_before_filter :authorize, only: [:index]

  def index
    page_title "Particle Effects"
  end

  def show
    @sample = PfxedSample.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @sample }
    end
  end

end
