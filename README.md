# README


API routes, requirements and other information:

--------------------------------------------------------------------------------
New user creation route:
POST   /users(.:format)
params permitted: :name, :email, :password, :userpic, :bio

Input:
[No root key]

Key         Value Constraints
:name       *Required field, must be unique, "." and "-" will be converted into "_" (1 to 255char)
:email      *Required field, must be unique, valid email address, within regex validation (1 to 255char)
:password   *Required field, (1 to 255char)
:userpic    None, should be link to users hosted picture (1 to 255char)
:bio        None (1 to 4294967296char)

Sample Input:
name=danyo&email=dwegrzen%40gmail.com&password=password

Sample Output:

{
    "name": "danyo",
    "bio": null,
    "email": "dwegrzen@gmail.com",
    "userpic": null,
    "api_token": "4fe0234cf1cb01b0df72"
}

Notes: api_token will be generated and needed for transactions on the site. * fields above will generate validation errors. User creation duplicated below. Sign-up email will be sent to new user's email address.

Sample Error:
{
    "errors": [
        "Name has already been taken",
        "Email has already been taken"
    ]
}

--------------------------------------------------------------------------------
Sign-in route:
POST   /login(.:format)
params permitted: :name, :password

Input:
[No root key]

Key         Value Constraints
:name       *Required field, searches user database for matching name
:password   *Required field, authenticates login against database password for user with value :name

Sample Output:

{
    "api_token": "4fe0234cf1cb01b0df72"
}

Notes: Upon successful validation, returns the user's api_token stored in the database. This value will be needed for future transactions on the site.

Sample Errors:

Wrong password-
{
    "error": "Password incorrect"
}
HTTP/1.1 422 Unprocessable Entity

Username not found-
{
    "error": "User not found"
}
HTTP/1.1 422 Unprocessable Entity

--------------------------------------------------------------------------------
User timeline route:
GET    /timeline(.:format)
params permitted: api_token

Input:
[No root key]

Key         Value Constraints
:api_token  *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions

Sample Output:
[
    {
        "body": "You know, that little droid is going to cause me a lot of trouble.",
        "user_id": 1,
        "id": 295,
        "user": {
            "id": 1,
            "name": "jailyn_blanda",
            "email": "jovany_brown@waelchijaskolski.name",
            "userpic": "https://robohash.org/daniel",
            "bio": "Biodiesel waistcoat before they sold out wolf chillwave yr.",
            "followees_count": 1,
            "followers_count": 4,
            "chirp_count": 6,
            "currently_being_followed": false
        }
    },
    {
        "body": .....
    }
]

Notes: Returns timeline of all chirps the user has created and chirps of the current user's followees. Additionally contains user data from each of those chirps.

Sample Error:

If incorrect api_token or no api_token is provided-
{
    "error": "You need to be logged in to do that."
}
HTTP/1.1 403 Forbidden

--------------------------------------------------------------------------------
Profile route
GET    /profile(.:format)

Input:
[No root key]

Key         Value Constraints
:api_token  *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions

Sample Output:
{
    "id": 1,
    "name": "jailyn_blanda",
    "email": "jovany_brown@waelchijaskolski.name",
    "userpic": "https://robohash.org/daniel",
    "bio": "Biodiesel waistcoat before they sold out wolf chillwave yr.",
    "followees_count": 1,
    "followers_count": 4,
    "chirp_count": 6,
    "currently_being_followed": false,
    "chirps": [
        {
            "body": "I have a bad feeling about this.",
            "user_id": 1,
            "id": 119
        },
        {
            ....
        }
    ]
}

Notes: Returns only current user's information and their own chirps.

Sample Error:

If incorrect api_token or no api_token is provided-
{
    "error": "You need to be logged in to do that."
}
HTTP/1.1 403 Forbidden

--------------------------------------------------------------------------------
Other user profile show (non current_user)
GET    /users/:id(.:format)

Input:
[No root key]

Key         Value Constraints
:id         Provide a valid user_ID to display that users profile and chirps

Sample Output:
{
    "id": 3,
    "name": "jeika",
    "email": "talia.schinner@reinger.name",
    "userpic": "https://robohash.org/daniel",
    "bio": "Loko sartorial small batch blog cliche synth occupy try-hard.",
    "followees_count": 7,
    "followers_count": 5,
    "chirp_count": 2,
    "currently_being_followed": false,
    "chirps": [
        {
            "body": "That is why you fail.",
            "user_id": 3,
            "id": 124
        },
        {
            .....
        }
    ]
}

Notes: Does not require an api_token to query a user. If user_id does not exist:
HTTP/1.1 404 Not Found

--------------------------------------------------------------------------------
Chirp and user database search
POST    /search/:search(.:format)

Input:
[No root key]

Key         Value Constraints
:search     search term as a string that is used to query through user and chirp databases
:api_token   *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions

Search Input:
search=droid&api_token=b7dd53c81359624aed7b

Sample Output:
[
    {
        "id": 108,
        "name": "droid",
        "email": "droid@droidguy.net",
        "userpic": null,
        "bio": null,
        "followees_count": 0,
        "followers_count": 0,
        "chirp_count": 0,
        "currently_being_followed": false,
        "chirps": []
    },
    {
        "body": "You know, that little droid is going to cause me a lot of trouble.",
        "user_id": 35,
        "id": 23,
        "user": {
            "id": 35,
            "name": "lon_boyle",
            "email": "beie_schinner@feil.info",
            "userpic": "https://robohash.org/daniel",
            "bio": "Pickled whatever thundercats meggings listicle.",
            "followees_count": 4,
            "followers_count": 4,
            "chirp_count": 3,
            "currently_being_followed": false
        }
    },
    {
        "body": .....

        }
    }
]

Notes: Will return results from both user database (name, email) and chirps (body) which contain the search string. If no search results, following is returned:

No result:
{
    "result": "no search results"
}

--------------------------------------------------------------------------------
Follow user chirps
POST   /follow/:id(.:format)

Input:
[No root key]

Key         Value Constraints
:id         user_id of person that the current user wants to follow
:api_token  *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions

Sample Output:
[
    {
        "id": 4,
        "name": "arne",
        "email": "creola_champlin@spencer.name",
        "userpic": "https://robohash.org/daniel",
        "bio": "Fixie brooklyn gluten-free pbr&b knausgaard direct trade franzen kinfolk.",
        "followees_count": 1,
        "followers_count": 1,
        "chirp_count": 5,
        "currently_being_followed": true,
        "chirps": [
            {
                "body": "You will never find a more wretched hive of scum and villainy. We must be cautious.",
                "user_id": 4,
                "id": 28
            },
            {
              ....
            }
        ]
    },
    {
        "id": 5,
        .....
    }
]        

Notes: Returns list of the current_user's followees as well as any followees' chirps. Must have an api_token to request a follow. Will send an email to the person that is followed to notify them who is following them. No issues if person is already followed. currently_being_followed flag switched to true upon follow (relative to current_user)

Sample Errors:

If incorrect api_token or no api_token is provided-
{
    "error": "You need to be logged in to do that."
}
HTTP/1.1 403 Forbidden

If user_id does not exist:
HTTP/1.1 404 Not Found

--------------------------------------------------------------------------------
Unfollow user chirps
DELETE   /unfollow/:id(.:format)

Input:
[No root key]

Key         Value Constraints
:id         user_id of person that the current user wants to unfollow
:api_token  *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions


Sample Output:
[
    {
        "id": 4,
        "name": "arne",
        "email": "creola_champlin@spencer.name",
        "userpic": "https://robohash.org/daniel",
        "bio": "Fixie brooklyn gluten-free pbr&b knausgaard direct trade franzen kinfolk.",
        "followees_count": 1,
        "followers_count": 1,
        "chirp_count": 5,
        "currently_being_followed": true,
        "chirps": [
            {
                "body": "You will never find a more wretched hive of scum and villainy. We must be cautious.",
                "user_id": 4,
                "id": 28
            },
            {
                "body": .....
            }
        ]
    }
]

Notes: Returns list of the current_user's followees as well as any followees' chirps. Must have an api_token to request a follow. Currently_being_followed flag switched to flase upon unfollow (relative to current_user). No impact if unfollowed user was not being followed by the user prior to unfollow attempt.

Sample Errors:

If incorrect api_token or no api_token is provided-
{
    "error": "You need to be logged in to do that."
}
HTTP/1.1 403 Forbidden

If user_id does not exist:
HTTP/1.1 404 Not Found

--------------------------------------------------------------------------------
Create new chirp
POST   /chirps

Input:
[No root key]

Key         Value Constraints
:body       body of chirp, can contain up to 170 characters of text
:api_token  *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions

Sample Input:
api_token=cdc58dce053b0c2b083d&body=test%20chirp

Sample Output:
{
    "body": "test chirp",
    "user_id": 108,
    "id": 311,
    "user": {
        "id": 108,
        "name": "droid",
        "email": "droid@droidguy.net",
        "userpic": null,
        "bio": null,
        "followees_count": 1,
        "followers_count": 0,
        "chirp_count": 2,
        "currently_being_followed": false
    }
}

Notes: Sole method of creating chirps, must have an api_token to identify who is making the chirp. Renders new chirp upon creation and shares user information as wel. Will create validation error upon creation attempt of a chirp with :body value >170 characters.

Sample Error:
{
    "body": [
        "is too long (maximum is 170 characters)"
    ]
}
HTTP/1.1 422 Unprocessable Entity

--------------------------------------------------------------------------------
Delete User
DELETE /users/:id(.:format)

Input:
[No root key]

Key         Value Constraints
:id         requires user ID of user that will be removed
:api_token  *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions

No output after deletion, must have api_token of user to be deleted as well. All related chirps will be deleted when after the deletion is processed.

--------------------------------------------------------------------------------
Delete Chirp
DELETE /chirps/:id(.:format)

Input:
[No root key]

Key         Value Constraints
:id         requires chirp ID of chirp that will be removed
:api_token  *Required field, validates user identity with api_token against database and uses to determine                                          current_user in other transactions

No output after deletion, must have api_token of user who created the chirp originally.
