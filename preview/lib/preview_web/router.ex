defmodule PreviewWeb.Router do
  use PreviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PreviewWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/playerdata.json", PodcastController, :playerdata
    get("/*feed_url", PodcastController, :podcast)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PreviewWeb do
  #   pipe_through :api
  # end
end
