FROM ruby

RUN apt-get update
RUN apt-get -qq update
RUN apt-get install -y nodejs npm

RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

RUN gem install rails

COPY . .

RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

# build image command
# docker build -t desiredName .

# run container command
# docker run -d --rm -p 3000 --name desiredName imageName

