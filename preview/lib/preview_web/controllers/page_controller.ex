defmodule PreviewWeb.PageController do
  use PreviewWeb, :controller

  # require Logger

  def index(conn, %{"feed_url" => feed_url}) do
    with {:ok, url} <- validate_url(feed_url),
         {:ok, url} <- Metalove.get_feed_url(url, follow_first: true),
         podcast when not is_nil(podcast) <- Metalove.get_podcast(url) do
      redirect(conn, to: "/#{podcast.id}")
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid URL")
        |> render("index.html", feed_url: feed_url)
    end

    case Metalove.get_feed_url(feed_url) do
      {:ok, url} ->
        redirect(conn, to: "/#{url}")

      _ ->
        render(conn, "index.html", feed_url: feed_url)
    end
  end

  def index(conn, _params) do
    #    Logger.debug("#{inspect(conn, pretty: true)}")
    render(conn, "index.html")
  end

  defp validate_url(url) do
    url = String.trim(url)

    cond do
      url =~ ~r/\s/ -> {:error, :disallowed_characters}
      true -> {:ok, url}
    end
  end
end
