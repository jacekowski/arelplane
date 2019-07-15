FROM ruby:2.6.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash 
RUN apt-get install -y nodejs

EXPOSE 3000
VOLUME ["/data"]

ENV DATABASE_URL="postgres://myuser:mypass@localhost/somedatabase"
ENV MAPSNAP_ROOT_URL="http://localhost:8080" MAP_SNAP_API_KEY="your_api_key"
ENV SMTP_HOST="test.com" SMTP_PORT="587" SMTP_DOMAIN="test.com" SMTP_USER="test" SMTP_PASS="pass"
ENV RAILS_LOG_TO_STDOUT="1" RAILS_ENV="production"
ENV TEMP_STORIES_API_KEY="70e5536d752349a0dc43f07d73d07e9b"
ENV REDIS_URL="redis://localhost"
ENV SECRET_KEY_BASE="c86a09ddf55d2291fb5b8c65a818e9cdb140d18778a3642e1ae43f5104fa9597030eb286903c441a187d81800cd14d2c2b29e9dd99479b1b9646b09120ebc11c"

COPY . .

COPY entrypoint.sh /usr/local/bin/

#CMD ["rails", "server", "-b", "0.0.0.0"]
ENTRYPOINT ["entrypoint.sh"]
