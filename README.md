# re•sip•e BE

![ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white) ![ror](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![GraphQL](https://img.shields.io/badge/-GraphQL-E10098?style=for-the-badge&logo=graphql&logoColor=white)

---

## Description:

## GraphQL Queries

GraphQL Endpoint URL: `https://re-sip-e-be.fly.dev/graphql`

---

### Get a Bar's Drinks

Example Query w/ All Available Fields:

```
query {
  drinks(barId:1) {
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
          (...etc)
        ]
      },
      (...etc)
    ]
  }
}
```

### Get Search Result Drinks
