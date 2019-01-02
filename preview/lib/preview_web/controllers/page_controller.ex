defmodule PreviewWeb.PageController do
  use PreviewWeb, :controller

  def index(conn, %{"feed_url" => feed_url}) do
    case Metalove.get_feed_url(feed_url) do
      {:ok, url} ->
        redirect(conn, to: "/#{url}")

      _ ->
        render(conn, "index.html", feed_url: feed_url)
    end
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
