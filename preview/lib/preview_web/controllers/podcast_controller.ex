defmodule PreviewWeb.PodcastController do
  use PreviewWeb, :controller

  def podcast(conn, _params) do
    "/" <> feed_url = conn.request_path
    podcast = Metalove.get_podcast(feed_url)

    feed = Metalove.PodcastFeed.get_by_feed_url(podcast.main_feed_url)

    episodes =
      feed.episodes
      |> Enum.map(&Metalove.Episode.get_by_episode_id/1)

    render(conn, "podcast.html",
      podcast: feed,
      episodes: episodes,
      inspect: %{feed: feed, podcast: podcast}
    )
  end

  require Logger

  def playerdata(conn, %{"feed" => feed_url, "guid" => episode_guid}) do
    Logger.info("feed: #{feed_url} guid: #{episode_guid}")

    {episode, feed_url} =
      case Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}) do
        nil ->
          feed_url = Metalove.get_podcast(feed_url).main_feed_url
          {Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}), feed_url}

        episode ->
          {episode, feed_url}
      end

    feed = Metalove.PodcastFeed.get_by_feed_url(feed_url)

    conn
    |> render("playerdata.json", feed: feed, episode: episode)
  end
end
