defmodule MagiratorAppChannel.Token do
  
    alias MagiratorAppChannel.Constants
    alias MagiratorAppChannel.Encryption

    def create_user_token(user_id) do
    
        {:ok, tokens_db} = Redix.start_link()
        Redix.command(tokens_db, ["SELECT", Constants.token_db])
    
        token = Encryption.random_string_of_length Constants.token_length
    
        Redix.command(tokens_db, ["SET", token, "user_id:#{user_id}"])
        Redix.command(tokens_db, ["EXPIRE", token, Constants.token_expiration])
    
        Redix.stop(tokens_db)
    
        {:ok, token}
    end
end