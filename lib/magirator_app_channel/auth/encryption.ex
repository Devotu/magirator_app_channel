defmodule MagiratorAppChannel.Encryption do
    @chars "ABCDFGHIJKLMNOOPQRSTUVWXYZ123456789"
  
    def random_string_of_length(length) do
        chars = String.codepoints(@chars)
            Enum.reduce((1..length), [], fn (_i, acc) ->
                [Enum.random(chars) | acc]
            end) 
        |> Enum.join("")
    end
end