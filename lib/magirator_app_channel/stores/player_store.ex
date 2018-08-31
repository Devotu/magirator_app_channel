defmodule MagiratorAppChannel.PlayerStore do
    
    alias Bolt.Sips, as: Bolt
    alias MagiratorAppChannel.Player
    import Ecto.Changeset
    require Logger


    def search_by_name( name ) do

        query = """
        MATCH
            (p:Player)
            -[:Currently]->
            (data:Data) 
         WHERE 
            data.name =~ "(?i)#{ name }.*" 
         RETURN p,data
        """

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        players = nodes_to_players result

        { :ok, players }
    end


    defp nodes_to_players( nodes ) do
        Enum.map( nodes, &node_to_player/1 )
    end

    defp node_to_player( node ) do

        player_data = Map.merge( node["p"].properties, node["data"].properties )

        player_changeset = Player.changeset( %Player{}, player_data )

        if player_changeset.valid? do
            apply_changes player_changeset
        else
            { :error, :invalid_data }
        end
    end
end