# Docker compose

There are a total of 7 microservices that need to be containerized

- Users service - Django
- User management service (composite service) - Flask
- Orders service - Flask
- Order management service (composite service) - Flask
- Payments service - Express.js
- Bidding service - Flask
- Telegram service - Flask

In addition, we also have images for MySQL database, RabbitMQ message broker and Nginx API gateway.

For our user interface, which is a React app, we will also dockerise it.

## File directory

- api-gateway
- infrastructure
- services
  - ...
  - ...
- user-interface
- dev.env
- docker-compose.yml
- dump.sql



## Spinning up containers
!! Ensure that docker is installed in the system

Use the following command to spin up all the containers:

```bash
docker compose -f docker-compose.yml up --build
```

To stop the containers and removes containers, networks, volumes, and images created by up:

```bash
docker compose -f docker-compose.yml down
```

To stop the container without destroying any volumes and images created, simply use Ctrl-C

## Individual port mapping

- users          : 8000
- users-mgmt     : 5000
- telegram       : 5001
- payments.      : 3001
- user-interface : 3000
- orders         : 5002
- order-mgmt     : 5003
- bidding        : 5077
- api-gateway    : 8080

## Nginx mapping
- users      : localhost:8080/v1/users
- users-mgmt : localhost:8080/v1/user-mgmt
- telegram   : localhost:8080/v1/send
- payments.  : localhost:8080/v1/payments
- orders     : localhost:8080/v1/orders, localhost:8080/v1/order
- order-mgmt : localhost:8080/v1/order-mgmt
- bidding    : localhost:8080/v1/bids
