defmodule MagiratorAppChannelWeb.TokenController do
    use MagiratorAppChannelWeb, :controller

    alias MagiratorAppChannel.Auth
    alias MagiratorAppChannel.Encryption
    alias MagiratorAppChannel.Constants
    require Logger

    
    def new(conn, %{"user" => user, "pwd" => pwd}) do 

        Logger.debug "user:#{user}, pwd:#{pwd}"

        case Auth.authenticate(user, pwd) do          
          {:ok, user_id} ->
            Logger.debug "auth ok user {#user_id}"
            
            {:ok, token} = set_token user_id
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

    defp set_token(user_id) do
    
        {:ok, tokens_db} = Redix.start_link()
        Redix.command(tokens_db, ["SELECT", Constants.token_db])
    
        token = Encryption.random_string_of_length Constants.token_length
    
        Redix.command(tokens_db, ["SET", token, "user_id:#{user_id}"])
        Redix.command(tokens_db, ["EXPIRE", token, Constants.token_expiration])
    
        Redix.stop(tokens_db)
    
        {:ok, token}
    end

end