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
 
get '/edit-profile' do
  if current_user
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
  if current_user
    erb :view_profile
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

post '/delete-profile' do
  if current_user
    erb :delete_profile
  else
    redirect '/sign-in'
  end
end



