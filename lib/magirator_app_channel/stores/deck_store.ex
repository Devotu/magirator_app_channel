defmodule MagiratorAppChannel.DeckStore do
    
    alias Bolt.Sips, as: Bolt
    import MagiratorAppChannel.IdStore    
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
           colorless: #{ deck.colorless } 
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
end