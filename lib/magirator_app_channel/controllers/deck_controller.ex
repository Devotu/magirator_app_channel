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

    case deck_changeset.valid? do
      :true ->
        insert apply_changes( deck_changeset ), user_id
      _ -> 
        { :error, :invalid_data }
    end

  end

end