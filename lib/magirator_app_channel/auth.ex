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
        # [nodes] = result
        # Logger.debug( "Nodes:" )
        # Logger.debug( Kernel.inspect( nodes ) )

        # data = nodes["d"]
        # Logger.debug( "d:" )
        # Logger.debug( Kernel.inspect ( data ) )

        socket = ""
        signIn(result, socket)
    end

    defp signIn([nodes], socket) do
        Logger.debug( "signIn(nodes)" )
        Logger.debug( "Nodes:" )
        Logger.debug( Kernel.inspect( nodes ) )


        :ok
    end

    defp signIn([], socket) do
        Logger.debug( "signIn([])" )
        :error
    end

    defp signIn(_, _) do
        Logger.debug( "signIn(_)" )
        :error
    end
end