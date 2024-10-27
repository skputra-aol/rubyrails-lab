## simple API
-crud

## step - create & config:
rails new my_api --api
cd my_api

//##set config for just API not MVC
nano config/application.rb
<<< config.api_only = true  >>>  //add

nano config/environments/development.rb
<<< config.debug_exception_response_format = :api  >>> //modify


## step - create migration & modul:

///create file migration for table 'Group'
bin/rails g scaffold Group name:string

///exec migrasi ke db (membuat table Group)
bin/rails db:migrate

nano app/controllers/groups_controller.rb  
<<< >>> //modify

nano app/controllers/application_controller.rb   //modify
<<< class ApplicationController < ActionController::API  >>>  //modify
