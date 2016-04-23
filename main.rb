require 'sinatra'
require 'sinatra/flash'

require './db_config'
require './models/user'
require './models/comment'
require './models/photo'
require './models/like'


enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id]) #returns nil if cant find anything
  end

  def admin
    User.find(1).id
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

    session[:user_id] = user.id

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
    upload.img = params[:image]
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

delete '/comment/:id' do
# deleting comment
  delete_comment = Comment.find(params[:id])
  delete_comment.destroy

  redirect to "/edit"

end
