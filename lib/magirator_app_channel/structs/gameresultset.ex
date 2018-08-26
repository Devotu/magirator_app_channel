defmodule MagiratorAppChannel.GameResultSet do
    alias MagiratorAppChannel.Player
    alias MagiratorAppChannel.Deck
    alias MagiratorAppChannel.Result
    alias MagiratorAppChannel.Game
    
    # defstruct game_id: 0, hash: "", results: [ %{ player: %Player{}, deck: %Deck{}, result: %Result{} } ]

    defstruct game: %Game{}, player: %Player{}, deck: %Deck{}, result: %Result{}
end