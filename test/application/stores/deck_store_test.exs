defmodule DeckStoreTest do
    use ExUnit.Case

    import MagiratorAppChannel.DeckStore
    alias MagiratorAppChannel.Deck
    import Ecto.Changeset

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
        { status, decks } = selectAllByUser 1
        assert :ok == status
        assert is_list decks
    end

    test "select all decks user with no decks" do
        { status, msg } = selectAllByUser 99
        assert :ok == status
        assert :no_data == msg
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
end