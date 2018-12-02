defmodule MagiratorAppChannel.GameStore do
    
    alias Bolt.Sips, as: Bolt
    import Ecto.Changeset
    require Logger

    alias MagiratorAppChannel.Player
    alias MagiratorAppChannel.Deck
    alias MagiratorAppChannel.Result
    alias MagiratorAppChannel.Game
    alias MagiratorAppChannel.GameResultSet
    import MagiratorAppChannel.IdStore

    alias MagiratorAppChannel.Streamliner

    @doc """
    Creates a game node ready to tie the results together
    A full registerd game contains several nodes of which the actual game node is the hub
    """
    def create( game ) do
        
        { :ok, generated_id } = next_id()

        query = """
        MATCH 
          (u:User)-[:Is]->(p:Player) 
         WHERE 
          u.id = #{ game.creator } 
         CREATE 
          (p)-[:Created]->(g:Game { id:#{ generated_id }, created:TIMESTAMP(), conclusion: "#{ game.conclusion }" })
         RETURN g.id as id;
        """
        
        result = Bolt.query!(Bolt.conn, query)
        [ row ] = result
        { created_id } = { row["id"] }

        case created_id == generated_id do
            :true ->
                { :ok, created_id }
            :false ->
                { :error, :insert_failure }
        end
    end

    def select_all_by_deck( deck_id ) do

        Logger.debug Kernel.inspect deck_id

        query = """
        MATCH 
            (d:Deck)
            -[:Got]->
            (:Result)
            -[:In]->
            (g:Game) 
        WHERE 
            d.id = #{ deck_id } 
        WITH 
            g 
        MATCH 
            (g)
            <-[:In]-
            (r:Result)
            <-[:Got]-
            (d:Deck)
            <-[:Possess]-
            (p:Player), 
            (p)
            -[:Currently]->
            (pd:Data),
            (d)
            -[:Currently]->
            (dd:Data)  
        RETURN 
            g,d,p,r,pd,dd
        """

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        gamesets = nodes_to_game_result_sets result

        { :ok, gamesets }
    end


    defp nodes_to_game_result_sets( nodes ) do
        Enum.map( nodes, &node_to_game_result_set/1 )
    end

    defp node_to_game_result_set( node ) do

        player_data = Map.merge( node["p"].properties, node["pd"].properties )
        player_changeset = Player.changeset( %Player{}, player_data )

        deck_data = Map.merge( node["d"].properties, node["dd"].properties )
        deck_changeset = Deck.changeset( %Deck{}, deck_data )

        result_data = node["r"].properties
        result_changeset = Result.changeset( %Result{}, result_data )

        game_data =node["g"].properties
        game_changeset = Game.changeset( %Game{}, game_data )

        if player_changeset.valid? and deck_changeset.valid? and result_changeset.valid? and game_changeset.valid?  do

            player_map = apply_to_map player_changeset
            deck_map = apply_to_map deck_changeset
            result_map = apply_to_map result_changeset
            game_map = apply_to_map game_changeset

            %GameResultSet{ player: player_map, deck: deck_map, result: result_map, game: game_map }
        else
            { :error, :invalid_data }
        end
    end

    defp apply_to_map( changeset ) do
        changeset
        |> apply_changes 
        |> Streamliner.changeset_struct_to_map
    end
end