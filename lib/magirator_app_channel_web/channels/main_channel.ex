defmodule MagiratorAppChannelWeb.MainChannel do
    use Phoenix.Channel

    alias MagiratorAppChannel.RoutingPacket
    import MagiratorAppChannel.DomainRouter

    require Logger

    def join("app:main", message, socket) do
        Logger.debug "join app:main :ok"
        Logger.debug Kernel.inspect socket.assigns[:user_id]
        {:ok, %{id: socket.assigns[:user_id]}, socket}
    end

    defp join( _, nil ) do        
        {:error, %{reason: "unauthorized"}}
    end

    defp join( _, _ ) do        
        {:error, %{reason: "unknown error"}}
    end

    
    def handle_in("new_msg", %{"msg" => msg}, socket) do
        user_id = socket.assigns[:user_id]

        # query = """
        # MATCH (n) WHERE id(n) = 164 RETURN n.name as name, n.created as id
        # """

        # now = now()

        # Logger.debug "now:#{now}"
        # Logger.debug "query:#{query}"

        
        # result = Bolt.query!(Bolt.conn, query)
        # Logger.debug( Kernel.inspect( result ) )
        # [foo] = result
        # Logger.debug( Kernel.inspect( foo ) )
        # {bar, baz} = {foo["name"], foo["id"]}
        # Logger.debug( Kernel.inspect( bar ) )
        # Logger.debug( Kernel.inspect( baz ) )
    
        # broadcast(socket, "new_msg", %{msg: msg, user: user, data: bar})
        broadcast(socket, "new_msg", %{msg: msg, user_id: user_id, data: now()})
        {:reply, :ok, socket}
    end


    def handle_in("newdeck", %{"name" => name, "theme" => theme}, socket) do
        user_id = socket.assigns[:user_id]

        response = "Got deck #{name} with theme #{theme}"

        broadcast(socket, "new_msg", %{msg: response, user_id: user_id, data: now()})
        {:reply, :ok, socket}
    end

    @doc """
    String domain:action, mr.data.struct data, socket socket
    """
    def handle_in(domain_action, data, socket) do        
        user_id = socket.assigns[:user_id]

        Logger.debug "user: #{user_id}"
        Logger.debug "domac: #{domain_action}"
        Logger.debug "data: #{Kernel.inspect(data)}"

        [domain, action] = String.split(domain_action, ":")

        routing_packet = %RoutingPacket{ user_id: user_id, domain: domain, action: action, data_in: data }

        # kalla på domainrouter.route( domain, data ) och ta hand om response
        { status, msg } = route( routing_packet )

        Logger.debug Kernel.inspect msg

        case status do
            :data ->
                {:reply, {:ok, %{data: msg, description: domain_action}}, socket}
                # broadcast(socket, "data", %{data: msg, user_id: user_id, description: domain_action})
            :ok ->
                broadcast(socket, "new_msg", %{msg: msg, user_id: user_id, data: now()})
                {:reply, :ok, socket}
            _ ->
                broadcast(socket, "new_msg", %{msg: msg, user_id: user_id, data: now()})
                {:reply, :error, socket}
        end

    end

    defp now do
        System.system_time(:seconds)
    end
end