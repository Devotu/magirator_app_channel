defmodule MagiratorAppChannel.DeckController do

  import Ecto.Changeset
  import MagiratorAppChannel.DeckStore
  alias MagiratorAppChannel.GameStore
  alias MagiratorAppChannel.Deck
  alias MagiratorAppChannel.Streamliner

  def do_action( action, data ) do

    _do_action( action, data )
  end

  defp _do_action( "create", routing_packet ) do

    user_id = routing_packet.user_id

    deck_changeset = 
      case routing_packet.data_in do
        nil ->
          nil
        _ ->
          Deck.changeset( %Deck{ }, routing_packet.data_in )
      end
    
    if deck_changeset != nil && deck_changeset.valid? do
      apply_changes( deck_changeset )
      |> insert( user_id )
      |> return_id
    else
        { :error, :invalid_data }
    end

  end

  defp _do_action( "list", routing_packet) do    
    { :ok, store_result } = select_all_by_player routing_packet.data_in["player_id"]
    { :data, Streamliner.changeset_struct_list_to_map_list store_result }
  end

  defp _do_action( "show", routing_packet) do
    { :ok, store_result } = select_by_id routing_packet.data_in["deck_id"]
    { :data, Streamliner.changeset_struct_to_map store_result }
  end

  defp _do_action( "games", routing_packet) do
    clean_deck_id = String.to_integer routing_packet.data_in["deck_id"]
    { :ok, store_result } = GameStore.select_all_by_deck clean_deck_id
    { :data, store_result }
  end

  defp _do_action( _, _ ) do
    { :error, :no_such_action }
  end

  defp return_id( { :ok, id } ) do
    { :ok, %{ id: id } }
  end

  defp return_id( { :error, msg } ) do
    { :error, %{ error: msg } }
  end

end