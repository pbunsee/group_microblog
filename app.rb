require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

configure(:development){set :database, "sqlite3:nottwitter.sqlite3"}
enable :sessions
use Rack::Flash, sweep: true

get "/" do
  if current_user
    @current_user = current_user
    redirect '/post'
  else
    redirect '/sign-in'
  end
end

get '/post' do
  @post = {}
  if current_user
    user_id = session[:user_id]
    @post = User.find(user_id).posts
    puts "user_id #{user_id} has #{@post.size} posts"
    @stylesheet = 'styles/post.css'
    erb :post
  else
    redirect '/sign-in'
  end
end

post '/post' do
  if current_user
    @post = Post.create({body: params[:post], user_id: session[:user_id]})
    # or could do @post = User.find(user_id).post.create(:post)
    @stylesheet = 'styles/post.css'
    erb :post
  else
    redirect '/sign-in'
  end
end

get '/sign-out' do
  if current_user
    user_id = current_user
    @user = User.find(user_id)
    session[:user_id] = nil;   
    session.clear
    flash[:notice] = "Signed Out Successfully.  Come back soon!"
    redirect '/'
  else
    redirect '/sign-in'
  end
end

get '/sign-up' do 
    session[:user_id] = nil;   
  erb :sign_up 
end

post '/sign-up' do
  confirmation = params[:confirm_password]
  if confirmation = params[:user][:password]
    @user = User.create(params[:user])
    params[:profile].merge!(user_id: @user.id)
    Profile.create(params[:profile])
    flash[:notice] = "Successfully signed up #{@user.username}!"
    redirect '/sign-in'
  else
    flash[:notice] = "Please sign in"
    redirect '/'
  end
end

get '/sign-in' do
  @stylesheet = 'styles/sign_in.css'
  erb :sign_in
end

post '/sign-in' do
  username = params[:user][:username]
  password = params[:user][:password]

  @user = User.where(username: username).first

  if @user == 'undefined' || @user.nil?
    flash[:notice] = "User not found. undefined, nil or empty for username: #{username} password: #{password}"
    redirect '/sign-up'
  else
    if @user.password == password
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username}!"
      redirect '/post'
    else
      flash[:notice] = "Incorrect username or password. Please try again."
      redirect '/sign-in'
    end
  end
end
 
get '/edit-profile' do
  if current_user
    user_id = current_user
    @user = User.find(user_id)
    @profile = Profile.where(user_id: user_id).first
    erb :edit_profile
  else
    redirect '/sign-in'
  end
end

post '/edit-profile' do
  if current_user
    erb :edit_profile
  else
    redirect '/sign-in'
  end
end

get '/view-profile' do
  puts current_user
  if current_user
    user_id = current_user
    @user = User.find(user_id)
    @profile = Profile.where(user_id: user_id).first
    # or could use: @profile = User.find(user_id).profile
    if @user.nil? || @user == 'undefined'
      puts "cannot find the profile for #{user_id}"
      flash[:notice] = "Profile not found."
    else
      erb :view_profile
    end
  else
    redirect '/sign-in'
  end
end

post '/view-profile' do
  if current_user
    erb :view_profile
  else
    redirect '/sign-in'
  end
end

get '/delete-profile' do
  if current_user
    erb :delete_profile
  else
    redirect '/sign-in'
  end
end

post '/delete-profile' do
  if current_user
    user_id = current_user
    User.find(user_id).posts.destroy
    User.find(user_id).profile.destroy
    User.find(user_id).destroy
    session.clear
  else
    redirect '/sign-in'
  end
end

def current_user
  if session[:user_id]
    puts "session user_id #{session[:user_id]}"
    User.find(session[:user_id])
  end
end

