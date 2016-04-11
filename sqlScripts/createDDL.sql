/*
 * SQL Script to create the tables of the 
 * TappsTweet application.
 * 
 * Tables to be created:
 *
 *   - userTwitter: 
 *        Stores data from Twitter users.
 *   - images: 
 *        Stores data about the images from the user's posts.
 *   - featuresVec: 
 *        Stores the features vectors of images of the database.
 */

/*
   Using rails generate model

   rails generate model TwitterUser name:string, profile_img_url:string, description:string
   rails generate model Image twitter_user_id:integer, image_url:string, description:string
   rails generate model FeaturesVector image_twitter_user_id:integer, image_id:integer, histogram:string

   # Using this one to facilitate
   rails generate model TweetImageUser user_name:string, image_url:string, tweet:string, feat_vec:string

   Heroku command to deploy the database changes
      1) heroku run rake db:migrate --app agile-sea-7896
      2) git push heroku master 

      heroku pg:psql -> Connect to psql remotely to confirm if the tables are there

   Learn how to do this
   rails generate migration AddForeignKeyToImages
   rails generate migration AddForeignKeyToFeaturesVectors
	
   add_foreign_key :images, :twitter_users
   add foreign_key :features_vectors, :images 

 */

CREATE DATABASE tappstweet_development WITH OWNER william;
CREATE DATABASE tappstweet_test WITH OWNER william;
CREATE DATABASE tappstweet_production WITH OWNER william;

DROP TABLE userTwitter CASCADE;
DROP TABLE images CASCADE;
DROP TABLE featuresVec CASCADE;
DROP DOMAIN URLTYPE;

CREATE DOMAIN URLTYPE VARCHAR(200) DEFAULT '';

CREATE TABLE TwitterUser (
	idUser INTEGER PRIMARY KEY,  
	name VARCHAR(30), 
	profileImgUrl URLTYPE, 
	description VARCHAR(30)
);

CREATE TABLE images (
	idUser_fk INTEGER,
	imageId INTEGER,
	imageUrl URLTYPE,
	description VARCHAR(30),	

	CONSTRAINT pk_images PRIMARY KEY (idUser_fk, imageId),

	CONSTRAINT fk_user FOREIGN KEY (idUser_fk)
		REFERENCES  userTwitter (idUser)
);

CREATE TABLE featuresVec (
	idUser_fk INTEGER,
	imageId_fk INTEGER,
	featVecId INTEGER,

	histogram TEXT,	

	CONSTRAINT pk_featuresVec PRIMARY KEY (idUser_fk, imageId_fk, featVecId),

	CONSTRAINT fk_images FOREIGN KEY (idUser_fk, imageId_fk)
		REFERENCES  images (idUser_fk, imageId)
);
