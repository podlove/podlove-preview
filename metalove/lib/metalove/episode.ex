defmodule Metalove.Episode do
  alias Metalove.Enclosure

  # <title>Shake Shake Shake Your Spices</title>
  # <itunes:author>John Doe</itunes:author>
  # <itunes:subtitle>A short primer on table spices</itunes:subtitle>
  # <itunes:summary><![CDATA[This week we talk about
  #     <a href="https://itunes/apple.com/us/book/antique-trader-salt-pepper/id429691295?mt=11">salt and pepper shakers</a>
  #     , comparing and contrasting pour rates, construction materials, and overall aesthetics. Come and join the party!]]></itunes:summary>
  # <itunes:image href="http://example.com/podcasts/everything/AllAboutEverything/Episode1.jpg"/>
  # <enclosure length="8727310" type="audio/x-m4a" url="http://example.com/podcasts/everything/AllAboutEverythingEpisode3.m4a"/>
  # <guid>http://example.com/podcasts/archive/aae20140615.m4a</guid>
  # <pubDate>Tue, 08 Mar 2016 12:00:00 GMT</pubDate>
  # <itunes:duration>07:04</itunes:duration>
  # <itunes:explicit>no</itunes:explicit>

  @derive Jason.Encoder
  defstruct feed_url: nil,
            guid: nil,
            author: nil,
            title: nil,
            subtitle: nil,
            summary: nil,
            description: nil,
            content_encoded: nil,
            image_url: nil,
            duration: nil,
            enclosure: nil,
            link: nil,
            contributors: [],
            chapters: [],
            pub_date: nil,
            season: nil,
            episode: nil

  def get_by_episode_id(episode_id) do
    case Metalove.Repository.get(episode_id) do
      {:found, result} -> result
      _ -> nil
    end
  end

  def store(%__MODULE__{} = episode) do
    Metalove.Repository.put_episode(episode)
  end

  def new(map, feed_url) when is_map(map) do
    %__MODULE__{
      feed_url: feed_url,
      author: map[:itunes_author],
      title: map[:title],
      guid: map[:guid],
      link: map[:link],
      description: map[:description],
      content_encoded: map[:content_encoded],
      duration: map[:duration],
      summary: map[:itunes_summary],
      subtitle: map[:itunes_subtitle],
      enclosure: %Enclosure{
        url: map[:enclosure_url],
        type: map[:enclosure_type] || Enclosure.infer_mime_type(map[:enclosure_url]),
        size: map[:enclosure_length]
      },
      pub_date: map[:publication_date],
      image_url: map[:image],
      contributors: map[:contributors],
      chapters: map[:chapters],
      season: map[:itunes_season],
      episode: map[:itunes_episode]
    }
  end

  def all_enclosures(%__MODULE__{feed_url: feed_url, guid: guid, enclosure: enclosure}) do
    Metalove.Podcast.get_by_feed_url(feed_url).feed_urls
    |> Enum.reduce([enclosure], fn
      ^feed_url, acc ->
        acc

      url, acc ->
        case __MODULE__.get_by_episode_id({:episode, url, guid}) do
          %__MODULE__{} = other_format -> [other_format.enclosure | acc]
          _ -> acc
        end
    end)
    |> Enum.reverse()
  end
end
