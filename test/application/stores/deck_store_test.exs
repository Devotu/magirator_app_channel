defmodule DeckStoreTest do
    use ExUnit.Case

    import Ecto.Changeset
    import MagiratorAppChannel.DeckStore
    alias MagiratorAppChannel.Deck

    #Insert
    test "insert deck" do
        deck_changeset = Deck.changeset( %Deck{ }, %{ 
            name: "DeckStoreTest" , 
            theme: "themy", 
            format: "formaty", 
            black: :false, 
            white: :false, 
            red: :false, 
            green: :true, 
            blue: :true, 
            colorless: :false, 
            budget: 18, 
            worth: 16.7
            } )
        { status, id } = insert( apply_changes( deck_changeset ), 1 )
        assert :ok == status
        assert is_number id
    end

    #User
    test "select all decks user" do
        { status, data } = select_all_by_user 1
        assert :ok == status
        assert is_list data
        assert not Enum.empty? data
    end

    test "select all decks user with no decks" do
        { status, data } = select_all_by_user 99
        assert :ok == status
        assert [] == data
    end

    #Player
    test "select player decks" do
        { status, data } = select_all_by_player 10
        assert :ok == status
        assert is_list data
        assert not Enum.empty? data
    end

    test "select all decks player with no decks" do
        { status, data } = select_all_by_player 99
        assert :ok == status
        assert [] == data
    end

    #Id
    test "select deck by id" do
        { status, data } = select_by_id 20
        assert :ok == status
        assert data.name == "Deck 1"
    end

    test "select deck not exist" do
        { status, data } = select_by_id 99
        assert :error == status
        assert "no such user/player" == data
    end

    test "pick my deck" do
        { status, data } = pick_user_deck_id( 3, [20,21,23])
        assert :ok == status
        assert data == 23
    end
end