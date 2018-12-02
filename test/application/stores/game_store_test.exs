defmodule GameStoreTest do
    use ExUnit.Case

    import MagiratorAppChannel.GameStore

    import Ecto.Changeset
    alias MagiratorAppChannel.Game
    alias MagiratorAppChannel.GameResultSet

    #Insert
    test "create game" do
        game_changeset = Game.changeset( %Game{}, %{ 
            "conclusion" => "VICTORY", 
            "created" => System.system_time(:seconds), 
            "creator" => 1} 
            )
        { status, id } = create( apply_changes( game_changeset ) )
        assert :ok == status
        assert is_number id
    end


    #Select
    test "select all games deck" do
        { status, data } = select_all_by_deck 20
        assert :ok == status
        assert is_list data
        assert %GameResultSet{} = List.first data
    end

    test "select all games from deck with no games" do
        { status, msg } = select_all_by_deck 99
        assert :ok == status
        assert [] == msg
    end
end