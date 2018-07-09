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

        signIn(result)
    end

    defp signIn([_nodes]) do
        Logger.debug( "signIn(nodes)" )
        :ok
    end

    defp signIn([]) do
        Logger.debug( "signIn([])" )
        :error
    end

    defp signIn(_) do
        Logger.debug( "signIn(_)" )
        :error
    end
end