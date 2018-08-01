defmodule MagiratorAppChannel.Auth do
    
    alias Bolt.Sips, as: Bolt
    
    require Logger
    
    def authenticate( user, pwd ) do

        hashword = :crypto.hash( :sha512, pwd ) 
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

        case result do
            [nodes] ->
                { :ok, nodes["u"].properties["id"] }
            _ -> 
                { :error, :invalid_credentials }
        end
    end
end