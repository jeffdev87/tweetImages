require "open-uri"

class SearchSimilarController < ApplicationController
	
	@resultSimilar = nil
	@dbResult = nil
	@errorMessage = ""
	@queryUrl = ""

	def searchSimilar()
		begin
			@queryUrl = params[:imageUrl]
		
			calculateSimilarImagesFromDbResult()

			@errorMessage = ""

			if (@queryUrl.empty?)
				raise ArgumentError
			end
			rescue ArgumentError
        		@errorMessage = "Select an image from the previous page to perform this search."
        		puts @errorMessage
		end
	end

	def calculateSimilarImagesFromDbResult()
		begin
			retrieveTweetsFromDatabase()
 			
 			@resultSimilar = @dbResult

			@errorMessage = ""

			if (@dbResult == nil || @dbResult.to_s.empty?)
				raise ArgumentError
			end

			rescue ArgumentError
        		@errorMessage = "No data stored into the database currently."
        		puts @errorMessage
		end		
	end

	def retrieveTweetsFromDatabase() 
		begin
			@dbResult = TweetImageUser.all.to_a
		  	puts "It was retrieved " + @dbResult.size.to_s + " from the database." 
		  	@errorMessage = ""
		  rescue
		  	@errorMessage = "An error occured while queying the database."
		end
	end

	def redirectToSearchPage()
		redirect_to :controller => 'search_tweets', :action => 'search', :params => params
	end
	
	def openImageFromUrl(url, fileName)
		
		# open(URI.parse(url.to_s).to_s) { |f|
  #  			File.open(fileName.to_s + ".jpg", "wb") do |file|
  #    			file.puts f.read
  #  			end
		# }
	end
end
