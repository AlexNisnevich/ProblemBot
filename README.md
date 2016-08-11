# ProblemBot

A Slack bot that posts math problems from American math olympiads on request.

## Installation

```
bundle install
```

## Usage

Run:
```
SLACK_API_TOKEN=<your slack API token> ruby bot.rb
```

Then create a bot with the same token, add it to a Slack channel, and ask it something like "May I have a problem?" (to get a problem of random difficulty) or "May I have an easy/medium/hard/very hard problem?"
