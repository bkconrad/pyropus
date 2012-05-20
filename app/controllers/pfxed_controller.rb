class PfxedController < ApplicationController
  skip_before_filter :authorize, only: [:index, :show]

  def index
    page_title "Particle Effects"
  end

  def create
    @sample = PfxedSample.new(params[:sample])
    respond_to do |format|
      if @sample.save
        format.json { render json: @sample, status: :created }
      else
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  def list
    @list = PfxedSample.select([:name, :id])
    respond_to do |format|
      format.json { render json: @list }
    end
  end

  def destroy
    @sample = PfxedSample.find(params[:id])
    @sample.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
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
