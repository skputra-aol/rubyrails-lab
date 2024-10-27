## cmd
///open irb shell tools
irb

//buat project baru hanya api
rails new my_api --api

///create file migration for table 'Group'
bin/rails g scaffold Group name:string
///exec migrasi ke db (membuat table Group)
bin/rails db:migrate

//lihat middleware/plugin sisipan (ex:jwt,session,cache) yg terinstall
bin/rails middleware
