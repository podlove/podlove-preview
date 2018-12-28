defmodule InstaloveWeb.PodcastController do
  use InstaloveWeb, :controller

  def podcast(conn, params) do
    "/" <> feed_url = conn.request_path
    render(conn, "podcast.html", feed_url: feed_url, params: params)
  end

  def get_feed_url(params = %{"feed_url" => feed_components}) do
    feed_components
  end
end
