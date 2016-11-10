require 'spec_helper'

describe Movie, type: :model do
    before(:each) do
      @movie1 = Movie.create!({:title => 't1', :rating => 'r1', :release_date => '25-Nov-1992', :director => "Changed Director"})
      @movie2 = Movie.create!({:title => 't2', :rating => 'r2', :release_date => '25-Nov-1994', :director => "Changed Director"})
    
    end
    it "Should return all_ratings" do
      expect(Movie.all_ratings).to eq(%w(G PG PG-13 NC-17 R))
    end
    
    it "Should return similar movies" do
      expect(Movie.similar(@movie1.director).count).to eq(2)
    end
end