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
    # or could do @post = User.find(user_id).post.create(params[:post])   test this
    @stylesheet = 'styles/post.css'
    redirect '/post'
  else
    redirect '/sign-in'
  end
end

get '/sign-out' do
  if current_user
    user = current_user
    @user = User.find(user.id)
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
  @stylesheet = 'styles/forms.css'
  erb :sign_up 
end

post '/sign-up' do
  confirmation = params[:confirm_password]
  if confirmation = params[:user][:password]
    @user = User.create(params[:user])
    params[:profile].merge!(user_id: @user.id)
    Profile.create(params[:profile])
    flash[:notice] = "Successfully signed up #{@user.username}! Login to continue."
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
    flash[:notice] = "User record not found for username: #{username}"
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
    user = current_user
    @user = User.find(user.id)
    @profile = Profile.where(user_id: @user.id).first
    @stylesheet = 'styles/forms.css'
    erb :edit_profile
  else
    redirect '/sign-in'
  end
end

post '/edit-profile' do
  if current_user
    user = current_user
    @user = User.find(user.id)
    @profile = Profile.where(user_id: @user.id).first
    puts @profile
    if !@profile.is_a?(Hash)
      user_profile = params[:profile].merge!(user_id: @user.id)
    end
    if user_profile.is_a?(Hash)
      puts "Is it a hash now #{user_profile.is_a?(Hash)}"
    end
    @profile.update(user_profile)
    flash[:notice] = "Profile updated for #{@user.username}!"
    redirect '/edit-profile'
  else
    redirect '/sign-in'
  end
end

get '/view-profile' do
  puts current_user
  if current_user
    user = current_user
    @user = User.find(user.id)
    @profile = Profile.where(user_id: user.id).first
    # or could use: @profile = User.find(user.id).profile
    if @user.nil? || @user == 'undefined'
      puts "cannot find the profile for #{user_id}"
      flash[:notice] = "Profile not found."
    else
      @stylesheet = 'styles/forms.css'
      flash[:notice] = "Profile for #{@user.username}!"
      erb :view_profile
    end
  else
    redirect '/sign-in'
  end
end

post '/view-profile' do
  if current_user
    @stylesheet = 'styles/forms.css'
    redirect '/view-profile'
  else
    redirect '/sign-in'
  end
end

get '/delete-profile' do
  if current_user
    @stylesheet = 'styles/forms.css'
    erb :delete_profile
  else
    redirect '/sign-in'
  end
end

post '/delete-profile' do
  if current_user
    @user = current_user
    User.find(@user.id).posts.destroy
    User.find(@user.id).profile.destroy
    User.find(@user.id).destroy
    session.clear
    flash[:notice] = "Profile deleted."
    redirect '/'
  else
    redirect '/sign-in'
  end
end

# return value of this method is an object which has all the user details from DB as attributes
# i.e. a user object instance is returned
def current_user
  if session[:user_id]
    puts "session user_id #{session[:user_id]}"
    User.find(session[:user_id])
  end
end

