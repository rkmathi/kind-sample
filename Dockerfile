FROM ruby:2.7.1

ENV WORKSPACE /app
WORKDIR ${WORKSPACE}

COPY ./app/Gemfile  ${WORKSPACE}/
RUN /usr/local/bin/bundle install

COPY ./app/config.ru ${WORKSPACE}/

EXPOSE 9292
CMD ["/usr/local/bin/bundle", "exec", "rackup", "-p", "9292", "-o", "0.0.0.0"]
