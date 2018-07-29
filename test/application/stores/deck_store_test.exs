defmodule DeckStoreTest do
    use ExUnit.Case

    import MagiratorAppChannel.DeckStore
    alias MagiratorAppChannel.Deck
    import Ecto.Changeset

    test "insert deck" do
        deck_changeset = Deck.changeset( %Deck{ }, %{ name: "DeckStoreTest", theme: "themy"} )
        { status, id } = insert( apply_changes( deck_changeset ), 1 )
        assert :ok == status
        assert is_number id
    end
end