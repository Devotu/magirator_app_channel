defmodule MagiratorAppChannelWeb.MainChannel do
    use Phoenix.Channel

    alias MagiratorAppChannel.Utils
    alias Bolt.Sips, as: Bolt

    require Logger

    def join("app:main", _message, socket) do
        socket = assign(socket, :user, "mrX")
        {:ok, %{test: "joined"}, socket}
    end

    def join("app:" <> _id, _params, _socket) do
        {:error, %{reason: "unauthorized"}}
    end

    def handle_in("new_msg", %{"msg" => msg}, socket) do
        user = socket.assigns[:user]

        query = """
        MATCH (n) WHERE id(n) = 266 RETURN n.name as name, n.created as id
        """

        now = now()

        Logger.debug "now:#{now}"
        Logger.debug "query:#{query}"

        
        result = Bolt.query!(Bolt.conn, query)
        Logger.debug( Kernel.inspect( result ) )
        [foo] = result
        Logger.debug( Kernel.inspect( foo ) )
        {bar, baz} = {foo["name"], foo["id"]}
        Logger.debug( Kernel.inspect( bar ) )
        Logger.debug( Kernel.inspect( baz ) )
    
        broadcast(socket, "new_msg", %{msg: msg, user: user, data: bar})
        {:reply, :ok, socket}
    end

    defp now do
        System.system_time(:seconds)
    end
end