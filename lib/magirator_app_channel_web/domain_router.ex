defmodule MagiratorAppChannel.DomainRouter do

    alias MagiratorAppChannel.DeckController
    
    require Logger

    def route( routing_packet ) do

        Logger.debug "Routing to #{routing_packet.domain}"

        _route( routing_packet.domain, routing_packet )
    end

    defp _route( "deck", routing_packet ) do
        
        Logger.debug "doing deck action #{routing_packet.action}"
        DeckController.doAction( routing_packet.action, routing_packet )
    end

    defp _route( _domain, _packet ) do
        
        { :error, :no_domain_match }
    end
end