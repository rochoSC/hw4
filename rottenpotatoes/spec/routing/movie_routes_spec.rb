require 'spec_helper'

describe "routes for movies" do
  it "routes /movies/similar to the movies controller" do
    { :get => "/movies/similar/id" }.
      should route_to(:controller => "movies", :action => "similar", :id =>"id")
  end
end