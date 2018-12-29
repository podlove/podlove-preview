defmodule Instalove.Metalove.Podcast do
  alias Instalove.Metalove

  defstruct initial_url: nil,
            feeds: []

  def new(url) do
    %__MODULE__{initial_url: url, feeds: [Metalove.PodcastFeed.new(url)]}
  end
end
