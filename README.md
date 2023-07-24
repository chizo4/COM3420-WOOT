
# COM3420: TEAM 22 - PROJECT REPO

## SETTING UP THE APP ON YOUR MACHINE

After cloning the repo, make sure to execute the following commands:

- Install dependencies:

```cp config/database-sample.yml config/database.yml```

```bundle install```

```yarn install```

- Set up the database:

```bundle exec rails db:create```

```bundle exec rails db:migrate```

```bundle exec rails db:seed```

## RUNNING THE APP

- Start the Rails server:
```bundle exec rails s```

- In separate terminal window, start the webpack dev server:
```bin/webpacker-dev-server```

- Open ```http://127.0.0.1:3000/``` in your browser to access the app.

- Press ```CTRL+C``` to stop the app.

## ESSENTIALS BEFORE PUSHING/OPENING PR

Remember to perform following tasks before you ```git push``` or open your Pull Request.

Make sure you are in the root of the project directory.

- Run HAML linter (if any issues appear, you have to fix them manually):
```bundle exec haml-lint```

- Run Rubocop linter:
```bundle exec rubocop```

- If there are any issues, they can be fixed running:
```bundle exec rubocop -A```

- Run RSpec tests:
```bundle exec rspec spec```

## DEPLOYMENT INSTRUCTIONS

- After the first deployment (which was slightly more complex), all you need to deploy a new release is to run the following command:
```bundle exec epi_deploy release -d demo```

- The website can be accessed following the link:
[woot-demo](https://team22.demo4.hut.shefcompsci.org.uk/)
