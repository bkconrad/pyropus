class ThingsController < ApplicationController
  skip_before_filter :authorize, only: [:index, :show]
  # GET /things
  # GET /things.json
  def index
    page_title "View all things"
    @things = Thing.all

    @things.each do |thing|
      # TODO: make this into a helper
      thing.description = thing.description[0..500]

      # stop at the end of the first paragraph
      thing.description = thing.description.split("\r\n\r\n")
      thing.description = thing.description[0]

      # remove the last word (fragment)
      thing.description = thing.description.split(" ")
      thing.description = thing.description[0..-1]
      thing.description = thing.description.join(" ")
      thing.description = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true).render(thing.description)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @things }
    end
  end

  # GET /things/1
  # GET /things/1.json
  def show
    @thing = Thing.find(params[:id])
    @thing.description = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true).render(@thing.description)
    page_title "About the " + @thing.name + " thing"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @thing }
    end
  end

  # GET /things/new
  # GET /things/new.json
  def new
    @thing = Thing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @thing }
    end
  end

  # GET /things/1/edit
  def edit
    @thing = Thing.find(params[:id])
  end

  # POST /things
  # POST /things.json
  def create
    @thing = Thing.new(params[:thing])

    respond_to do |format|
      if @thing.save
        format.html { redirect_to @thing, notice: 'Thing was successfully created.' }
        format.json { render json: @thing, status: :created, location: @thing }
      else
        format.html { render action: "new" }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /things/1
  # PUT /things/1.json
  def update
    @thing = Thing.find(params[:id])

    respond_to do |format|
      if @thing.update_attributes(params[:thing])
        format.html { redirect_to @thing, notice: 'Thing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /things/1
  # DELETE /things/1.json
  def destroy
    @thing = Thing.find(params[:id])
    @thing.destroy

    respond_to do |format|
      format.html { redirect_to things_url }
      format.json { head :no_content }
    end
  end
end
