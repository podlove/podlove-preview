defmodule InstaloveWeb.PodcastController do
  use InstaloveWeb, :controller

  alias Instalove.Metalove

  def podcast(conn, params) do
    "/" <> feed_url = conn.request_path
    podcast = Metalove.Podcast.new(feed_url)

    render(conn, "podcast.html",
      feed_url: feed_url,
      inspect: podcast
    )
  end
end
