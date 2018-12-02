defmodule MagiratorAppChannel.DeckStore do
    
    alias Bolt.Sips, as: Bolt
    alias MagiratorAppChannel.Deck
    import MagiratorAppChannel.IdStore
    import Ecto.Changeset
    require Logger

    def insert( deck, user_id ) do

        { :ok, generated_id } = next_id()

        optionals = ""

        if( deck.budget != nil ) do
            optionals = optionals <> ",budget: #{ deck.budget }"
        end

        if( deck.worth != nil ) do
            optionals = optionals <> ",worth: #{ deck.worth }"
        end

        query = """
        MATCH   
         (a:User)-[:Is]->(p:Player)  
         WHERE  
          a.id = #{ user_id } 
         CREATE  
         (p) 
          -[:Possess]-> 
         (n:Deck:Active:PERSISTENT { id:#{ generated_id } } )  
          -[:Currently]-> 
         (d:Data {  
           created:TIMESTAMP(), 
           name: "#{ deck.name }", 
           format: "#{ "Standard" }", 
           theme: "#{ deck.theme }", 
           black: #{ deck.black }, 
           white: #{ deck.white }, 
           red: #{ deck.red }, 
           green: #{ deck.green }, 
           blue: #{ deck.blue }, 
           colorless: #{ deck.colorless }
           #{optionals}
         })  
         RETURN n.id as id;
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


    def select_all_by_user( user_id ) do

        query = """
        MATCH 
         (u:User)-[:Is]->(:Player)
         -[:Possess]->(d:Deck)
         -[:Currently]->(data:Data) 
        WHERE 
         u.id = #{ user_id } 
        RETURN 
         d, data
        """
        
        result = Bolt.query!(Bolt.conn, query)
        decks = nodesToDecks result

        { :ok, decks }
    end

    def select_all_by_player( player_id ) do

        query = """
        MATCH 
         (p:Player)-[:Possess]->(d:Deck)
         -[:Currently]->(data:Data) 
        WHERE 
         p.id = #{ player_id } 
        RETURN 
         d, data
        """
        
        result = Bolt.query!(Bolt.conn, query)
        decks = nodesToDecks result
        
        { :ok, decks }
    end

    def select_by_id( deck_id ) do

        query = """
        MATCH 
         (d:Deck)-[:Currently]->(data:Data) 
        WHERE 
         d.id = #{ deck_id } 
        RETURN 
         d, data
        """
        
        result = Bolt.query!(Bolt.conn, query)
        decks = nodesToDecks result

        case Enum.count decks do
            1 ->
                Enum.fetch(decks, 0)
            0 ->
                { :error, "no such user/player"}
            _ ->
                { :error, "invalid request"}
        end
    end


    defp nodesToDecks( nodes ) do
        Enum.map( nodes, &nodeToDeck/1 )
    end

    defp nodeToDeck( node ) do

        deck_data = Map.merge( node["d"].properties, node["data"].properties )

        deck_changeset = Deck.changeset( %Deck{}, deck_data )

        if deck_changeset.valid? do
            apply_changes deck_changeset
        else
            { :error, :invalid_data }
        end
    end
end