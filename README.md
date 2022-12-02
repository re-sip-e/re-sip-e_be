# re•sip•e BE

![ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white) ![ror](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![GraphQL](https://img.shields.io/badge/-GraphQL-E10098?style=for-the-badge&logo=graphql&logoColor=white)

---

## Description:

## GraphQL Queries

GraphQL Endpoint URL: `https://re-sip-e-be.fly.dev/graphql`

---

### Get a bar's drinks

Example Query:

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
