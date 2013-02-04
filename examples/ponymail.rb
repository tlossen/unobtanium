require 'pony'
Pony.mail(
   :name => params[:name],
  :mail => params[:mail],
  :body => params[:body],
  :to => 'a_lumbee@gmail.com',
  :subject => params[:name] + " has contacted you",
  :body => params[:message],
  :port => '587',
  :via => :smtp,
  :via_options => { 
    :address              => 'smtp.gmail.com', 
    :port                 => '587', 
    :enable_starttls_auto => true, 
    :user_name            => 'lumbee', 
    :password             => 'p@55w0rd', 
    :authentication       => :plain, 
    :domain               => 'localhost.localdomain'
  })