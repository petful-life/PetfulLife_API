# PetfulLife API

## Introduction

This RESTful JSON API built in Ruby on Rails (RoR) 5.2 is the back end for PetfulLife, a virtual assistant for your pet's life. The [front end repository](https://github.com/petful-life/petfulLife) is built in React Native, and the app is deployed to the Google Play Store [here](https://futuredeployedlink82345923874234.com). This app is the capstone project at [Turing School of Software and Design](https://turing.io/) for the four [core contributors](#core-contributors) and an example of what a full stack team of Turing students can build.

## Initial Setup

Please make sure you have Rails 5.2 installed in your ruby enviornment. If you do not have Ruby or Rails installed, some setup directions can be found [here](https://guides.rubyonrails.org/getting_started.html).

In order to run this API on your local maching, please fork and clone this repository, then from a terminal within the project directory run the following commands:

`bundle install`

`rails s`

The app is configured to run on `localhost:3000`.

A convenient way to interact with an API-only rails app is through [postman](https://www.getpostman.com/).

## Core Contributors

#### Back End Team:
[Vincent Provenzano](https://github.com/Vjp888)

[Jeremy Bennett](https://github.com/jaxjafinpapau)

#### Front End Team:
[Adam Niedzwiecki](https://github.com/AdamN8142)

[Lauren Boyer](https://github.com/lboyer4)

## How to Contribute

Please follow the [initial setup](#initial-setup) instructions, then when you have completed your contribution, create a pull request to the PetfulLife API master branch.

## How to use

A sample request could be GET `localhost:3000/api/v1/products`.

## Endpoints:

### Users

Reaching user Endpoints will use ```/api/v1/users```

users have complete CRUD functionality

**`GET /api/v1/users/:id`**

In order to receive a user you are required to know that user's ID

This will return a user's information **minus** their password information for security purposes. No request body is required.

Response:

Status: 200

```
{"data"=>
	{"id"=>"20",
	 "type"=>"user",
	 "attributes"=>
	 	{"id"=>20,
	 	 "username"=>"bob"}
	 }
}
```

Should there be no present user the Response will return

```status: 404 {error: User not found}```


**`POST /api/v1/users`**

When posting to the endpoint all fields are required

Request:

Body:

Status: 201

```
{
	"username": 'USERNAME',
	"email": 'EMAIL',
	"password": 'PASSWORD',
	"password_confirmation", 'PASSWORD_CONFIRMATION'
}
```

Response:

```
{"data"=>
	{"id"=>"20",
	 "type"=>"user",
	 "attributes"=>
	 	{"id"=>20,
	 	 "username"=>"bob"}
	 }
}

```

If there is a failure the return of this request will give explicit errors as to the problem. Likely errors include missing fields or mismatched passwords.

**`PATCH /api/v1/users/:id`**

When a user wishes to update their information they are able to do so completely or with single field requests.

The user ID is required to update a user's information


Body:

Again This request may contain one or all field in the body, the exception if the ```password``` and ```password_confirmation``` fields.

```
{
	"username": 'USERNAME',
	"email": 'EMAIL',
	"password": 'PASSWORD',
	"password_confirmation", 'PASSWORD_CONFIRMATION'
}
```

Response:

Status: 201

```
{"data"=>
	{"id"=>"20",
	 "type"=>"user",
	 "attributes"=>
	 	{"id"=>20,
	 	 "username"=>"bob"}
	 }
}

```

Should any of the field be incorrect or if the passwords are mismatched the response will be explicit error messages regarding the failure. with a status of  400

**`DELETE /api/v1/users/:ID`**

When an administrator wishes to delete the user they are required to have the ID of that user.

**This is permanent and *can not* be undone**

Response: ```Status: 204```

Should it fail the response will be ```status: 404 {error: 'user not found'}```


### Products

Depending on the type of manipulation required, the base URL for product end points will change.

**`GET /api/v1/products`**

Upon success:  
Status -- 200
Return all products, serialized as:  

```
data: {
	products: {
		[
			{
				"id": 1,
				"name": "Purina Puppy Chow",
				"avg_rating": 4.74,
				"avg_price": 25.91
				"createdAt": "2019-07-02T19:15:59.841Z",
				"updatedAt": "2019-07-02T19:15:59.841Z"
			},
			{
				"id": 2,
				"name": "Purina Kitten Pate",
				...
			},
			...
		]
	}
}
```

**`GET /api/v1/products/:product_id`**:

Upon success:
Status -- 200
Return a single product, serialized as:

```
data: {
	product: {
			"id": 1,
			"name": "Purina Puppy Chow",
			"avg_rating": 4.74,
			"avg_price": 25.91
			"createdAt": "2019-07-02T19:15:59.841Z",
			"updatedAt": "2019-07-02T19:15:59.841Z"
		}
	}

```

**`GET /api/v1/users/:user_id/products`**:

Upon success:
Status -- 200
Returns all products that a particular user has identified that they are using or trying, serialized as:

```
"data": {
	"attributes": {
	 	"id": 1,
	 	"username": "bob",
		"products":
			[
				{
					"id": 1,
					"name": "Purina Puppy Chow",
					"avg_rating": 4.74,
					"avg_price": 25.91
					"createdAt": "2019-07-02T19:15:59.841Z",
					"updatedAt": "2019-07-02T19:15:59.841Z"
				},
				{
					"id": 2,
					"name": "Purina Kitten Pate",
					...
				},
				...
			]
	}
}

```

**`GET /api/v1/users/:user_id/pets/:pet_id/products`**

Upon success:
Status -- 200
Returns all products associated to that a particular pet assigned by the user, serialized as:

```
"data": {
	"attributes": {
	 	"id": pet.id,
		"products":
			[
				{
					"id": 1,
					"name": "Purina Puppy Chow",
					"avg_rating": 4.74,
					"avg_price": 25.91,
					"good_or_bad": true,
					"notes": "There is way better puppy food."
					"createdAt": "2019-07-02T19:15:59.841Z",
					"updatedAt": "2019-07-02T19:15:59.841Z"
				},
				{
					"id": 2,
					"name": "Purina Kitten Pate",
					...
				},
				...
			]
	}
}

```

**`GET /api/v1/users/:user_id/pets/:pet_id/products/:product_id`**

Upon success:
Status -- 200
Returns product associated to that a particular pet assigned by the user, serialized as:

```
"data": {
	"attributes": {
	 	"id": product.id,
	 	"pet_id": pet.id,
	 	"user_id": user.id,
		"product":
				{
					"id": 1,
					"name": "Purina Puppy Chow",
					"avg_rating": 4.74,
					"avg_price": 25.91,
					"good_or_bad": false,
					"notes": "gave puppy an upset tummy.",
					"createdAt": "2019-07-02T19:15:59.841Z",
					"updatedAt": "2019-07-02T19:15:59.841Z"
				}
	}
}

```


**`POST /api/v1/products`**
Allows a user to access an existing DB product or create it simply by scanning a UPC. The UPC and the user id are required to make a POST request. The post request will automatically associate this product to this user.

Request body:

```
{ upc: 110011001100, user_id: 1 }
```

Response:
Status: 201
Body:

```
data: {
	product: {
			"id": 1,
			"name": "Purina Puppy Chow",
			"avg_rating": 4.74,
			"avg_price": 25.91
			"upc": 110011001100,
			"createdAt": "2019-07-02T19:15:59.841Z",
			"updatedAt": "2019-07-02T19:15:59.841Z"
		}
	}
```

**`POST /api/v1/users/:user_id/pets/:pet_id/products/:product_id`**
Allows a user to associate any product that they have scanned, thereby associated it to their account, to any of the pets they have created.

No request body is required, however the id's of the owner, their pet, and their product must be known. Response will be 204 no content if successful, 404 if one of the resources (user, pet, or product) is not found, or 400 if the request fails entirely.

**`PATCH /api/v1/users/:user_id/pets/:pet_id/products/:product_id`**
Allows a user to update the good_or_bad rating stored on the pet_products joins table as well as save any notes they have about the product.

Request body:

```
{ good_or_bad: "bad", notes: "Kitty had itchy skin." }
```

Response:
    Status: 202

The good_or_bad value in the db is stored as a boolean, so any get requests containing this information will enumerate to:

```
"bad" = false
"good" = true
```

**`DELETE /api/v1/products/:product_id`**

No request body is required, however the id of the product must be known. Response will be 204 no content, or 400 bad request depending on outcome.


###Pets
In order to receive any pet information you must know the pets' owner id
The base request URL is

```/api/v1/users/:user_id/pets```

**`GET /api/v1/user/:user_id/pets`**

To recieve all pets associated with a user:

Response:

Status: 200

```
{"data"=>
  {"id"=>"753",
   "type"=>"user_pets",
   "attributes"=>
    {"id"=>753,
     "username"=>"bob",
     "pets"=>
	      [{"id"=>351,
	      	"name"=>"Chocolate",
	      	"nickname"=>"Choco",
	      	"breed"=>"mutt",
	      	"archetype"=>"dog"},
	       {"id"=>352,
	       "name"=>"Vanilla",
	       "nickname"=>"Van",
	       "breed"=>"mutt",
	       "archetype"=>"dog"}]
	      	}
	 }
}
```

**`GET /api/v1/users/:user_id/pets/:pet_id`**

This will return a single pet's information You must know the User ID **and** Pet Id.

Response:

Status: 200

```
{"data"=>
  {"id"=>"741",
   "type"=>"user_pets",
   "attributes"=>
    {"id"=>741,
     "username"=>"bob",
     "pets"=> {"id"=>341,
     			  "name"=>"Chocolate",
     			  "nickname"=>"Choco",
     			  "breed"=>"mutt",
     			  "archetype"=>"dog"}
     			  }
 }}
```

**`POST /api/v1/users/#{@user.id}/pets`**

This action will allow a user to create a pet. You must have a user and know the user ID to create a pet.

Body:

Nickname is **optional**

```
{
  'name': 'pupper',
  'nickname': 'pup',
  'archetype': 'dog',
  'breed': 'mutt'
}
```

Response:

Status: 201

```
{"data"=>
  {"id"=>"369",
   "type"=>"pet",
   "attributes"=>{"id"=>369,
   					"name"=>"pupper",
   					"nickname"=>"pup",
   					"breed"=>"mutt",
   					"archetype"=>"dog"}}}
```

**`PATCH "/api/v1/users/#{@user.id}/pets/#{pet.id}"`**

To update a pet's information you need the user ID and pet ID. You are able to update all or single fields as needed.

Body:

Each field is optional but you must include at least one.

```
{
  'name': 'pupper',
  'nickname': 'pup',
  'archetype': 'dog',
  'breed': 'motto'
}
```

Response:

Status: 202

```
{"data"=>
  {"id"=>"382",
   "type"=>"pet",
   "attributes"=>{"id"=>382,
   					"name"=>"pupper",
   					"nickname"=>"pup",
   					"breed"=>"motto",
   					"archetype"=>"dog"}
  }
}
```

**`DELETE /api/v1/users/:user_id/pets/:pet_id`**

To delete a pet you must know the user id and pet id. The User must also own the Pet to be able to delete it.

**This is permanent and *can not* be undone**

Response:

Status: 204

## Tests

The test suite for this project is rspec. In order to run the suite, after following the [initial setup](#initial-setup) instructions above, run the following from a terminal in the root project directory:

`bundle exec rspec`


## Database Schema

![mock_search](db_schema.png)

## Tech Stack

- Ruby on Rails 5.2
- Travis CI
- Rspec
