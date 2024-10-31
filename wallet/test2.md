token=""

curl --location 'http://localhost:3000/signup' --header 'Content-Type: application/json' --data-raw '{ "user": { "email": "team1@test.me","password": "password" }}'

curl -d '{ "transaction_type":"sell","stock_id":"60","price":"119.88","quantity":"10" }' -H "Content-Type: application/json" --header  "Authorization: Bearer $token" 'Content-Type: application/json' -X POST http://localhost:3000/orders


///buyer@example.com, team1@test.me
curl -i --location 'http://localhost:3000/login' --header 'Content-Type: application/json' --data-raw '{"user":{"email":"team1@test.me","password": "password"}}'


curl --location 'http://localhost:3000/dashboard/stockwallet' --header "Authorization: Bearer $token"

curl --location 'http://localhost:3000/dashboard/moneywallet' --header "Authorization: Bearer $token"

curl --location 'http://localhost:3000/dashboard/myinfo' --header "Authorization: Bearer $token"

curl --location 'http://localhost:3000/dashboard/mytransaction' --header "Authorization: Bearer $token"

curl --location 'http://localhost:3000/dashboard/mytransactionrecord' --header "Authorization: Bearer $token"

curl --location 'http://localhost:3000/dashboard/my_info' --header "Authorization: Bearer $token"













///logout
curl --location --request DELETE 'http://localhost:3000/dashboard' --header "Authorization: Bearer $token"


curl --location 'http://localhost:3000/users/current' --header "Authorization: Bearer $token"


curl --location 'http://localhost:3000/orders/all' --header "Authorization: Bearer $token"
