class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.sort(params[:sort])
    options = {meta: {count: posters.length}}
    render json: PosterSerializer.new(posters, options)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.new(poster)
  end

  def create
    poster = Poster.create(poster_params)
    render json: PosterSerializer.new(poster)
  end

  def update
    poster = Poster.find(params[:id])
    poster.update(poster_params)
    render json: PosterSerializer.new(poster)
  end

  def destroy
    poster = Poster.find(params[:id])
    poster.destroy
    render json: PosterSerializer.new(poster)
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end
