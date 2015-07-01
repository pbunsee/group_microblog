require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:nottwitter.sqlite3"

get '/sign-up' do
  erb :sign_up
end
  

post '/sign-up' do
  confirmation = params[:confirm_password]
  if confirmation = params[:user][:password]
    @user = User.create(params[:user])
    "SIGNED UP #{@user.username}"
  else
    "Your password & confirmation password did not match. Try again."
  end
end


