class Api::V1::PostersController < ApplicationController

  def index
    posters = Poster.all
    render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_poster(poster)    
  end

  # private

  # def poster_params
  #     params.require(:poster).permit(:title, :description)
  # end
end
