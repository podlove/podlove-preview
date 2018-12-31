defmodule InstaloveWeb.PodcastController do
  use InstaloveWeb, :controller

  def podcast(conn, params) do
    "/" <> feed_url = conn.request_path
    podcast = Metalove.Podcast.new(feed_url)

    feed = hd(podcast.feeds)

    render(conn, "podcast.html",
      podcast: feed,
      inspect: podcast
    )
  end
end
