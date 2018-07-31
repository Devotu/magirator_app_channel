defmodule MagiratorAppChannelWeb.MainChannel do
    use Phoenix.Channel

    alias Bolt.Sips, as: Bolt
    
    alias MagiratorAppChannel.RoutingPacket
    import MagiratorAppChannel.DomainRouter

    require Logger

    def join("app:main", message, socket) do
        Logger.debug "join:ok"
        Logger.debug "app:#{message}"
        {:ok, %{test: "joined"}, socket}
    end

    def join("app:" <> user, _params, socket) do
        Logger.debug("Joining channel app:#{user}");
        join(socket, socket.assigns.user_id)
    end

    defp join(socket, user_id) do
        {:ok, %{}, socket}
    end

    defp join(socket, nil) do        
        {:error, %{reason: "unauthorized"}}
    end

    defp join(socket, nil) do        
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
        broadcast(socket, "new_msg", %{msg: "msg", user_id: user_id, data: now})
        {:reply, :ok, socket}
    end


    def handle_in("newdeck", %{"name" => name, "theme" => theme}, socket) do
        user_id = socket.assigns[:user_id]

        response = "Got deck #{name} with theme #{theme}"

        broadcast(socket, "new_msg", %{msg: response, user_id: user_id, data: now})
        {:reply, :ok, socket}
    end

    @doc """
    String domain:action, mr.data.struct data, socket socket
    """
    def handle_in(domac, data, socket) do        
        user_id = socket.assigns[:user_id]

        [domain, action] = String.split(domac, ":")

        routing_packet = %RoutingPacket{ user_id: user_id, domain: domain, action: action, data_in: data }

        # kalla på domainrouter.route( domain, data ) och ta hand om response
        { status, msg } = route( routing_packet )

        case status do
            :ok ->
                broadcast(socket, "new_msg", %{msg: msg, user_id: user_id, data: now})
            _ ->
                broadcast(socket, "new_msg", %{msg: msg, user_id: user_id, data: now})
        end

        {:reply, :ok, socket}
    end

    defp now do
        System.system_time(:seconds)
    end
end