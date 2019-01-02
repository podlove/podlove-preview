defmodule InstaloveWeb.PodcastView do
  use InstaloveWeb, :view

  def episode_div_id(%Metalove.Episode{guid: guid}) do
    for <<c::utf8 <- guid>>, (c > ?0 and c < ?9) or (c > ?a and c < ?z), into: "_", do: <<c>>
  end

  def player_div(episode) do
    div_id = episode_div_id(episode)

    config = """
    {
      title: #{Jason.encode!(episode.title)},
      subtitle: #{Jason.encode!(episode.subtitle)},
      audio: [{
          url: #{Jason.encode!(episode.enclosure.url)},
          mimeType: #{Jason.encode!(Metalove.Enclosure.mime_type(episode.enclosure))},
          size: #{Jason.encode!(episode.enclosure.size)},
          title: 'Audio'
        }]
    }
    """

    [tag(:div, id: div_id), content_tag(:script, raw("podlovePlayer('##{div_id}', #{config})"))]
  end
end
