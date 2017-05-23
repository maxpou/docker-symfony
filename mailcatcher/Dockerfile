FROM ruby:2.2.3

EXPOSE 1025 1080
RUN gem install mailcatcher -v 0.5.12

CMD mailcatcher -f --http-ip=0.0.0.0 --smtp-ip=0.0.0.0
