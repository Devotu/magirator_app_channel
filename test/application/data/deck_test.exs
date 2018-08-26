defmodule DeckTest do
    use ExUnit.Case

    alias MagiratorAppChannel.Deck

    test "new deck" do
        deck = %Deck{ name: "namz", theme: "themz"}
        assert "namz" == deck.name
    end

    test "new deck changeset" do        
        dc = Deck.changeset( %Deck{ }, %{
            "black" => true, 
            "blue" => true, 
            "budget" => 0, 
            "colorless" => false, 
            "format" => "Standard", 
            "green" => false, 
            "name" => "New deck changeset", 
            "red" => true, 
            "theme" => "Deck", 
            "white" => false, 
            "worth" => 0
        } )
        assert dc.valid?
    end

    test "new deck empty changeset" do        
        dc = Deck.changeset( %Deck{ }, %{ } )
        assert !dc.valid?
    end
end