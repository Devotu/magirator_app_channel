defmodule MagiratorAppChannel.Auth do
    
    def authenticate(user, pwd) do
        case user do
            "Otto" ->
              :ok
            _ ->
              :error
          end
    end
end