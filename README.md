# Podlove Preview

Podlove preview consists of 2 mix projects:

  * [`metalove`][metalove] - Elixir application to fetch and cache podcast metadata from the internet.
  * [`preview`][preview] - Phoenix application to show a nice frontend for any podcast based on the publicly avaiable data fetched through metalove and using the [podlove web player][podlove-web-player] and [podlove subscribe button][podlove-subscribe-button] as interface to it.

## Getting started

To start your Phoenix server:

  1. Install Elixir dependencies with `mix deps.get`
  1. Install Node.js dependencies with `cd assets && npm install`
  1. Start server by `mix phx.server` or `iex -S mix phx.server` interactively

Now you can visit [`localhost:4040`](http://localhost:4040) from your browser.

## Running Tests

```
mix test
```

## License

This project is distributed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details


[metalove]: metalove
[preview]: metalove
[podlove-web-player]: https://github.com/podlove/podlove-web-player
[podlove-subscribe-button]: https://github.com/podlove/podlove-subscribe-button
