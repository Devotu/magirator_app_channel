defmodule DeckTest do
    use ExUnit.Case

    alias MagiratorAppChannel.Deck

    test "new deck" do
        deck = %Deck{ name: "namz", theme: "themz"}
        assert "namz" == deck.name
    end

    test "new deck changeset" do        
        dc = Deck.changeset( %Deck{ }, %{ name: "deck1", theme: "test" } )
        assert dc.valid?
    end

    test "new deck empty changeset" do        
        dc = Deck.changeset( %Deck{ }, %{ } )
        assert !dc.valid?
    end
end