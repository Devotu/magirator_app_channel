defmodule MagiratorAppChannel.DeckController do

  import MagiratorAppChannel.DeckStore
  alias MagiratorAppChannel.Deck
  import Ecto.Changeset

  def doAction( action, data ) do

    _doAction( action, data )
  end

  defp _doAction( "create", routing_packet ) do

    user_id = routing_packet.user_id

    case routing_packet.data_in do
      nil ->
        deck_changeset = nil
      _ ->
        deck_changeset = Deck.changeset( %Deck{ }, routing_packet.data_in )
    end
    
    if deck_changeset != nil && deck_changeset.valid? do
      apply_changes( deck_changeset )
      |> insert( user_id )
      |> return_id
    else
        { :error, :invalid_data }
    end

  end

  defp _doAction( _, routing_packet ) do

    { :error, :no_such_action }
  end

  defp return_id( { :ok, id } ) do
    { :ok, %{ id: id } }
  end

  defp return_id( { :error, msg } ) do
    { :error, %{ error: msg } }
  end

end