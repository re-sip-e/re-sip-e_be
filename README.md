# re•sip•e BE

![ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white) ![ror](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![GraphQL](https://img.shields.io/badge/-GraphQL-E10098?style=for-the-badge&logo=graphql&logoColor=white)

---

## Description:

## GraphQL Queries & Mutations

GraphQL Endpoint URL: `https://re-sip-e-be.fly.dev/graphql`

---

### Get a Bar's Drinks

Example Query w/ All Available Fields:

```
query {
  drinks(barId: 1) {
    id
    name
    imgUrl
    steps
    bar {
      id
      name
    }
    ingredients {
      id
      description
    }
  }
}
```

Example Response:

```JSON
{
  "data": {
    "drinks": [
      {
        "id": "1",
        "name": "Negroni",
        "steps": "Stir into glass over ice, garnish and serve.",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
        "bar": {
          "id": "1",
          "name": "Joe's Bar"
        }
        "ingredients": [
          {
            "id": "5",
            "name": "1 oz Gin"
          },
          {
            "id": "8",
            "name": "1 oz Campari"
          },
          **etc...**
        ]
      },
      **etc...**
    ]
  }
}
```

---

### Get A Single Drink

Example Query w/ All Available Fields:

```
query {
  drink(id: 1) {
    id
    name
    imgUrl
    steps
    bar {
      id
      name
    }
    ingredients {
      id
      description
    }
  }
}
```

Example Response:

```JSON
{
  "data": {
    "drink": {
      "id": "1",
      "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
      "steps": "Stir into glass over ice, garnish and serve.",
      "name": "Negroni",
      "ingredients": [
        {
          "id": "5",
          "description": "1 oz Gin"
        },
        {
          "id": "6",
          "description": "1 oz Campari",
        },
        {
          "id": "7",
          "description": "1 oz Sweet Vermouth"
        }
      ]
    }
  }
}
```

---

### Get API Search Result Drinks

Example Query w/ All Available Fields:

```
query {
  apiDrinks(query: "negroni") {
    id
    name
    imgUrl
    steps
    ingredients {
      description
    }
  }
}
```

Example Response:

```JSON
{
  "data": {
    "apiDrinks": [
      {
        "id": "11003",
        "name": "Negroni",
        "steps": "Stir into glass over ice, garnish and serve.",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
        "ingredients": [
            {
              "description": "1 oz Gin"
            },
            {
              "description": "1 oz Campari"
            },
            **etc...**
        ]
      },
      **etc...**
    ]
  }
}
```

---

### Get Single API Drink

Example Query w/ All Available Fields:

```
query {
  apiDrink(id: 11003){
    id
    name
    steps
    imgUrl
    ingredients {
      description
    }
  }
}
```

Example Response:

```JSON
{
  "data": {
    "apiDrink": {
      "id": "11003",
      "name": "Negroni",
      "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
      "steps": "Stir into glass over ice, garnish and serve.",
      "ingredients": [
        {
          "description": "1 oz Gin"
        },
        {
          "description": "1 oz Campari"
        },
        {
          "description": "1 oz Sweet Vermouth"
        }
      ]
    }
  }
}
```

---

### Get Three Random API Drink

Example Query

```
query {
  threeRandomApiDrinks {
    id
    name
    imgUrl
  }
}
```

Example Response:

```JSON
{
  "data": {
    "threeRandomApiDrinks": [
      {
        "id": "178345",
        "name": "Hot Toddy",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/ggx0lv1613942306.jpg"
      },
      {
        "id": "17180",
        "name": "Aviation",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/trbplb1606855233.jpg"
      },
      {
        "id": "12107",
        "name": "Salty Dog",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/4vfge01504890216.jpg"
      }
    ]
  }
}
```

---

### Create a Drink / Save Drink to Database

Example Mutation with Reponse Returning All Available Fields:

Input JSON Drink Object:

```JavaScript
const newDrink = {
  "name": "Negroni",
  "steps": "Stir into glass over ice, garnish and serve.",
  "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
  "barId": 1,
  "ingredients": [
    {
      "description": "1 oz Gin"
    },
    {
      "description": "1 oz Campari"
    },
    {
      "description": "1 oz Sweet Vermouth"
    }
  ]
};
```

GraphQL Variables:

```JavaScript
const variables = {
  "input":{
    "drinkInput": newDrink
  }
}
```

GraphQL Mutation:

```
mutation($input: DrinkCreateInput!){
  drinkCreate(input: $input){
    drink{
      id
      name
      steps
      imgUrl
      ingredients{
        id
        description
      }
    }
  }
}
```

Example Response:

```JSON
{
  "data": {
    "drinkCreate": {
      "drink": {
        "id": "3",
        "name": "Negroni",
        "steps": "Stir into glass over ice, garnish and serve.",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
        "ingredients": [
          {
            "id": "5",
            "description": "1 oz Gin"
          },
          {
            "id": "6",
            "description": "1 oz Campari"
          },
          {
            "id": "7",
            "description": "1 oz Sweet Vermouth"
          }
        ]
      }
    }
  }
}
```

---

### Create Drink w/ Errors

**To Do**

---

### Update Existing Drink

**Notes:**

- The ID for the drink to be updated should not be passed as part of the drink object. Instead save it as a separate variable and pass it through the base level of the input GQL Variables. See the examples below.
- Ingredients can either be changed, deleted, or added. Ingredient with an ID passed and a `"_destroy": false"` attribute or no `"_destroy"` key will be updated. Ingredients with an ID and a `"_destroy": true` attribute will be deleted. Ingredients with no id or a null value for ID will create a new ingredient for the drink.

Example Input Object:

```JavaScript
const updatedDrinkId = 3

const updatedDrink = {
  "name": "Negroni Sbagliato",
  "steps": "Stir campari and sweet vermouth into glass over ice, top with proesecco, garnish and serve.",
  "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
  "ingredients": [
    {
      "id": "5",
      "description": "1 oz Gin"
      "_destroy": true
    },
    {
      "id": "6",
      "description": "1.5 oz Campari"
    },
    {
      "id": "7",
      "description": "1.5 oz Sweet Vermouth"
    },
    {
      "id": null,
      "description": "1.5 oz Prosecco"
    }
  ]
}
```

Example GQL Variables Object:

```JavaScript
{
  "input": {
    "id": udpatedDrinkId,
    "drinkInput": updatedDrink
  }
}
```

Example GQL Mutation:

```
mutation($input: DrinkUpdateInput!){
  drinkUpdate(input: $input){
    drink{
      id
      name
      steps
      imgUrl
      ingredients{
        id
        description
      }
    }
  }
}
```

Example Response:

```JSON
{
  "data":{
    "drinkUpdate": {
      "drink":{
        "id": "3",
        "name": "Negroni Sbagliato",
        "steps": "Stir campari and sweet vermouth into glass over ice, top with proesecco, garnish and serve.",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
        "ingredients": [
          {
            "id": "6",
            "description": "1.5 oz Campari"
          },
          {
            "id": "7",
            "description": "1.5 oz Sweet Vermouth"
          },
          {
            "id": "8",
            "description": "1.5 oz Prosecco"
          }
        ]
      }
    }
  }
}
```

---
### Delete a Drink

Example Query

```
mutation {
  deleteDrink(input: {
    id: 1
  }
  ){
    success
    errors
  }
}
```

Example Response:

```JSON
{
  "data": {
    "deleteDrink": {
      "errors":[],
      "success":true
    }
  }
}
```



### Get Bar Info

Example Query w/ Available Fields

```
query {
  bar(id: 1) {
    id
    name
    drinkCount
    drinks {
      id
      name
      imgUrl
    }
  }
}
```

Example Response

```JSON
{
  "data": {
    "bar": {
      "id": "1",
      "name": "Joe's Bar",
      "drinkCount": 5,
      "drinks": {
        "id": "1",
        "name": "Negroni",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg"
      },
      **etc...**
    }
  }
}
```

---

### Get User Info

Example Query w/ Available Fields

```
query {
  user(id: 1) {
    id
    name
    barCount
    bars{
      id
      name
      drinkCount
    }
  }
}
```

Example Response:

```JSON
"data": {
  "user": {
    "id": "1",
    "name": "Joe Schmoe",
    "barCount": 1,
    "bars":[
      {
        "id": "1",
        "name": "Joe's Bar",
        "drinkCount": 5
      }
    ]
  }
}
```

---
