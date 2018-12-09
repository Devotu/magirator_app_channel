defmodule GameControllerTest do
  use ExUnit.Case

  import MagiratorAppChannel.GameController
  alias MagiratorAppChannel.RoutingPacket
  
  test "create game" do
      routing_packet = %RoutingPacket{ 
          user_id: 3, 
          data_in: %{
              "decks" => [23,21],
              "comment" => "Created by GameControllerTest.",
              "conclusion" => "victory"
          }
      }
      { status, game_id } = do_action( "create", routing_packet )
      assert :data == status
      assert is_number game_id
  end
  
#   test "create game invalid data" do
#       routing_packet = %RoutingPacket{ 
#           user_id: 1, 
#           data_in: %{
#               "decks" => [21,-1],
#               "conclusion" => "victory"
#           }
#       }
#       { status, msg } = do_action( "create", routing_packet )
#       assert :error == status
#       assert :invalid_data == msg
#   end
end