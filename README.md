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

Notes: Does not require an api_token to query
