# Dixit game
-------------

Create a game called Dixit.

## Install instructions
1. Make sure you have Redis installed: `brew install redis`
1. Just run `bin/setup`
1. Add your information to `.env`
1. Run `gem install mailcatcher`

## Start instructions
1. Run `mailcatcher`
2. Just run `foreman start`

## Viewing received e-mails
When you've started mailcatcher, you go to: `127.0.0.1:1080` to see the mail flowing in!


[![Build Status](https://travis-ci.org/jvanbaarsen/dixit.svg?branch=master)](https://travis-ci.org/jvanbaarsen/dixit) [![Code Climate](https://codeclimate.com/github/jvanbaarsen/dixit.png)](https://codeclimate.com/github/jvanbaarsen/dixit)

## What has to be improved?

**Validations**
At this point there is no validation on the Storyteller part, or the part where players can select a picture.

**Test coverage**
The test coverage is OK at this point, most public model methods have tests, the game start flow is tested. But once the game is started, there are no integration tests.

**Photo selection**
It would be possible for pictures to be duplicates in one round. So a player can possible see the picture that the storyteller has selected.

**Finish a game**
At this point, games will go on forever.
