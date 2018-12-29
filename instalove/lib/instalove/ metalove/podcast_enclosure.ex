defmodule Instalove.Metalove.PodcastEnclosure do
  # <enclosure length="8727310" type="audio/x-m4a" url="http://example.com/podcasts/everything/AllAboutEverythingEpisode3.m4a"/>

  defstruct url: nil,
            type: nil,
            length: nil
end
