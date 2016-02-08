class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :edit_meta]
  protect_from_forgery except: :index

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.order(:start)

    respond_to do |format|
      format.html
      format.js do
        @movies = Movie.finished.order(:start)
      end
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    if params[:offset].blank?
      @offset = 0
    else
      @offset = params[:offset]
    end
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  def edit_meta
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movies_url, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit_meta }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:description, :start, :end, :movie_ready)
    end
end
