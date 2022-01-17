
# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:
## Local Development

You'll want to configure your machine to run:
* Ruby 2.7.2
* Postgres

* Configuration
  - bundle install

* Database creation
  - rails db:create

* Database initialization
  - rails db:migrate

* How to run the test suite
  - bundle exec rspec

# How to test API's

## For registration/signup
  * Signup: POST 'localhost:3000/api/v1/users?username=joe&email=joe@example.com&password=123456&password_confirmation=123456&role=buyer'
  * Login:  POST 'localhost:3000/api/v1/users/sign_in?email=krish@gmail.com&password=123456'
  
  ![Screenshot from 2022-01-17 23-02-28](https://user-images.githubusercontent.com/43177786/149815569-43c2f35f-01a9-4329-9050-f6d5dcf484e2.png)
  
  * For authentication we need to pass below three mentioned values in header for each request
    * access-token
    * client
    * uid

  * How to get them : After getting response from sign/signup api, under the header section we find above values.
    ![Screenshot from 2022-01-17 23-09-35](https://user-images.githubusercontent.com/43177786/149816214-dc58a2a4-4997-4153-948c-4605a8d94b64.png)
    
## For /deposit Api : Header in attached screenshot
  * PUT localhost:3000/api/v1/users/5/deposit  # 5 => User_id
    * params : {
                "user_id": 2,
                "user": {"deposit":"{\"cent5\":\"10\",\"cent10\":\"10\",\"cent20\":\"10\",\"cent50\":\"1\",\"cent100\":\"10\"}"}
              }
              
   ![Screenshot from 2022-01-18 00-07-06](https://user-images.githubusercontent.com/43177786/149822594-ce3c0e2f-9b6a-4c4a-8ffb-f8edcf7b269f.png)
   
## For /buy Api : Header in attached screenshot
  * GET localhost:3000/api/v1/products/buy
    * params: ![Screenshot from 2022-01-18 00-08-46](https://user-images.githubusercontent.com/43177786/149822770-f48861c0-8ed2-41b5-a11a-ae139dc94e90.png)
  
  * Response 
   ![Screenshot from 2022-01-18 00-04-07](https://user-images.githubusercontent.com/43177786/149822836-28b81cd6-431a-45aa-b22d-1c7d98a429ff.png)

    
