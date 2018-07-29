defmodule IdStoreTest do
    use ExUnit.Case
    
    import MagiratorAppChannel.IdStore

    test "get new id" do
        { :ok, nr1 } = nextId()
        { :ok, nr2 } = nextId()
        assert 1 == nr2 - nr1
    end
end