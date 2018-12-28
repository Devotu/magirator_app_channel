defmodule MagiratorAppChannel.GameResultSet do
    alias MagiratorAppChannel.Player
    alias MagiratorAppChannel.Deck
    alias MagiratorAppChannel.Result
    alias MagiratorAppChannel.Game
    
    defstruct game: %Game{}, player: %Player{}, deck: %Deck{}, result: %Result{}
end