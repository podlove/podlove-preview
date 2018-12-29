defmodule InstaloveWeb.PodcastController do
  use InstaloveWeb, :controller

  alias Instalove.Metalove

  def podcast(conn, params) do
    "/" <> feed_url = conn.request_path
    feed = Metalove.Fetcher.fetch(feed_url)
    render(conn, "podcast.html", feed_url: feed_url, params: params, feed: feed)
  end

  def get_feed_url(params = %{"feed_url" => feed_components}) do
    feed_components
  end
end
