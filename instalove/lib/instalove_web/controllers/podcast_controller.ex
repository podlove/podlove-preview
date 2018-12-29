defmodule InstaloveWeb.PodcastController do
  use InstaloveWeb, :controller

  alias Instalove.Metalove

  def podcast(conn, params) do
    "/" <> feed_url = conn.request_path
    feed = Metalove.Fetcher.fetch(feed_url)

    render(conn, "podcast.html",
      feed_url: feed_url,
      inspect: %{feed: feed, conn: conn, params: params}
    )
  end
end
