require 'spec_helper'

describe MoviesController do
  
  before(:all) do
    @movie = Movie.create(title: "Aladdin",rating: 'G',release_date: '25-Nov-1992',director: 'director')
  end
  
  describe "#index" do
    it "get normal index" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
    
    it "get sorted by param title" do
      get :index, sort: 'title'
      expect(response).to be_redirect
    end
    
    it "get sorted by session title" do
      session[:sort] = 'title'
      get :index
      expect(response).to be_redirect
    end
    
    it "get sorted by param release_date" do
      get :index, sort: 'release_date'
      expect(response).to be_redirect
    end
    
    it "get sorted by session release_date" do
      session[:sort] = 'release_date'
      get :index
      expect(response).to be_redirect
    end
    
    it "filter by ratings" do
      rat = {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "NC-17"=>"1"};
      get :index, ratings: rat
      expect(response).to be_redirect
    end
    
  end
  
  describe "#create" do
    before(:all) do
      @movie_params = {:title => 'The Terminator', :rating => 'R', :release_date => '26-Oct-1984', :director => "Director 2"}
    end
    
    it "create movie" do
      expect{ post :create, movie: @movie_params}.to change{Movie.all.size}.by(1)
    end
  end  
  
  describe "#new" do
    before(:all) do
      @movie_params = {:title => 'The Terminator', :rating => 'R', :release_date => '26-Oct-1984', :director => "Director 2"}
    end
    
    it "new movie" do
      get :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end
  
  it "#edit" do
    get :edit, id: @movie.id
    expect(response).to render_template(:edit)
  end
  
  it "#show" do
    get :show, id: @movie.id
    expect(response).to render_template(:show)
  end
  
   describe "#update" do
    before(:all) do
      @movie_backup = {:title => @movie.title, :rating => @movie.rating, :release_date => @movie.release_date, :director => @movie.director}
      @movie_params = {:title => @movie.title, :rating => @movie.rating, :release_date => @movie.release_date, :director => "Changed Director"}
    end
    
    it "update movie" do
      put :update, id: @movie.id, movie: @movie_params
      expect(Movie.find(@movie[:id])[:director]).to eq(@movie_params[:director])
    end
    
    it "restore movie" do
      put :update, id: @movie.id, movie: @movie_backup
      expect(Movie.find(@movie[:id])[:director]).to eq(@movie_backup[:director])
    end
  end
  
  describe "#destroy" do
    before(:each) do
      @movie1 = Movie.create!({:title => @movie.title, :rating => @movie.rating, :release_date => @movie.release_date, :director => "Changed Director"})
    end

    it "destroy movie" do
      expect{ delete :destroy, id: @movie1[:id]}.to change{Movie.all.count}.by(-1)
    end 

    it "redirect_to index after destroy" do
      delete :destroy, id: @movie1[:id]
      expect(response).to be_redirect
      expect(response).to redirect_to(movies_path)
    end
  end
  
  describe "#similar" do
    before(:each) do
      @movie1 = Movie.create!({:title => @movie.title, :rating => @movie.rating, :release_date => @movie.release_date})
      @movie2 = Movie.create!({:title => @movie.title, :rating => @movie.rating, :release_date => @movie.release_date, :director => "Changed Director"})
    
    end
    
    it "there are no similar movies" do
      get :similar, id: @movie1[:id]
      expect(response).to be_redirect
      expect(response).to redirect_to(movies_path)
    end
    
    it "there are similar movies" do
      get :similar, id: @movie2[:id]
      expect(response).to be_success
    end
  
  end
  
end