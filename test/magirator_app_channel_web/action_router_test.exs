defmodule ActionRouterTest do
    use ExUnit.Case
    import MagiratorAppChannelWeb.ActionRouter

    test "routes" do
        {status, _} = route("deck:new", nil)
        assert :ok == status
    end
end