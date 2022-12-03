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
    ingredients {
      id
      name
      quantity
      unit
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
            "quantity": 1.0,
            "unit": "oz",
            "createdAt": "2022-12-02T01:46:06Z",
            "updatedAt": "2022-12-02T01:46:06Z",
          },
          {
            "id": "8",
            "name": "Campari",
            "quantity": 1.0,
            "unit": "oz",
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
    img_url
    steps
    createdAt
    updatedAt
    ingredients {
      name
      quantity
      unit
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
          "quantity": 1.0,
          "unit": "oz",
          "createdAt": "2022-12-02T03:22:28Z",
          "updatedAt": "2022-12-02T03:22:28Z"
        },
        {
          "name": "Campari",
          "quantity": 1.0,
          "unit": "oz",
          "createdAt": "2022-12-02T03:22:44Z",
          "updatedAt": "2022-12-02T03:22:44Z"
        },
        {
          "name": "Sweet Vermouth",
          "quantity": 1.0,
          "unit": "oz",
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
    img_url
    steps
    ingredients {
      name
      quantity
      unit
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
              "quantity": 1.0,
              "unit": "oz"
            },
            {
              "name": "Campari",
              "quantity": 1.0,
              "unit": "oz"
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
      unit
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
          "quantity": 1.0,
          "unit": "oz"
        },
        {
          "name": "Campari",
          "quantity": 1.0,
          "unit": "oz"
        },
        {
          "name": "Sweet Vermouth",
          "quantity": 1.0,
          "unit": "oz"
        }
      ]
    }
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
        quantity:1.0
        unit:"oz"
      }
      {
        name:"Campari"
        quantity:1.0
        unit:"oz"
      }
      {
        name:"Sweet Vermouth"
        quantity:1.0
        unit:"oz"
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
        unit
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
            "quantity": 1.0,
            "unit": "oz",
            "createdAt": "2022-12-03T20:44:25Z",
            "updatedAt": "2022-12-03T20:44:25Z"
          },
          {
            "name": "Campari",
            "id": "6",
            "quantity": 1.0,
            "unit": "oz",
            "createdAt": "2022-12-03T20:44:25Z",
            "updatedAt": "2022-12-03T20:44:25Z"
          },
          {
            "name": "Sweet Vermouth",
            "id": "7",
            "quantity": 1.0,
            "unit": "oz",
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

### Update Existing Drink

**TO DO**

---


