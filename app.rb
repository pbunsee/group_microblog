require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

set :database, "sqlite3:nottwitter.sqlite3"
#set :sessions, true

enable :sessions

# configure (:development)

use Rack::Flash, sweep: true

get "/" do
  if current_user
    @current_user = current_user
    erb :welcome
  else
    redirect '/sign-in'
  end
end

get '/sign-up' do 
  erb :sign_up 
end

get '/sign-in' do
  erb :sign_in
end

get '/welcome' do
  if current_user
    erb :welcome 
  else
    flash[:notice] = "Please sign in"
    redirect '/'
  end
    erb :welcome
end

post '/sign-up' do 
  @paramaters = [params:phone_number]
  User.create()#put the values inside these parethesis somehow
end

post '/sign-in' do
  username = params[:user][:username]
  password = params[:user][:password]
  puts "username #{username}"
  puts "password #{password}"

  @user = User.where(username: username).first
  puts @user

  if @user and @user.password == password
    session[:user_id] = @user.id
    flash[:notice] = "Welcome #{@user.username}!"
    redirect '/'
  else
    flash[:notice] = "Wrong login info, please try again"
    redirect '/sign-in'
  end
  #erb :welcome
end

get '/sign-out' do

  session[:user_id] = nil
  flash[:notice] = "Signed Out Successfully.  Come back soon!"
  redirect '/'
end

def current_user
  if session[:user_id]
    User.find session[:user_id]
  end
end


