defmodule MagiratorAppChannel.PlayerController do
    
    import MagiratorAppChannel.PlayerStore
    alias MagiratorAppChannel.DeckStore
    alias MagiratorAppChannel.Streamliner
    require Logger
  
    def doAction( action, data ) do
  
      _doAction( action, data )
    end
  
    defp _doAction( "search", routing_packet) do
      
      { :ok, store_result } = search_by_name routing_packet.data_in["name"]

      Logger.debug Kernel.inspect store_result
  
      { :data, Streamliner.changesetStructListToMapList store_result }
    end
  

    defp _doAction( "decks", routing_packet) do
      
      { :ok, store_result } = DeckStore.select_all_by_player routing_packet.data_in["id"]

      Logger.debug Kernel.inspect store_result
  
      { :data, Streamliner.changesetStructListToMapList store_result }
    end


    defp _doAction( "current", routing_packet) do
      
      Logger.debug Kernel.inspect routing_packet.data_in

      { :ok, store_result } = get_by_user_id routing_packet.user_id

      Logger.debug Kernel.inspect store_result
  
      { :data, Streamliner.changesetStructToMap store_result }
    end
end