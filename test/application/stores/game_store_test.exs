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
    { _, id } = create( apply_changes( game_changeset ) )

    result_one_changeset = Result.changeset( %Result{}, %{ 
      "place" => 1, 
      "created" => System.system_time(:seconds)
    })
    result_one = apply_changes( result_one_changeset )
    { status_one, _ } = add_result( id, 22, result_one )
    assert :ok == status_one

    result_two_changeset = Result.changeset( %Result{}, %{ 
      "place" => 2, 
      "created" => System.system_time(:seconds)
    })
    result_two = apply_changes( result_two_changeset )
    { status_two, _ } = add_result( id, 23, result_two )
    assert :ok == status_two
  end

  
  test "confirm result" do
    game_changeset = Game.changeset( %Game{}, %{ 
      "conclusion" => "VICTORY", 
      "created" => System.system_time(:seconds), 
      "creator" => 3
    })
    { _, id } = create( apply_changes( game_changeset ) )

    result_changeset = Result.changeset( %Result{}, %{ 
      "place" => 1, 
      "created" => System.system_time(:seconds)
    })
    result = apply_changes( result_changeset )
    { status_add, id } = add_result( id, 23, result )
    assert :ok == status_add

    result_with_id_changeset = Result.changeset( %Result{}, %{ 
      "id" => id,
      "place" => result.place, 
      "comment" => "GameStoreTest - confirm result"
    })
    result_with_id = apply_changes( result_with_id_changeset )
    { status_confirm, _ } = confirm_result( result_with_id )
    assert :ok == status_confirm
  end

  test "fail confirm result - no id" do
    result_commented_changeset = Result.changeset( %Result{}, %{ 
      "place" => 1, 
      "comment" => "GameStoreTest - confirm result",
      "created" => System.system_time(:seconds)
    })
    result_commented = apply_changes( result_commented_changeset )
    { status, cause } = confirm_result( result_commented )
    assert :error == status
    assert :no_id == cause
  end

  
  test "comment result" do
    game_changeset = Game.changeset( %Game{}, %{ 
      "conclusion" => "VICTORY", 
      "created" => System.system_time(:seconds), 
      "creator" => 3
    })
    { _, id } = create( apply_changes( game_changeset ) )

    result_changeset = Result.changeset( %Result{}, %{ 
      "place" => 1, 
      "created" => System.system_time(:seconds),
      "comment" => "This should not be the comment. GameStoreTest - comment result"
    })
    result = apply_changes( result_changeset )
    { status_add, id } = add_result( id, 23, result )
    assert :ok == status_add

    result_with_id_changeset = Result.changeset( %Result{}, %{ 
      "id" => id,
      "place" => result.place, 
      "comment" => "GameStoreTest - comment result"
    })
    result_with_id = apply_changes( result_with_id_changeset )
    { status_comment, _ } = comment_result( result_with_id )
    assert :ok == status_comment
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