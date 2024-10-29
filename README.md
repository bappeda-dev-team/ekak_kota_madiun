# README
E-KaK is a proposal project management system based on officer performance goals implemented in Madiun City

This tools focused for Madiun City Organization planners to handling budget proposal plan
## Requirements:
- ruby on rails v 6.1
- ruby 3.0.1
- Postgresql 13
- NodeJS v 14
- Yarn 1.22
- redis (optional)

## install dependencies
- install backend deps with `bundle install`
- install frontend deps `yarn install`

## Database Preparation
- create database with `rails db:create`
- migrate database with `rails db:migrate`
- if having any problem disable online migration, go to `online_migration.rb` and uncomment this line `config.start_after`
- set default user with `rails db:seed`

Dev server:
``` sh
bin/rails s
```

## using tmux
Development server using overmind and tmux, to separate server, build process, and sidekiq

## Requirements:
- [overmind](https://github.com/DarthSim/overmind)
- tmux (for overmind)

edit .env.development file to setup database connection


Dev server:
``` sh
bin/dev
```

## view dev log

``` sh
overmind status
```

# Test suite
- spec using rspec 3.11.0
- run `rails spec:models`

# Services
- Background job: resque
- redis
- run `QUEUE=* rake resque:work`
