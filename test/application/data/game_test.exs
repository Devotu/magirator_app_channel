defmodule GameTest do
  use ExUnit.Case

  alias MagiratorAppChannel.Game

  test "new game" do
      game = %Game{ conclusion: "VICTORY", created: System.system_time(:seconds), creator: 1}
      assert "VICTORY" == game.conclusion
  end

  test "new game changeset" do        
      gc = Game.changeset( %Game{}, %{
          "conclusion" => "VICTORY", 
          "created" => System.system_time(:seconds), 
          "creator" => 1
      } )
      assert gc.valid?
  end

  test "new game empty changeset" do        
      gc = Game.changeset( %Game{}, %{} )
      assert !gc.valid?
  end
end