class CreateTweetImageUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :tweet_image_users do |t|
      t.string :user_name
      t.string :image_url
      t.string :tweet
      t.string :feat_vec

      t.timestamps null: false
    end
  end

  def down
    drop_table :tweet_image_users
  end
end
