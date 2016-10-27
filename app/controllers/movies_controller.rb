class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.order(:rating).distinct.pluck(:rating)
    
    if params[:ratings]
      ratings_arr = Array.new
      params[:ratings].each_key { |value| ratings_arr.push(value) }
      @movies = Movie.where(rating: ratings_arr)
    else
      @movies = Movie.all
    end
    
    if params[:sort_by]  
      @movies = Movie.order(params[:sort_by])
      if params[:sort_by] == 'title'
        @title = 'hilite'
      else
        @release_date = 'hilite'
      end
    end
    
    
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
