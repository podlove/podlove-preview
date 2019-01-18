defmodule PreviewWeb.PodcastController do
  use PreviewWeb, :controller

  def podcast(conn, _params) do
    "/podcast/" <> feed_url = conn.request_path

    case Metalove.get_podcast(feed_url) do
      nil ->
        redirect(conn, to: Routes.page_path(conn, :index, feed_url: feed_url))

      podcast ->
        feed = Metalove.PodcastFeed.get_by_feed_url(podcast.main_feed_url)

        episodes =
          feed.episodes
          |> Enum.map(&Metalove.Episode.get_by_episode_id/1)

        all_enclosures = Metalove.Episode.all_enclosures(hd(episodes))

        render(conn, "podcast.html",
          podcast: feed,
          episodes: episodes,
          all_enclosures: all_enclosures,
          inspect: %{feed: feed, podcast: podcast}
        )
    end
  end

  require Logger

  def playerdata(conn, %{"feed" => feed_url, "guid" => episode_guid}) do
    Logger.debug("feed: #{feed_url} guid: #{episode_guid}")

    {episode, feed_url} =
      case Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}) do
        nil ->
          feed_url = Metalove.get_podcast(feed_url).main_feed_url
          {Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}), feed_url}

        episode ->
          {episode, feed_url}
      end

    feed = Metalove.PodcastFeed.get_by_feed_url(feed_url)

    all_enclosures = Metalove.Episode.all_enclosures(episode)

    conn
    |> render("playerdata.json", feed: feed, episode: episode, all_enclosures: all_enclosures)
  end

  def chapter_image(conn, %{
        "feed" => feed_url,
        "guid" => episode_guid,
        "chapter_index" => chapter_index
      }) do
    episode =
      case Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}) do
        nil ->
          feed_url = Metalove.get_podcast(feed_url).main_feed_url
          {Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}), feed_url}

        episode ->
          episode
      end

    image =
      episode.enclosure.metadata[:chapters]
      |> Enum.at(String.to_integer(chapter_index))
      |> Map.get(:image)

    Logger.info("Chapter image: #{inspect(image, pretty: true)}")

    conn
    |> put_resp_content_type(image[:type])
    |> send_resp(:ok, image[:data])
  end

  def episode_image(conn, %{"feed" => feed_url, "guid" => episode_guid}) do
    episode =
      case Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}) do
        nil ->
          feed_url = Metalove.get_podcast(feed_url).main_feed_url
          {Metalove.Episode.get_by_episode_id({:episode, feed_url, episode_guid}), feed_url}

        episode ->
          episode
      end

    case episode.enclosure.metadata[:cover_art] do
      image when is_map(image) ->
        Logger.info("Chapter image: #{inspect(image, pretty: true)}")

        conn
        |> put_resp_content_type(image[:type])
        |> send_resp(:ok, image[:data])

      _ ->
        redirect_url =
          episode.image_url || Metalove.PodcastFeed.get_by_feed_url(episode.feed_url).image_url ||
            Routes.static_path(conn, "/images/default-cover-template.svg")

        conn
        |> put_status(:temporary_redirect)
        |> redirect(external: redirect_url)
    end
  end
end
