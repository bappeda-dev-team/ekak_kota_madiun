# README
E-KaK is a proposal project management system based on officer performance goals implemented in Madiun City

E-KaK make proposal based on the officer performance plan, and make budget proposal plan

E-KaK outputing three proposal, RAK, KAK and Gender Budget Statement

This tools focused for Madiun City Organization planners to handling budget proposal plan
## Requirements:
- ruby on rails v 6.1
- ruby 3.0.1
- Postgresql 13
- NodeJS v 14
- Yarn 1.22
- redis
- [overmind](https://github.com/DarthSim/overmind)
- tmux (for overmind)

## run dev server
``` sh
bin/dev
```

## view dev log

``` sh
overmind status
```


## deps to install
- run    `bundle install`
- run `yarn install`


## Database Preparation
- run `rails db:create`
- run `rails db:migrate`
- if having any problem disable online migration, go to `online_migration.rb` and uncomment this line `config.start_after`
- run `rails db:seed`

# Test suite
- spec using rspec 3.11.0
- run `rails spec:models`

# Services
- Background job: resque
- redis
- run `QUEUE=* rake resque:work`
