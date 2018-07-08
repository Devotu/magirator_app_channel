defmodule MagiratorAppChannelWeb.UserSocket do
  use Phoenix.Socket
  alias MagiratorAppChannel.Auth
  require Logger

  ## Channels
  channel "app:main", MagiratorAppChannelWeb.MainChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  def connect(%{"user" => user, "pwd" => pwd}, socket) do

    Logger.debug "user:#{user}, pwd:#{pwd}"
    case Auth.authenticate(user, pwd) do
      :ok ->
        Logger.debug "connection ok"
        {:ok, socket}
      _ ->
        Logger.debug "authentication error"
        :error
    end
  end

  def connect(_params, _socket) do
    Logger.debug "connection parameter error"
    :error
  end



  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MagiratorAppChannelWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
