defmodule PreviewWeb.PodcastView do
  use PreviewWeb, :view

  def episode_div_id(%Metalove.Episode{guid: guid}) do
    for <<c::utf8 <- guid>>, (c > ?0 and c < ?9) or (c > ?a and c < ?z), into: "_", do: <<c>>
  end

  def player_chapter_image_url(episode, chapter_index) do
    %URI{
      path: "/chapter_image",
      query:
        URI.encode_query(%{
          feed: episode.feed_url,
          guid: episode.guid,
          chapter_index: chapter_index
        })
    }
    |> to_string()
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
      chapters: chapters(episode.chapters, episode),
      poster: episode.image_url || feed.image_url,
      contributors: episode.contributors,
      link: episode.link,
      publicationDate: pubdate(episode.pub_date)
    }
  end

  require Logger

  defp chapters([_head | _] = list, _), do: list

  defp chapters(_, %Metalove.Episode{} = episode) do
    case episode.enclosure.metadata do
      nil -> nil
      metadata -> metadata[:chapters]
    end
    |> case do
      nil ->
        nil

      list ->
        list
        |> Enum.with_index()
        |> Enum.map(fn {entry, index} ->
          entry
          |> Enum.reduce(
            %{},
            fn
              {key, value}, acc when key in [:title, :href, :start] ->
                Map.put(acc, key, value)

              {:image, _image_data}, acc ->
                Map.put(acc, :image_url, player_chapter_image_url(episode, index))
            end
          )
        end)
    end
  end

  def pubdate(datetime) do
    Timex.format!(datetime, "%FT%T%:z", :strftime)
  end
end
