rails new snacks-api --api --database=postgresql
cd snacks-api
rails db:create

nano config/application.rb
<<< config.api_only = true >>>  //modify

nano config/database.yml
<<< .. >>>  //change database

nano Gemfile
<<< gem 'rack-cors' >>> //add/uncomment
<<<
gem 'devise'
gem 'devise-jwt'
gem 'jsonapi-serializer'
>>>  //add

bundle install

/// khusus cors. agar bisa diakses remote
nano config/initializers/cors.rb
<<<
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000'
    resource(
      '*',
      headers: :any,
      expose: ['access-token', 'expiry', 'token-type', 'Authorization'],
      methods: [:get, :patch, :put, :delete, :post, :options, :show]
    )
  end
end
>>>  //modify

//set config
nano config/environments/development.rb
<<< config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } >>>  //add

nano config/puma.rb
<<<  port ENV.fetch("PORT") { 3000 }  >>>  //modify


##### Devise
// mengenerate service devise(login,signup)
rails generate devise:install

nano config/initializers/devise.rb
<<<  config.navigational_formats = []  >>>   //add


// membuat table dan model 'users' mengikuti schema devise
rails generate devise Users
rails db:migrate

//membuat controller 'users'
rails g devise:controllers users -c sessions registrations
<<< note : -c untuk membuat sub controller dari 'users'. kita buat 2. 'sessions' dan 'registrations')

nano app/controllers/users/sessions_controller.rb
<<<
class Users::SessionsController < Devise::SessionsController
  respond_to :json
end
>>>  //modify

nano app/controllers/users/registrations_controller.rb
<<<
class Users::registrationsController < Devise::registrationsController
  respond_to :json
end

nano #config/routes.rb
<<<
Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
>>>  //modify

###########

###### JWT

/// config jwt
nano config/initializers/devise.rb
<<<
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.fetch(:secret_key_base)
  jwt.dispatch_requests = [
    ['POST', %r{^/login$}]
  ]
  jwt.revocation_requests = [
    ['DELETE', %r{^/logout$}]
  ]
  jwt.expiration_time = 30.minutes.to_i
end
>>>

/// menambahkan field 'jti' di tabel user . untuk simpan token per-user (jti)
rails g migration addJtiToUsers jti:string:index:unique
<<<  note :
addJtiToUsers/terserah = nama migrasi
jti = nama field
string=tipe data
index=diberi index
unique=unik
>>>

nano db/migrate/20241027084559_add_jti_to_users.rb
<<<
def change
  add_column :users, :jti, :string, null: false
  add_index :users, :jti, unique: true

end
>>> //modify

nano app/models/user.rb
<<<
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
>>> //modify

rails db:migrate

###########

##### serializer /mapping model
/// generate model serializer dg nama 'user' di : 'app/serializers/user_serializer.rb'
rails generate serializer user id email created_at
<<< note : akan buat variabel model 'user' dg field (id email created_at) >>>

/// menambah serializer/mapping di Sessions_controller dan RegistrationsController
nano app/controllers/users/sessions_controller.rb
<<<
class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    render json: {
      status: {code: 200, message: 'Logged in sucessfully.'},
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }, status: :ok
  end
  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
>>>  //modify

nano app/controllers/users/registrations_controller.rb
<<<
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  private
def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: {
        status: {code: 200, message: "Signed up sucessfully."},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully."}
      }, status: :ok
    else
      render json: {
        status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
>>>  //modify
###########

#### bugsfixing di devise session
nano app/controllers/concerns/rack_session_fix.rb   //add-file
<<<
module RackSessionFix
  extend ActiveSupport::Concern
  class FakeRackSession < Hash
    def enabled?
      false
    end
  end
  included do
    before_action :set_fake_rack_session_for_devise
    private
    def set_fake_rack_session_for_devise
      request.env['rack.session'] ||= FakeRackSession.new
    end
  end
end
>>>  //add

// tambahkan kode di sessions_controller dan registrations_controller
nano /home/putra/rubi/snacks-api/app/controllers/users/sessions_controller.rb
<<<
class Users::SessionsController < Devise::SessionsController
  include RackSessionFix  // tambahkan di bawah class
>>>

nano /home/putra/rubi/snacks-api/app/controllers/users/registrations_controller.rb
<<<
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix   // tambahkan di bawah class
>>>


###########

#### create member controllers
nano app/controllers/members_controller.rb   //add-file
<<<
class MembersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:all]
  def index
      render json: {status: {code: 200, message: 'Current logged in user'}, data: current_user}
  end

  def all
      render json: {status: {code: 200, message: 'All users'}, data: User.all}
  end
end
>>>add

nano config/routes.rb
<<<
Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'users/current', to: 'members#index'  //add
  get 'users/all', to: 'members#all'   //add
end
>>> modify
####


rails s


##### Test curl
///signup
curl --location 'http://localhost:3000/signup' --header 'Content-Type: application/json' --data-raw '{ "user": { "email": "test1@test.com","password": "password" }}'

///login
curl -i --location 'http://localhost:3000/login' --header 'Content-Type: application/json' --data-raw '{"user":{"email":"broker@example.com","password": "password"}}'

//users/current
curl --location 'http://localhost:3000/users/current' --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJlMzI2YTg0Ny04NGZmLTQ5MjAtYTU2NS0xNzdhY2Q2YmNlMzYiLCJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzMwMTU2NzYzLCJleHAiOjE3MzAxNTg1NjN9.hspO2inEqvg4TFBtlpbWlHgO2YTVWgKZC9BQ4_aHjcc'

//users/all (no authentication)
curl --location 'http://localhost:3000/users/all'

///logout
curl --location --request DELETE 'http://localhost:3000/logout' --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIyYTBkMGFmYi1kZWI5LTQ0ZTctYTU0NC01ZjZmMDk4NzkyMzMiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzMwMDM2MjYzLCJleHAiOjE3MzAwMzgwNjN9.lruXS89o16DXXVIFiLwI4-LbsnuGV32qFucV0O7RCC0'
