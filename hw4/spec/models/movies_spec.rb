require 'rails_helper'

describe Movie do
 fixtures :movies
  before :each do
    @fake_movie = movies(:movie)
    @fake_movie2 = movies(:movie)
    @fake_movie3 = movies(:movie)
    @fake_results = [@fake_movie3, @fake_movie2]
    @empty_dir_movie = movies(:no_dir_movie)
    @diff_dir_movie = movies(:diff_dir_movie)
  end

  describe 'searching similar directors'  do

    before :each do
      results = Movie.similar_directors(@fake_movie.director)
      @results_array = []
      results.each do |result|
        @results_array << result.director
      end
    end

    it 'should find movies with same directors' do
      expect(@results_array.uniq.first).to eql(@fake_movie3.director)
      expect(@results_array.uniq.first).to eql(@fake_movie2.director)
      expect(@results_array.uniq.first).to eql(@fake_movie.director)
      expect(@results_array.uniq.count).to eql(1)
    end

    it 'should not return movies which have different directors' do
     expect(@results_array.uniq.first).to_not eql(@empty_dir_movie.director)
     expect(@results_array.uniq.first).to_not eql(@diff_dir_movie.director)
    end


  end

end