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
