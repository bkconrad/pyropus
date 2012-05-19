class PfxedController < ApplicationController
  skip_before_filter :authorize, only: [:index, :show]

  def index
    page_title "Particle Effects"
  end

  def show
    @sample = PfxedSample.find(params[:id])

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @sample }
    end
  end

  def update
    @sample = PfxedSample.find(params[:id])

    respond_to do |format|
      if @sample.update_attributes(params[:sample])
        format.json { render json: @sample }
      else
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end
end
