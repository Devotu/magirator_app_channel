defmodule GameStoreTest do
    use ExUnit.Case

    import MagiratorAppChannel.GameStore
    import Ecto.Changeset

    alias MagiratorAppChannel.GameResultSet


    test "select all games deck" do
        { status, data } = selectAllByDeck 20
        assert :ok == status
        assert is_list data
        assert %GameResultSet{} = List.first data
    end

    test "select all games from deck with no games" do
        { status, msg } = selectAllByDeck 99
        assert :ok == status
        assert :no_data == msg
    end
end