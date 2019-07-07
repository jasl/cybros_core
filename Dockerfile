# ARG: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG BUILDER_IMAGE_TAG
FROM $BUILDER_IMAGE_TAG as builder

# Define basic environment variables
ENV NODE_ENV production
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

# Copy source code
COPY . /app/

# Build front-end assets
RUN bundle exec rails webpacker:verify_install
RUN bundle exec rails webpacker:compile

RUN rm -rf node_modules

FROM ruby:2.6-alpine as deploy

RUN apk add --no-cache \
  ca-certificates \
  curl \
  tzdata \
  gnupg1 \
  graphicsmagick \
  libsodium-dev \
  nodejs \
  postgresql-dev \
  bash

# Define basic environment variables
ENV NODE_ENV production
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
# Defined for future testing
ENV RAILS_SERVE_STATIC_FILES true

WORKDIR /var/www/app

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/ /var/www/app/

# Define entrypoint
COPY ./bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["./bin/entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
