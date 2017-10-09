## Bearden API

Bearden implements a GraphQL API.

### Authentication

Trusted apps may use the Bearden API using [JWT](https://jwt.io/) authentication. You will need to obtain a JWT for Bearden from a Gravity console on Staging.

```
~/gravity $  AWS_USER=... AWS_ID=... AWS_SECRET=... rake ow:console[staging]
Starting remote console... (use Ctrl-D to exit cleanly)
Loading staging environment (Rails 5.0.3)
gravity:staging>
```

```ruby
app = ClientApplication.where(name: 'Bearden').first
expires_in = 42.years.from_now
token = ApplicationTrust.create_for_token_authentication(app, expires_in: expires_in)
puts token
```

Save your token in your `.env` file if needed. Once in possession of the token, send it in your requests to Bearden:

```ruby
headers = { 'Authorization' => "Bearer #{token}" }
```

### IDE

Use [GraphQL IDE](https://github.com/andev-software/graphql-ide/releases). Create a new project and point the Environment to `http://localhost:5000/api/graphql` with an `Authorization` header value of `Bearer <token>`.

![](api/ide.png)

