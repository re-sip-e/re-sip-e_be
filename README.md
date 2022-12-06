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
    createdAt
    updatedAt
    bar {
      id
      name
    }
    ingredients {
      id
      name
      quantity
      createdAt
      updatedAt
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
        "createdAt": "2022-12-02T01:46:06Z",
        "updatedAt": "2022-12-02T01:46:06Z",
        "ingredients": [
          {
            "id": "5",
            "name": "Gin",
            "quantity": "1 oz",
            "createdAt": "2022-12-02T01:46:06Z",
            "updatedAt": "2022-12-02T01:46:06Z",
          },
          {
            "id": "8",
            "name": "Campari",
            "quantity": "1 oz",
            "createdAt": "2022-12-02T01:46:06Z",
            "updatedAt": "2022-12-02T01:46:06Z",
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
    createdAt
    updatedAt
    bar {
      id
      name
    }
    ingredients {
      name
      quantity
      createdAt
      updatedAt
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
      "createdAt": "2022-12-02T03:21:12Z",
      "updatedAt": "2022-12-02T03:21:12Z",
      "ingredients": [
        {
          "name": "Gin",
          "quantity": "1 oz",
          "createdAt": "2022-12-02T03:22:28Z",
          "updatedAt": "2022-12-02T03:22:28Z"
        },
        {
          "name": "Campari",
          "quantity": "1 oz",
          "createdAt": "2022-12-02T03:22:44Z",
          "updatedAt": "2022-12-02T03:22:44Z"
        },
        {
          "name": "Sweet Vermouth",
          "quantity": "1 oz",
          "createdAt": "2022-12-02T03:22:57Z",
          "updatedAt": "2022-12-02T03:22:57Z"
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
      name
      quantity
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
              "name": "Gin",
              "quantity": "1 oz"
            },
            {
              "name": "Campari",
              "quantity": "1 oz"
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
      name
      quantity
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
          "name": "Gin",
          "quantity": "1 oz"
        },
        {
          "name": "Campari",
          "quantity": "1 oz"
        },
        {
          "name": "Sweet Vermouth",
          "quantity": "1 oz"
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

```
mutation {
  createDrink(input:{
    name:"Negroni"
    imgUrl:"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg"
    steps:"Stir into glass over ice, garnish and serve."
    barId:1
    ingredients:[
      {
        name:"Gin"
        quantity:"1 oz"
      }
      {
        name:"Campari"
        quantity:"1 oz"
      }
      {
        name:"Sweet Vermouth"
        quantity:"1 oz"
      }
    ]
  }){
    drink{
      id
      name
      steps
      imgUrl
      createdAt
      updatedAt
      ingredients{
        name
        id
        quantity
        createdAt
        updatedAt
      }
    }
    errors
  }
}
```

Example Response:

```JSON
{
  "data": {
    "createDrink": {
      "drink": {
        "id": "3",
        "name": "Negroni",
        "steps": "Stir into glass over ice, garnish and serve.",
        "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
        "createdAt": "2022-12-03T20:44:25Z",
        "updatedAt": "2022-12-03T20:44:25Z",
        "ingredients": [
          {
            "name": "Gin",
            "id": "5",
            "quantity": "1 oz",
            "createdAt": "2022-12-03T20:44:25Z",
            "updatedAt": "2022-12-03T20:44:25Z"
          },
          {
            "name": "Campari",
            "id": "6",
            "quantity": "1 oz",
            "createdAt": "2022-12-03T20:44:25Z",
            "updatedAt": "2022-12-03T20:44:25Z"
          },
          {
            "name": "Sweet Vermouth",
            "id": "7",
            "quantity": "1 oz",
            "createdAt": "2022-12-03T20:44:25Z",
            "updatedAt": "2022-12-03T20:44:25Z"
          }
        ]
      },
      "errors": []
    }
  }
}
```

---

### Create Drink w/ Errors

If a drink is created and required fields are missing, validation errors will be generated. Drinks and ingredients are required to have names. A drink also needs a barId to be created.

Example Mutation w/ Validation Errors:

```
muation {
  createDrink(input:{
    name:""
    imgUrl:"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg"
    steps:"Shake it up and strin."
    ingredients: [
      {
        name:"Whiskey"
        quantity: "1 oz"
      }
      {
        quantity: "2 tsp"
      }
    ]
  }) {
    drink {
      name
      imgUrl
    }
    errors
  }
}
```

Example Response:

```JSON
{
  "data": {
    "createDrink": {
      "drink": null,
      "errors": [
        "Ingredients is invalid",
        "Bar must exist",
        "Name can't be blank"
      ]
    }
  }
}
```

---

### Update Existing Drink

**Notes:**

- If ingredients are being updated all ingredients in the drink must be included in the ingredients attribute. This includes any new, updated, or already existing ingredients.
- The id provided is used to find the drink to be updated. The id itself cannot be updated.

Example Update Mutation:

```
mutation {
  updateDrink(input:{
    id: 3
    name: "Negroni Sbagliato"
    imgUrl: "https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,c_fill,g_center,w_730,h_913/k%2FPhoto%2FRecipes%2F2021-11-Negroni-Sbagliato%2F211025-PAMU-THEKITCHN-0085"
    steps: "Mix the campari and sweet vermouth in a glass with ice and top with prosecco."
    ingredients: [
      {
        name: "Prosecco"
        quantity: "1 oz"
      }
      {
        name: "Campari"
        quantity: "1 oz"
      }
      {
        name: "Sweet Vermouth"
        quantity: "1 oz"
      }
    ]
  }){
    drink {
      id
      name
      imgUrl
      steps
      ingredients{
        name
        quantity
      }
    }
    errors
  }
}
```

Example Response:

```JSON
{
  "data": {
    "updateDrink": {
      "drink": {
        "id": "3",
        "name": "Negroni Sbagliato",
        "imgUrl": "https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,c_fill,g_center,w_730,h_913/k%2FPhoto%2FRecipes%2F2021-11-Negroni-Sbagliato%2F211025-PAMU-THEKITCHN-0085",
        "steps": "Mix the campari and sweet vermouth in a glass with ice and top with prosecco.",
        "ingredients": [
          {
            "name": "Prosecco",
            "quantity": "1 oz"
          }
          {
            "name": "Campari",
            "quantity": "1 oz"
          }
          {
            "name": "Sweet Vermouth",
            "quantity": "1 oz"
          }
        ]
      },
      "errors":[]
    }
  }
}
```

---

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
