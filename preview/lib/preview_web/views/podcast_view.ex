defmodule PreviewWeb.PodcastView do
  use PreviewWeb, :view

  def episode_div_id(%Metalove.Episode{guid: guid}) do
    for <<c::utf8 <- guid>>, (c > ?0 and c < ?9) or (c > ?a and c < ?z), into: "_", do: <<c>>
  end

  def player_data_url(episode) do
    %URI{
      path: "/playerdata.json",
      query: URI.encode_query(%{feed: episode.feed_url, guid: episode.guid})
    }
    |> to_string()
  end

  def player_div(feed, episode, all_enclosures) do
    config =
      Jason.encode!(
        render("playerdata.json", feed: feed, episode: episode, all_enclosures: all_enclosures)
      )

    content_tag(:div, "", id: "player_wrapper", "data-config": config)
  end

  def play_button(episode) do
    [
      content_tag(:button, "Play",
        class: "start-player-btn",
        "data-config-url": player_data_url(episode)
      )
    ]
  end

  def render("playerdata.json", %{feed: feed, episode: episode, all_enclosures: all_enclosures}) do
    %{
      show: %{
        title: feed.title,
        subtitle: feed.subtitle,
        summary: feed.summary,
        link: feed.link,
        poster: feed.image_url
      },
      title: episode.title,
      subtitle: episode.subtitle,
      duration: episode.duration,
      summary: episode.description,
      audio:
        all_enclosures
        |> Enum.map(fn enclosure ->
          %{
            url: enclosure.url,
            mimeType: enclosure.type,
            size: enclosure.size,
            title: "Audio #{Path.extname(URI.parse(enclosure.url).path)}"
          }
        end),
      chapters: episode.chapters,
      poster: episode.image_url || feed.image_url,
      contributors: episode.contributors,
      link: episode.link,
      publicationDate: pubdate(episode.pub_date)
    }
  end

  def pubdate(datetime) do
    Timex.format!(datetime, "%FT%T%:z", :strftime)
  end
end
