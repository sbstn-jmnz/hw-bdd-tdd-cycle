require 'rails_helper'

describe MoviesController do
fixtures :movies
    before :each do
      @fake_movie = movies(:movie)
      @fake_movie2 = movies(:movie)
      @fake_movie3 = movies(:movie)
      @fake_results = [@fake_movie3, @fake_movie2]
      @empty_dir_movie = movies(:no_dir_movie)
    end

 describe 'updating director info' do
   before :each do
     allow(Movie).to receive(:find).with(@fake_movie.id.to_s).and_return(@fake_movie)
   end

   it 'should call update_attributes and redirect' do
     allow(@fake_movie).to receive(:update_attributes!).and_return(true)
     put :update, {:id => @fake_movie.id, :movie => @fake_movie.attributes}
     expect(response).to redirect_to(movie_path(@fake_movie))
   end
  end

describe 'update the total attributes! ' do
  let (:attr) do
   {:director => "new content" }
  end

  before :each do
    put :update, {:id => @fake_movie.id.to_s, :movie => attr}
    @fake_movie.reload
  end


   it 'should update the actual attributes!?'do
      expect(response).to redirect_to(@fake_movie)
      expect(@fake_movie.director).to eql attr[:director ]
    end
  end #update movie end

  describe 'happy path directors' do
    before :each do
      allow(Movie).to receive(:similar_directors).with(@fake_movie.director).and_return(@fake_results)
    end

    it 'should go to the route for simliar movies' do
      expect route_to(:controller => 'movies', :action => 'similar', :movie_id => @fake_movie.id.to_s)
      {:post => movie_similar_path(@fake_movie.id.to_s)}
    end

    it 'should call the model method that finds similar movies' do
      get :similar, {:movie_id => @fake_movie.id.to_s}
    end

    it 'should render the similar template with the similar movies' do
      get :similar, {:movie_id => @fake_movie.id.to_s}
      expect(response).to render_template('similar')
    end

    it 'should assign the instance variable @movies correctly' do
      get :similar, {:movie_id => @fake_movie.id.to_s}
      expect(assigns(:movies)) == @fake_results
    end

  end

  describe 'sad path directors' do
    before :each do
     allow(Movie).to receive(:find).with(@empty_dir_movie.id.to_s).and_return(@empty_dir_movie)
    end

    it 'should generate routing for simliar movies' do
      expect route_to(:controller => 'movies', :action => 'similar', :movie_id => @empty_dir_movie.id.to_s)
      {:post => movie_similar_path(@empty_dir_movie.id.to_s)}
    end

    it 'should return to home page w flash message' do
      get :similar, {:movie_id => @empty_dir_movie.id.to_s}
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to_not be_blank
    end

  end

  describe 'create and destroy' do
   it 'should request the model to create a new movie & redirect' do
     allow(Movie).to receive(:create).with(@fake_movie.attributes).and_return(@fake_movie)
     post :create, {:movie => @fake_movie.attributes}
     expect(response).to redirect_to(movies_path)
   end

   it 'should destroy a movie when valid' do
     allow(@fake_movie).to receive(:destroy)
     delete :destroy, {:id => @fake_movie.id.to_s}
     expect(response).to redirect_to(movies_path)
   end

   it 'should flash error on destroy a movie when INvalid' do
     delete :destroy, {:id => @fake_movie.id.to_s}
     expect(flash{:notice}).to_not be_blank
   end
 end

 describe 'edit' do
   it 'should find the movie correctly and render template' do
     get :edit, {:id => @fake_movie.id.to_s}
     expect(response).to render_template('edit')
   end
 end

 describe 'all that crazy sort and filter at index as so many lines!' do
   it 'should redirect if sort order has been changed' do
      session[:sort] = 'release_date'
      get :index, {:sort => 'title'}
      # rest = {ratings: "ratings%5BG%5D=G&ratings%5BNC-17%5D=NC-17&ratings%5BPG%5D=PG&ratings%5BPG-13%5D=PG-13&ratings%5BR%5D=R"}
      # response.should redirect_to(movies_path(:sort => 'title', :ratings => rest))


    end

    it 'should be possible to order by release date' do
      get :index, {:sort => 'release_date'}
    end

    it 'should redirect if selected ratings are changed' do
      get :index, {:ratings => {:G => 1}}
      expect(response).to redirect_to(movies_path(:ratings => {:G => 1}))
    end
    it 'should call database to get movies' do
      allow(Movie).to receive(:all_ratings).and_return(@fake_results)
      # expect(Movie).to receive(:all_ratings)
      get :index
    end
 end

 describe "#show" do
        it 'should show Movie by id' do
            allow(Movie).to receive(:find).with(@fake_movie2.id.to_s).and_return(@fake_movie2)
            get :show, {:id => @fake_movie2.id.to_s}
        end
    end

end #controller end