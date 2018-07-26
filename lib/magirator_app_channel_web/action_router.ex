defmodule MagiratorAppChannelWeb.ActionRouter do
    
    def route( action, data ) do
        _route( action, data )
    end

    defp _route( "deck:" <> action, data ) do
        
        {:ok, "routed"}
    end
end