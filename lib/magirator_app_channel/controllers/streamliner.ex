defmodule MagiratorAppChannel.Streamliner do
    
    def changesetStructToMap( changeset_struct ) do
        
        changeset_struct
        |> Map.from_struct
        |> Map.delete( :__meta__ )
    end
    
    def changesetStructListToMapList( {:ok, struct_list} ) do
        
        changesetStructListToMapList struct_list
    end
    
    def changesetStructListToMapList( struct_list ) do
        
        Enum.map( struct_list, &changesetStructToMap/1 )
    end

end