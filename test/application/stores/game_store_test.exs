defmodule GameStoreTest do
    use ExUnit.Case

    import MagiratorAppChannel.GameStore

    import Ecto.Changeset
    alias MagiratorAppChannel.Game
    alias MagiratorAppChannel.Result
    alias MagiratorAppChannel.GameResultSet

    #Insert
    test "create game" do
        game_changeset = Game.changeset( %Game{}, %{ 
            "conclusion" => "VICTORY", 
            "created" => System.system_time(:seconds), 
            "creator" => 1
        })
        { status, id } = create( apply_changes( game_changeset ) )
        assert :ok == status
        assert is_number id
    end
    
    test "add results" do
        game_changeset = Game.changeset( %Game{}, %{ 
            "conclusion" => "VICTORY", 
            "created" => System.system_time(:seconds), 
            "creator" => 2
        })
        { status, id } = create( apply_changes( game_changeset ) )

        result_one_changeset = Result.changeset( %Result{}, %{ 
            "place" => 1, 
            "comment" => "Created by GameStoreTest - add result - 1", 
            "created" => System.system_time(:seconds)
        })
        result_one = apply_changes( result_one_changeset )
        { status_one, _ } = add_result( id, 22, result_one )
        assert :ok == status_one

        result_two_changeset = Result.changeset( %Result{}, %{ 
            "place" => 2, 
            "comment" => "Created by GameStoreTest - add result - 2", 
            "created" => System.system_time(:seconds)
        })
        result_two = apply_changes( result_two_changeset )
        { status_two, _ } = add_result( id, 23, result_two )
        assert :ok == status_two
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