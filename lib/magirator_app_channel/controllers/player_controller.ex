defmodule MagiratorAppChannel.PlayerController do
    
    import MagiratorAppChannel.PlayerStore
    alias MagiratorAppChannel.DeckStore
    alias MagiratorAppChannel.Streamliner
    require Logger
  
    def do_action( action, data ) do
  
      _do_action( action, data )
    end
  
    defp _do_action( "search", routing_packet) do
      
      { :ok, store_result } = search_by_name routing_packet.data_in["name"]

      Logger.debug Kernel.inspect store_result
  
      { :data, Streamliner.changeset_struct_list_to_map_list store_result }
    end
  

    defp _do_action( "decks", routing_packet) do
      
      { :ok, store_result } = DeckStore.select_all_by_player routing_packet.data_in["id"]

      Logger.debug Kernel.inspect store_result
  
      { :data, Streamliner.changeset_struct_list_to_map_list store_result }
    end


    defp _do_action( "current", routing_packet) do
      
      Logger.debug Kernel.inspect routing_packet.data_in

      { :ok, store_result } = get_by_user_id routing_packet.user_id

      Logger.debug Kernel.inspect store_result
  
      { :data, Streamliner.changeset_struct_to_map store_result }
    end
end