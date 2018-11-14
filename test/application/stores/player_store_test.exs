defmodule PlayerStoreTest do
    use ExUnit.Case

    import MagiratorAppChannel.PlayerStore

    alias MagiratorAppChannel.Player


    #Search
    test "search player" do
        { status, data } = search_by_name "Erik"
        assert :ok == status
        assert is_list data
        #TODO atleast one hit
    end

    test "search player lower case" do
        { status, data } = search_by_name "erik"
        assert :ok == status
        assert is_list data
        #TODO atleast one hit
    end

    test "search player not found" do
        { status, data } = search_by_name "Kent"
        assert :ok == status
        assert is_list data #Should be list in any case
    end


    #List
    test "list players" do
        { status, data } = list_all()
        assert :ok == status
        assert is_list data
        assert %Player{} = List.first data
    end
end