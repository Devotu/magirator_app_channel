defmodule MagiratorAppChannel.DeckStore do
    
    alias Bolt.Sips, as: Bolt
    alias MagiratorAppChannel.Deck
    import MagiratorAppChannel.IdStore    
    import Ecto.Changeset
    require Logger

    def insert( deck, user_id ) do

        { :ok, generated_id } = next_id()

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
           colorless: #{ deck.colorless }, 
           budget: #{ deck.budget }, 
           worth: #{ deck.worth } 
         })  
         RETURN n.id as id;
        """

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        Logger.debug( Kernel.inspect( result ) )
        [ row ] = result
        Logger.debug( Kernel.inspect( row ) )
        { created_id } = { row["id"] }

        case created_id == generated_id do
            :true ->
                { :ok, created_id }
            :false ->
                { :error, :insert_failure }
        end
    end


    def selectAllByUser( user_id ) do

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

        Logger.debug "query:#{query}"
        
        result = Bolt.query!(Bolt.conn, query)
        decks = nodesToDecks result

        if Enum.empty? decks do
            { :ok, :no_data }
        else 
            { :ok, decks }
        end
    end


    defp nodesToDecks( nodes ) do
        Enum.map( nodes, &nodeToDeck/1 )
    end

    defp nodeToDeck( node ) do

        deck_data = Map.merge( node["d"].properties, node["data"].properties )

        deck_changeset = Deck.changeset( %Deck{ }, deck_data )

        if deck_changeset.valid? do
            apply_changes deck_changeset
        else
            { :error, :invalid_data }
        end
    end
end