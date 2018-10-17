defmodule MagiratorAppChannel.Token do
  
    alias MagiratorAppChannel.Constants
    alias MagiratorAppChannel.Encryption
    require Logger

    def create_user_token(user_id) do
    
        {:ok, tokens_db} = Redix.start_link()
        Redix.command(tokens_db, ["SELECT", Constants.token_db])
    
        token = Encryption.random_string_of_length Constants.token_length
    
        Redix.command(tokens_db, ["SET", token, user_id])
        Redix.command(tokens_db, ["EXPIRE", token, Constants.token_expiration])
    
        Redix.stop(tokens_db)
    
        {:ok, token}
    end

    def verify(token) do

        {:ok, tokens_db} = Redix.start_link()
        Redix.command(tokens_db, ["SELECT", Constants.token_db])
    
        {result, value} = Redix.command(tokens_db, ["GET", token])
    
        Redix.stop(tokens_db)
        
        case result do 
            :ok ->
                case value do
                    nil ->
                        {:error, :no_match}

                    _ ->
                        case Integer.parse value do
                            {id, _} -> 
                                {:ok, id}
                            
                            _ ->
                                {:error, :parse}
                        end
                end
            
            _ -> 
                {:error, value}
        end
    end

end