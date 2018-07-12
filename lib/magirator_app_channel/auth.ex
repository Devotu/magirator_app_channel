defmodule MagiratorAppChannel.Auth do
    
    alias Bolt.Sips, as: Bolt
    
    require Logger
    
    def authenticate(user, pwd) do

        hashword = :crypto.hash( :sha512, pwd) 
            |> Base.encode16
            |> String.downcase

        query = """
        MATCH 
            (u:User)-[:Currently]->(d:Data) 
        WHERE 
            d.name = "#{user}" 
            AND d.password = "#{hashword}" 
        RETURN 
            u,d
        """

        result = Bolt.query!(Bolt.conn, query)
        Logger.debug( "Result:" )
        Logger.debug( Kernel.inspect( result ) )        

        getId(result)
    end

    defp getId(result) do

        [nodes] = result
        user = nodes["u"]
        %{id: user_id} = user

        Logger.debug( "got user_id: #{user_id}" )

        {:ok, user_id}
    end

    defp getId(_) do
        Logger.debug( "getId(_)" )
        :error
    end
end