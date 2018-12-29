defmodule Instalove.Metalove.PodcastFeed do
  alias Instalove.Metalove.Fetcher
  alias Instalove.Metalove.PodcastFeedParser

  defstruct feed_url: nil,
            title: nil,
            link: nil,
            language: nil,
            subtitle: nil,
            author: nil,
            summary: nil,
            description: nil,
            image_url: nil,
            categories: nil,
            copyright: nil,
            episodes: nil

  def new(feed_url, nil) do
    {:ok, body, headers} = Fetcher.fetch(feed_url)
    new(feed_url, body)
  end

  def new(feed_url, content \\ nil) do
    %__MODULE__{
      parse_content(content)
      | feed_url: feed_url
    }
  end

  def parse_content(content) do
    {:ok, cast, episodes} = PodcastFeedParser.parse(content)

    %__MODULE__{
      title: cast[:title],
      link: cast[:link],
      language: cast[:language],
      copyright: cast[:copyright],
      author: cast[:itunes_author],
      description: cast[:description],
      summary: cast[:itunes_summary],
      subtitle: cast[:itunes_subtitle],
      image_url: cast[:image]
    }
  end
end
