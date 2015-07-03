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
    erb :index
  else
    puts "redirect to sign-in 1"
    redirect '/sign-in'
  end
end

get '/post' do
  @stylesheet = 'styles/post.css'
  erb :post
end

post '/post' do
  @post = Post.create({body: params[:post]})
  @stylesheet = 'styles/post.css'
  erb :post
end

get '/sign-out' do
  user_id = session[:user_id]
  @user = User.find(user_id)
  session.clear
  flash[:notice] = "Signed Out Successfully.  Come back soon!"
  redirect '/'
end

get '/sign-up' do 
  erb :sign_up 
end

post '/sign-up' do
  confirmation = params[:confirm_password]
  if confirmation = params[:user][:password]
    @user = User.create(params[:user])
    params[:profile].merge!(user_id: @user.id)
    Profile.create(params[:profile])
    "SIGNED UP #{@user.username}"
    erb :index
  else
    flash[:notice] = "Please sign in"
    redirect '/'
  end
end

get '/sign-in' do
  puts "erb to sign-in 1"
  erb :sign_in
end

post '/sign-in' do
  username = params[:user][:username]
  password = params[:user][:password]

  @user = User.where(username: username).first

  if @user == 'undefined' || @user.nil?
    puts "@user is undefined, nil or empty for username: #{username} password: #{password}"
    flash[:notice] = "User not found. undefined, nil or empty for username: #{username} password: #{password}"
    redirect '/sign-up'
  else
    if @user.password == password
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username}!"
      redirect '/'
    else
      puts "Password incorrect."
      flash[:notice] = "Incorrect username or password. Please try again."
      redirect '/sign-in'
    end
    puts "username: #{username}"
    puts "password: #{password}"
    puts "@user: #{@user}"
    puts "@user.username: #{@user.username}"
    puts "@user.password: #{@user.password}"
  end
end
 
get '/edit-profile' do
  if current_user
    user_id = session[:user_id]
    @user = User.find(user_id)
    @profile = Profile.where(user_id: user_id).first
    erb :edit_profile
  else
    puts "redirect to sign-in 2"
    redirect '/sign-in'
  end
end

post '/edit-profile' do
  if current_user
    erb :edit_profile
  else
    puts "redirect to sign-in 3"
    redirect '/sign-in'
  end
end

get '/view-profile' do
  puts "session user_id #{session[:user_id]}"
  puts current_user
  if current_user
    user_id = session[:user_id]
    @user = User.find(user_id)
    @profile = Profile.where(user_id: user_id).first
    if @user.nil? || @user == 'undefined'
      puts "cannot find the profile for #{user_id}"
      flash[:notice] = "Profile not found."
    else
      puts "view profile of user:  #{@profile}"
      puts "this is the userID : #{user_id} for #{@user}"
      erb :view_profile
    end
  else
    puts "redirect to sign-in 4"
    redirect '/sign-in'
  end
end

post '/view-profile' do
  if current_user
    erb :view_profile
  else
    puts "redirect to sign-in 5"
    redirect '/sign-in'
  end
end

get '/delete-profile' do
  if current_user
    erb :delete_profile
  else
    puts "redirect to sign-in 6"
    redirect '/sign-in'
  end
end

post '/delete-profile' do
  if current_user
    erb :delete_profile
  else
    puts "redirect to sign-in 7"
    redirect '/sign-in'
  end
end

def current_user
    puts "session user_id #{session[:user_id]}"
  if session[:user_id]
    User.find(session[:user_id])
  end
end

