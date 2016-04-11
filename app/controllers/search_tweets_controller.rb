#
# Controller of the Search Tweet page with the
# main operations.
#  
class SearchTweetsController < ApplicationController
  
  # Constant that stores the maximum number of tweets allowed per request.
  # According to the Twitter API, this number is 200.
  MAX_TWEETS_PER_REQUEST = 200

  # Maximum number of tweets to be returned to the view
  MAX_TWEETS_TO_RETURN = 10

  # Class variables to store the user being searched, 
  # the tweets retrieved and any eventual error message
  @userQuery = ""
  @retrievedTweets = nil
  @errorMessage = ""

  def persistImagesForUser() 
    begin
      if (@userQuery.empty?)
        raise ArgumentError
      end

      if (@retrievedTweets != nil) 
        @retrievedTweets.each do |tweet|
          if (tweet.media?)
            tweet.media.to_a.each do |itemMedia|
              begin
                attrb = {"user_name" => @userQuery, 
                         "image_url" => itemMedia.media_url, 
                         "tweet" => tweet.text,
                         "feat_vec" => ""}
     
                @tweetImageUser = TweetImageUser.new(attrb)
                @tweetImageUser.save
                @errorMessage = ""

                rescue ActiveRecord::RecordInvalid => invalid
                  @errorMessage = "An error occured while saving data into the database."
                  puts @errorMessage
                rescue ActiveRecord::RecordNotUnique => recordNotUnique
                  @errorMessage = "Attempt to store duplicate entries to the database."
                  puts @errorMessage
              end
            end
          end
        end
      end
      rescue ArgumentError
        @errorMessage = "Twitter account is empty. Can't save tweets into the database."
        puts @errorMessage
    end
  end

  # Redirect to the main page
  def redirectToWelcomePage()
    redirect_to :controller => 'welcome', :action => 'index'
  end

  # Handle the input parameter and go to doSearch method
  def search()
  	if (params[:searchField] != nil)
      @userQuery = params[:searchField].downcase
      if (!@userQuery.empty?)
        puts "#Log: search for userQuery: " + @userQuery.to_s 
  		  self.doSearch()
        self.persistImagesForUser()
      end
  	end
  end

  # Perform the search for tweets given an user accound
  def doSearch()
    
    # Perform a query to find the tweets from the specified user
    @retrievedTweets = self.get_all_tweets()

    # Improve this part with exceptions
    if (@retrievedTweets == nil || @retrievedTweets.empty?)
      puts "No tweets were found for this search."
    end

    return @retrievedTweets
  end

  # Get a specified number of tweets given by input variable
  # numTweets
  def get_tweets (numTweets)

    if (numTweets > MAX_TWEETS_PER_REQUEST)
      numTweets = MAX_TWEETS_PER_REQUEST
    end

    options = {"count" => numTweets, 
               "include_rts" => true,
               "result_type:" => "mixed"}

    return self.queryTweetApi(options)
  end

  # Get all tweets from a given user timeline
  def get_all_tweets()
    collect_with_max_id do |max_id|
      
      # Fix the time interval. There is no support for this apparently.
      options = {"count" => MAX_TWEETS_PER_REQUEST, 
                 "include_rts" => true, 
                 "result_type:" => "mixed"}
      options[:max_id] = max_id unless max_id.nil?
      
      return self.queryTweetApi(options)
    end
  end

  # Auxiliar method to recursively retrieve all tweets from an
  # user timeline
  def collect_with_max_id(collection=[], max_id=nil, &block)
    
    response = yield(max_id)
    if (response != nil)
      collection += response

      if (response.empty?)
        return collection.flatten
      else
        return collect_with_max_id(collection, response.last.id - 1, &block)
      end
    end
  end

  # Perform a query to the Twitter API, given the user and the query options
  def queryTweetApi (options)
    begin
        if (@userQuery.empty?)
          raise ArgumentError 
        end

      # Using Twitter Gem pre-defined function to do the search
      @errorMessage = ""
      return twitter_client.user_timeline(@userQuery, options).to_a

      rescue Twitter::Error::Unauthorized
        @errorMessage = "Not authorized to view tweets from the user " + @userQuery
        puts @errorMessage        
      rescue Twitter::Error::NotFound
        @errorMessage = "Twitter account not found."
        puts @errorMessage
      rescue Twitter::Error::TooManyRequests => error
        # NOTE: Your process could go to sleep for up to 15 minutes but if you
        # retry any sooner, it will almost certainly fail with the same exception.
        sleep error.rate_limit.reset_in + 1
        retry
      rescue ArgumentError
        @errorMessage = "Twitter account is empty."
      rescue Twitter::Error
        @errorMessage = "Unrecognized error has just happened. Please, try your search again."
        puts @errorMessage
    end
  end
end
