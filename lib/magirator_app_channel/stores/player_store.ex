defmodule MagiratorAppChannel.PlayerStore do
    
    alias Bolt.Sips, as: Bolt
    alias MagiratorAppChannel.Player
    import Ecto.Changeset
    require Logger


    #Functions
    def search_by_name( name ) do

        query = """
        MATCH
            (p:Player)
            -[:Currently]->
            (data:Data) 
         WHERE 
            data.name =~ "(?i)#{ name }.*" 
         WITH 
            p,data
            LIMIT 10
         RETURN 
            p,data
        """

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        players = nodes_to_players result

        { :ok, players }
    end


    def get_by_user_id( user_id ) do

        query = """
        MATCH 
            (u:User) 
            -[:Is]-> 
            (p:Player) 
            -[:Currently]-> 
            (data:Data) 
        WHERE 
            u.id = #{user_id} 
        RETURN 
            p,data
        """

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        players = nodes_to_players result

        pick_one players
    end


    def get_by_deck_id( deck_id ) do

        query = """
        MATCH 
            (d:Deck) 
            <-[:Possess]- 
            (p:Player) 
            -[:Currently]-> 
            (data:Data) 
        WHERE 
            d.id = #{deck_id} 
        RETURN 
            p,data
        """

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        players = nodes_to_players result

        pick_one players
    end


    def list_all() do

        query = """
        MATCH 
            (u:User) 
            -[:Is]-> 
            (p:Player) 
            -[:Currently]-> 
            (data:Data) 
        RETURN 
            p,data
        """

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        players = nodes_to_players result

        { :ok, players }
    end


    #Helpers
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

    defp pick_one( players ) do
        case Enum.count players do
            1 ->
                Enum.fetch(players, 0)
            0 ->
                { :error, "no such user/player"}
            _ ->
                { :error, "invalid request"}
        end
    end
end