defmodule MagiratorAppChannel.DeckController do

  import MagiratorAppChannel.DeckStore
  alias MagiratorAppChannel.Deck

  def doAction( action, data ) do

    _doAction( action, data )
  end

  defp _doAction( "create", packet ) do

    deck_changeset = Deck.changeset( %Deck{ }, packet.data_in )

    case deck_changeset.valid? do
      :true ->
        insert deck_changeset
      _ -> 
        {:error, :invalid_data}   
    end

  end

end