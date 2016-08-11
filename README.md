# ProblemBot

ProblemBot is a bot for Slack or Discord that posts math problems from American math olympiads (AMC, AIME, USAMO) on request.

## Installation

```
bundle install
```

## Usage

### Slack

First create a bot and add it to a Slack channel.

Run:
```
SLACK_API_TOKEN=<your bot's slack API token> ruby bot.rb
```

You can now ask the bot for problems by writing something like "May I have a problem?" _(to get a problem of random difficulty)_ or "May I have an easy/medium/hard/very hard problem?"

### Discord

First create a bot application and add it to a Discord channel.

Run:
```
DISCORD_APP_ID=<your bot's application ID> DISCORD_API_TOKEN=<your bot's API token> ruby bot.rb
```

You can now ask the bot for problems by writing something like "May I have a problem?" _(to get a problem of random difficulty)_ or "May I have an easy/medium/hard/very hard problem?"