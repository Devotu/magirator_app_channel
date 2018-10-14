defmodule MagiratorAppChannelWeb.TokenController do
    use MagiratorAppChannelWeb, :controller

    alias MagiratorAppChannel.Auth
    alias MagiratorAppChannel.Encryption
    alias MagiratorAppChannel.Token
    require Logger

    
    def new(conn, %{"user" => user, "pwd" => pwd}) do 

        Logger.debug "user:#{user}, pwd:#{pwd}"

        case Auth.authenticate(user, pwd) do          
          {:ok, user_id} ->
            Logger.debug "auth ok user {#user_id}"
            
            {:ok, token} = Token.create_user_token user_id
            Logger.debug "{#token}"

            json conn, %{result: :ok, token: token}
          
          _ ->
            Logger.debug "authentication error"
            json conn, %{result: :error, cause: "unauthorized"}
        end
    end

    def new(conn, %{}) do 
        json conn, %{result: :error, cause: "no data"}
    end

end