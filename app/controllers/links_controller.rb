class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :redirection]

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # show my links page
  def my_links
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        if @link.shortened.nil? or @link.shortened.empty?
          @link.assign_unique_shortened_string
          @link.save
        end
        current_user.links << @link
        current_user.save

        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Checks to see if the link data already exists in the database
  # GET /api/links/exists
  # Testing via curl: curl -H "Content-Type: application/json" -X GET -d '{ "destination": "https://www.google.com" }' http://localhost:3000/api/links/exists
  def link_exists
    status = -1
    errors = []
    destination = params["destination"]
    json_response = {}

    if destination.nil?
      errors << "Error: you must provide a destination"
    else
      links = Link.where(destination: destination)
      if links.empty? or links.nil?
        status = 1
      else
        errors << "Error: that link already exists in the database"
      end
    end

    if status == -1
      json_response["errors"] = errors
    end

    json_response["status"] = status
    json_response = json_response.to_json

    respond_to do |format|
      format.json { render json: json_response }
    end
  end

  # Adds the link to the user's favorites
  # PUT /api/links/:id/favorite
  # Testing via curl: curl -H "Content-Type: application/json" -X PUT -d '{ "user_id": 1, "link_id": 21 }' http://localhost:3000/api/links/21/favorite
  def favorite
    status = -1
    errors = []
    user_id = params["user_id"]
    link_id = params[:id]
    json_response = {}

    if user_id.nil?
      errors << "Error: you must provide a user_id"
    elsif link_id.nil?
      errors << "Error: you must provide a link_id"
    else
      link = Link.find_by(id: link_id)
      user = User.find_by(id: user_id)

      if link.nil?
        errors << "Error: no link with id #{link_id} exists"
      elsif user.nil?
        errors << "Error: no user with id #{user_id} exists"
      else
        link.favorite(user_id)
        status = 1
      end
    end

    if status == -1
      json_response["errors"] = errors
    end

    json_response["status"] = status
    json_response = json_response.to_json

    respond_to do |format|
      format.json { render json: json_response }
    end
  end

  # Removes the link from the user's favorites
  # PUT /api/links/:id/favorite
  # Testing via curl: curl -H "Content-Type: application/json" -X PUT -d '{ "user_id": 1 }' http://localhost:3000/api/links/21/unfavorite
  def unfavorite
    status = -1
    errors = []
    user_id = params["user_id"]
    link_id = params[:id]
    json_response = {}

    puts "UNFAVORITING IN FUNCTION"

    if user_id.nil?
      errors << "Error: you must provide a user_id"
    elsif link_id.nil?
      errors << "Error: you must provide a link_id"
    else
      link = Link.find_by(id: link_id)
      user = User.find_by(id: user_id)

      if link.nil?
        errors << "Error: no link with id #{link_id} exists"
      elsif user.nil?
        errors << "Error: no user with id #{user_id} exists"
      else
        puts "UNFAVORITING"
        link.unfavorite(user_id)
        status = 1
      end
    end

    if status == -1
      json_response["errors"] = errors
    end

    json_response["status"] = status
    json_response = json_response.to_json

    respond_to do |format|
      format.json { render json: json_response }
    end
  end

  # Redirect a short url to its actual destination
  def redirection
    short = params["short"]

    if short.nil?
      redirect_to root_url
    else
      link = Link.find_by(shortened: short)

      if link.nil?
        redirect_to root_url
      else
        redirect_to link.destination
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:destination, :shortened, :favorited, :description, :title)
    end
end
