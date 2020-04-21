# How to use Gogs with Docker on the Raspberry Pi

Gogs needs a database. Therefore I can recommend Postgres or SQLite.
When using Postgres you have to actively run a database server, while SQLite only uses a single database file and does not need further configuration. I personally use Postgres.

For using this service you don't have to change anything in the `docker-compose.yml`. Just start the service and navigate to `http://<your-server-ip>:10080`. There you will have to set up your service.

If you use Postgres as your Database the **Host** is `"postgresdb:5432"`, the **User** is `"postgres"`, the **Database** is called `"gogs"` and for the **Password** you have to use the one you specified in the `docker-compose.yml`.

Before changing the default **Application Settings** read the [Documentation](https://github.com/gogs/gogs/tree/master/docker#settings), because not everything can be changed. (Note: Don't forget to change the SSH port from 22 to 10022)

Important Notes:

- You have to use the `gogs/gogs-rpi` docker image for linux/arm architecture.
- It is not possible to use postgres with the specified volume mapping on a Windows Host, since the data folder needs special rights, which only work on Linux
