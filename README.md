# ProblemBot

A Slack bot that posts math problems from American math olympiads (AMC, AIME, USAMO) on request.

## Installation

```
bundle install
```

## Usage

Run:
```
SLACK_API_TOKEN=<your slack API token> ruby bot.rb
```

Create a bot with the same token, add it to a Slack channel.

You can now ask the bot for problems. by writing something like "May I have a problem?" (to get a problem of random difficulty) or "May I have an easy/medium/hard/very hard problem?"
