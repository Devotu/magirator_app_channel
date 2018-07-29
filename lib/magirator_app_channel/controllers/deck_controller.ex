defmodule MagiratorAppChannel.DeckController do

  import MagiratorAppChannel.DeckStore
  alias MagiratorAppChannel.Deck
  import Ecto.Changeset

  def doAction( action, data ) do

    _doAction( action, data )
  end

  defp _doAction( "create", packet ) do

    user_id = packet.user_id
    deck_changeset = Deck.changeset( %Deck{ }, packet.data_in )

    if deck_changeset.valid? do
      apply_changes( deck_changeset )
      |> insert( user_id )
      |> return_id
    else
        { :error, :invalid_data }
    end

  end

  defp return_id( { :ok, id } ) do
    { :ok, %{ id: id } }
  end

  defp return_id( { :error, msg } ) do
    { :error, %{ error: msg } }
  end

end