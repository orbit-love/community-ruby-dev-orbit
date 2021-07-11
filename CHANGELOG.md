## [0.0.1] - 2021-03-06

- Initial release

## [0.0.2] - 2021-03-09

- Add a CLI to the gem to run the gem's operations

## [0.0.3] - 2021-03-09

- Bug fix for the CLI functionality, now operational

## [0.0.4] - 2021-03-10

- Bug fix for stripping the HTML from the DEV blog post comment body

## [0.0.5] - 2021-03-10

- Print out Orbit API response

## [0.0.6] - 2021-03-10

- Fix misnamed env var in client instantiation
- Add a sample `.env` file

## [0.0.7] - 2021-03-12

- Check for valid JSON from API response before continuing

## [0.0.8] - 2021-03-16

- Early return if there are no new comments

## [0.0.9] - 2021-04-11

- Add check for new DEV followers functionality

## [0.0.10] - 2021-04-23

- Fix filter for DEV comments
## [0.1.0] - 2021-05-06

- Correct CLI `CheckFollowers` action
- Update gem specifications
## [0.4.1] - 2021-07-01

- Remove debugging output from processing DEV comments
## [0.5.0] - 2021-07-08

- Add pagination for all DEV interactions
- Dynamically filter what to send to Orbit based on last item of that type in the Orbit workspace
## [0.5.1] - 2021-07-11

- Fix URL query params path for organization comments