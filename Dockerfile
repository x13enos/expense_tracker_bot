FROM ruby:2.4-alpine

ENV PATH /root/.yarn/bin:$PATH

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh build-base nodejs tzdata postgresql-dev

RUN apk update \
  && apk add curl bash binutils tar gnupg \
  && rm -rf /var/cache/apk/* \
  && /bin/bash \
  && touch ~/.bashrc \
  && curl -o- -L https://yarnpkg.com/install.sh | bash \
  && apk del curl tar binutils

ENV RAILS_ROOT /var/www/expenses_tracker_bot
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler && bundle install

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install

COPY . .

RUN bundle exec rake assets:precompile
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
