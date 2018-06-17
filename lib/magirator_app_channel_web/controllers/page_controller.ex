defmodule MagiratorAppChannelWeb.PageController do
  use MagiratorAppChannelWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
