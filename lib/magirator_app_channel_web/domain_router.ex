defmodule MagiratorAppChannel.DomainRouter do

    alias MagiratorAppChannel.DeckController, as: DeckController
    
    def route( packet ) do

        IO.puts "Routing to #{packet.domain}"

        _route( packet.domain, packet )
    end

    defp _route( "deck:" <> domain, packet ) do
        
        DeckController.doAction( packet.action, packet )
    end

    defp _route( _domain, _packet ) do
        
        { :error, :no_domain_match }
    end
end