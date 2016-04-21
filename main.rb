require 'PG'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'

require './db_config'
require './models/user'
require './models/comment'
require './models/photo'
require './models/like'


enable :sessions

CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3 should be made available through an Environment variable.
    # For local installations, export the env variable through the shell OR
    # if using Passenger, set an Apache environment variable.
    #
    # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
    #
    # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_ASSET_URL=http://assets.example.com/ S3_BUCKET_NAME=s3_bucket/folder

    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET'],
    :region                => 'ap-southeast-2',
    :host   => 's3-ap-southeast-2.amazonaws.com'
  }

  config.storage = :fog
  config.fog_directory    = ENV['S3_BUCKET']

  # config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku
end

helpers do
  def current_user
    User.find_by(id: session[:user_id]) #returns nil if cant find anything
  end

  def logged_in?
    !!current_user
  end

end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  erb :index
end

# Creating new user here
post '/new' do
  firstname = params[:firstname]
  lastname = params[:lastname]
  username = params[:username]
  email = params[:email]
  password = params[:password]

# Check if username and email is already taken
  if User.exists?(username: params[:username]) || User.exists?(email: params[:email])

    flash[:error] = "Sorry your username or email has been taken. Please retry again"
    redirect '/'

# Creates new user if username and email not taken
  else
    user = User.new
    user.firstname = params[:firstname]
    user.lastname = params[:lastname]
    user.username = params[:username]
    user.email = params[:email]
    user.password = params[:password]
    user.save
    redirect to '/home'

  end
end

post '/login' do

  user = User.find_by(email: params[:email])

#if true then authenticate the password
#create a new session to store id
  if user && user.authenticate(params[:password])

    session[:user_id] = user.id

    redirect to '/home'
  else
#Show error if email and password is incorrect

    flash[:error] = "Sorry your email or password is incorrect. Please retry again"
    redirect '/'
  end

end

get '/home' do
  @photo = Photo.all

  @user = current_user

  @like = Like.all

  erb :home
end

# delete session on logout
delete '/login' do
  session[:user_id] = nil
  redirect to '/'
end

post '/upload' do
# if image path not nil then save photo
  if params[:image] != nil
    upload = Photo.new
    upload.img_url = params[:image]
    upload.user_id = session[:user_id]
    upload.save
  end

  redirect to '/home'
end

get '/info/:id' do

  @info = Photo.find(params[:id])

  @comments = @info.comments

  @likes = @info.likes.count

  erb :info
end

post '/info/:id/comments' do
# create new comment if its not empty
  if params[:body] != ""
    comment = Comment.new
    comment.body = params[:body]
    comment.user_id = session[:user_id]
    comment.photo_id = params[:id]
    comment.save
  end

  redirect to "/info/#{params[:id]}"
end

patch '/edit/details' do
# Editing email or password
  @user = current_user
  @user.email = params[:email]
  @user.password = params[:password]
  @user.save

  redirect to "/home"
end

get '/edit' do
# displaying dashboard of images owned by user
  @images = Photo.all.where(user_id: session[:user_id])

  erb :edit
end

delete '/edit/:id' do
# deleting images
  img = Photo.find(params[:id])
  img.destroy

  redirect to '/edit'

end

get '/likes/:photoid' do
# saves likes
  like = Like.new
  like.user_id = session[:user_id]
  like.photo_id = params[:photoid]
  like.save

  redirect to "/info/#{params[:photoid]}"

end
