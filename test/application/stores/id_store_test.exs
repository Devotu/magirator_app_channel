defmodule IdStoreTest do
    use ExUnit.Case
    
    import MagiratorAppChannel.IdStore

    test "get new id" do
        { :ok, nr1 } = next
        { :ok, nr2 } = next
        assert 1 == nr2 - nr1
    end
end