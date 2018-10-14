defmodule MagiratorAppChannelWeb.Router do
  use MagiratorAppChannelWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:4100"
    plug :accepts, ["json"]
  end

  scope "/api", MagiratorAppChannelWeb do
    pipe_through :api

    get "/token/:user/:pwd", TokenController, :new
  end
end
