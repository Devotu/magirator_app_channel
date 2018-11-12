defmodule MagiratorAppChannel.Streamliner do
    
    def changeset_struct_to_map( changeset_struct ) do
        
        changeset_struct
        |> Map.from_struct
        |> Map.delete( :__meta__ )
    end
    
    def changeset_struct_list_to_map_list( {:ok, struct_list} ) do
        
        changeset_struct_list_to_map_list struct_list
    end
    
    def changeset_struct_list_to_map_list( struct_list ) do
        
        Enum.map( struct_list, &changeset_struct_to_map/1 )
    end

end