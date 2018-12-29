defmodule Instalove.Metalove.Podcast do
  defstruct initial_url: nil,
            feeds: []

  def new(url) do
    %__MODULE__{initial_url: url}
  end
end
