require 'composite_primary_keys'
class TweetImageUser < ActiveRecord::Base
	self.primary_keys = :user_name, :image_url
end
