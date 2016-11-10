require 'spec_helper'

describe "MoviesHelper" do
    include MoviesHelper

    it "Should return odd" do
        expect(oddness(1)).to eq('odd');
    end   
    
    it "Should return even" do
        expect(oddness(2)).to eq('even');
    end 
    
    
end
