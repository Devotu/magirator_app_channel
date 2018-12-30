defmodule MagiratorAppChannelWeb.MainChannel do
    use Phoenix.Channel

    alias MagiratorAppChannel.RoutingPacket
    alias MagiratorAppChannel.PlayerStore
    import MagiratorAppChannel.DomainRouter

    require Logger

    def join("app:main", _message, socket) do
        Logger.debug "join app:main :ok"
        Logger.debug Kernel.inspect socket.assigns[:user_id]

        case is_number socket.assigns[:user_id] do
            :true ->
                {:ok, %{id: socket.assigns[:user_id]}, socket}
            _ ->       
                {:error, %{reason: "unauthorized"}}
        end
    end


    @doc """
    String domain:action, mr.data.struct data, socket socket
    """
    def handle_in(domain_action, data, socket) do        
        user_id = socket.assigns[:user_id]

        Logger.debug "user: #{user_id}"
        Logger.debug "domac: #{domain_action}"
        Logger.debug "data: #{Kernel.inspect(data)}"

        {given_self, data_in} = Map.pop(data, "self")

        Logger.debug "given_self: #{given_self}"

        data_in = 
        case given_self do
            nil ->
                data_in
            _ -> 
                {:ok, user_player} = PlayerStore.select_by_user_id user_id
                Map.put(data_in, "player_id", user_player.id)
        end

        [domain, action] = String.split(domain_action, ":")

        routing_packet = %RoutingPacket{ user_id: user_id, domain: domain, action: action, data_in: data_in }

        # kalla på domainrouter.route( domain, data ) och ta hand om response
        { status, msg } = route( routing_packet )

        Logger.debug Kernel.inspect msg

        case status do
            :data ->
                {:reply, {:ok, %{data: msg, description: domain_action}}, socket}
            :ok ->
                {:reply, :ok, socket}
            _ ->
                {:reply, {:error, %{cause: msg}} , socket}
        end

    end
end