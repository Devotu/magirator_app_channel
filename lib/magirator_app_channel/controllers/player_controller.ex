defmodule MagiratorAppChannel.PlayerController do
    
    import MagiratorAppChannel.PlayerStore
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
end