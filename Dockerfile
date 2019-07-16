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
ENV TEMP_STORIES_API_KEY="your_api_key"
ENV REDIS_URL="redis://localhost:6379"
ENV SECRET_KEY_BASE="your_secret_key"

COPY . .

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
