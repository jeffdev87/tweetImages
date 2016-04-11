class WelcomeController < ApplicationController

  def redirectToSearchPage
  	redirect_to :controller => 'search_tweets', :action => 'search'
  end
end
