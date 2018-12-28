defmodule InstaloveWeb.Router do
  use InstaloveWeb, :router

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

  scope "/", InstaloveWeb do
    pipe_through :browser

    get "/", PageController, :index
    get("/*feed_url", PodcastController, :podcast)
  end

  # Other scopes may use custom stacks.
  # scope "/api", InstaloveWeb do
  #   pipe_through :api
  # end
end
