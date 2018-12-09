defmodule MagiratorAppChannel.GameController do

  import Ecto.Changeset
  alias MagiratorAppChannel.GameStore
  alias MagiratorAppChannel.Game
  alias MagiratorAppChannel.Result
  alias MagiratorAppChannel.GameResult
  alias MagiratorAppChannel.Streamliner
  alias MagiratorAppChannel.DeckStore
  alias MagiratorAppChannel.PlayerStore
  import MagiratorAppChannel.GameStore
  require Logger

  def do_action( action, data ) do

    _do_action( action, data )
  end

  defp _do_action( action, nil ) do
    Logger.debug "Nil data suplied to action: #{action}"
    { :error, :no_data }
  end

  defp _do_action( "create", routing_packet ) do

    user_id = routing_packet.user_id

    deck_ids = routing_packet.data_in["decks"]

    #Create a game
    game_changeset = Game.changeset( %Game{}, %{
      "created" => System.system_time(:seconds), 
      "conclusion" => routing_packet.data_in["conclusion"], 
      "creator" => user_id
    })

    game = apply_changes( game_changeset )

    {:ok, game_id} = create( game )

    #Create results
    deck_results = create_deck_results( deck_ids )
    game_deck_results = Enum.map( deck_results, fn {deck_id, result} -> {game_id, deck_id, result} end)
    added_results = Enum.map( game_deck_results, &add_result_to_deck/1 )    

    #Find users own result, comment and confirm
    {:ok, user_deck_id} = DeckStore.pick_user_deck_id( user_id, deck_ids )
    {user_deck_id, user_result_id} = Enum.find(added_results, fn {did, _rid} -> did == 23 end)

    {:ok, updated_id} = comment_result( user_result_id, routing_packet.data_in["comment"] )
    {:ok, updated_id} = confirm_result( user_result_id )

    {:ok, game_id}
  end


  defp create_deck_results( deck_ids ) do
    Enum.with_index( deck_ids, 1 )
    |> Enum.map( &create_deck_result/1)
  end

  defp add_result_to_deck({game_id, deck_id, result}) do
    {status, id_cause} = add_result( game_id, deck_id, result )
    case status do
      :ok ->
        {deck_id, id_cause}
      :error -> 
        {:error, id_cause}
      _ ->
        {:error, :unknown_error}
    end
  end

  defp add_results( results ) do
    Enum.with_index( deck_ids, 1 )
    |> Enum.map( &create_result/1)
  end



  defp create_deck_result( {deck_id, place} ) do

    result = 
    Result.changeset( %Result{}, %{
      "created" => System.system_time(:seconds),
      "place" => place,
      "confirmed" => false
    })
    |> apply_changes

    {deck_id, result}
  end

  defp create_deck_result( {deck_id, place, comment} ) do

    result = 
    Result.changeset( %Result{}, %{
      "created" => System.system_time(:seconds),
      "place" => place,
      "comment" => comment,
      "confirmed" => false
    })
    |> apply_changes

    {deck_id, result}
  end


  defp _do_action( action, _ ) do
    Logger.debug "No such action: #{action}"
    { :error, :no_such_action }
  end
  

  defp return_id( { :ok, id } ) do
    { :ok, %{ id: id } }
  end

  defp return_id( { :error, msg } ) do
    { :error, %{ error: msg } }
  end

end