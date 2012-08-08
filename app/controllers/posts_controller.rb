class PostsController < ApplicationController
  skip_before_filter :authorize, only: [:index, :show]
  # GET /posts
  # GET /posts.json
  def index
    if (admin?)
      @posts = Post.order("created_at DESC");
    else
      @posts = Post.where('visible = 1').order("created_at DESC");
    end
    page_title "View all posts"

    @posts.each do |post|
      # get the first 1,000 chararcters or stop at <!-- break -->
      limit = post.content.index("<!-- break -->") || 1000
      post.content = post.content[0...limit]
      post.content = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :with_toc_data => true, :autolink => true, :space_after_headers => true).render(post.content)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    if (params[:id] != nil)
      @post = Post.find(params[:id])
    else
      @post = Post.where("url = '#{params[:url]}'").first
    end

    if (@post === nil)
      # TODO: this isn't the correct way to 404
      raise ActionController::RoutingError.new('Not Found')
    end

    page_title @post.title
    toc_renderer = Redcarpet::Render::HTML_TOC.new()
    renderer = Redcarpet::Render::HTML.new(:with_toc_data => true, :autolink => true, :space_after_headers => true)
    md_toc = Redcarpet::Markdown.new(toc_renderer)
    md = Redcarpet::Markdown.new(renderer)
    @toc = md_toc.render(@post.content)
    @content = md.render(@post.content)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        expire_fragment 'cms_menu_items'
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        expire_fragment 'cms_menu_items'
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    expire_fragment 'cms_menu_items'

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
