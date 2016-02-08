class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:update, :destroy]
  before_action :set_movie, only: [:index, :create, :update, :destroy]

  def index
    respond_to do |format|
      format.json { render json: @movie.chapters.to_json(methods: :public_url) }
    end
  end

  def create
    @chapter = Chapter.new(chapter_params)

    respond_to do |format|
      if @chapter.save
        format.json { render json: @chapter, status: :created }
      else
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.json { render json: @chapter, status: :ok }
      else
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chapter.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def set_movie
      @movie = Movie.find(params[:movie_id])
    end

    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    def chapter_params
      params.require(:chapter).permit(:movie_id, :offset, :description, :date)
    end
end
