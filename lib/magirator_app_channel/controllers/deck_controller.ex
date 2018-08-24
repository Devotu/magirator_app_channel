defmodule MagiratorAppChannel.DeckController do

  import Ecto.Changeset
  import MagiratorAppChannel.DeckStore
  alias MagiratorAppChannel.Deck
  alias MagiratorAppChannel.Streamliner
  require Logger

  def doAction( action, data ) do

    _doAction( action, data )
  end

  defp _doAction( "create", routing_packet ) do

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

  defp _doAction( "list", routing_packet) do
    
    { :ok, store_result } = selectAllByUser routing_packet.user_id

    { :data, Streamliner.changesetStructListToMapList store_result }
  end

  defp _doAction( action, _ ) do

    Logger.debug "No such action: #{action}"
    { :error, :no_such_action }
  end

  defp return_id( { :ok, id } ) do
    { :ok, %{ id: id } }
  end

  defp return_id( { :error, msg } ) do
    { :error, %{ error: msg } }
  end

end