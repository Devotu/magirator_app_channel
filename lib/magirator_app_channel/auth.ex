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

        getId(result)
    end

    defp getId(result) do

        [nodes] = result
        user = nodes["u"]
        %{id: user_id} = user

        {:ok, user_id}
    end

    defp getId(_) do
        :error
    end
end