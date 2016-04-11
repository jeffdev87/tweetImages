class AddSecondaryKeyToTweetImageUsers < ActiveRecord::Migration
  def up
  	execute <<-SQL
  		ALTER TABLE tweet_image_users
  			ADD CONSTRAINT unique_constraint_tweet_images_users	
  			UNIQUE (user_name, image_url);
  	SQL
  end

  def down
  	execute<<-SQL
  		ALTER TALBE tweet_image_users
  			DROP CONSTRAINT unique_constraint_tweet_images_users
  	SQL
  end
end
