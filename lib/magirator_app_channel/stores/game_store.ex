defmodule MagiratorAppChannel.GameStore do
    
  alias Bolt.Sips, as: Bolt
  import Ecto.Changeset
  require Logger

  alias MagiratorAppChannel.Player
  alias MagiratorAppChannel.Deck
  alias MagiratorAppChannel.Result
  alias MagiratorAppChannel.Game
  alias MagiratorAppChannel.GameResultSet
  import MagiratorAppChannel.IdStore

  alias MagiratorAppChannel.Streamliner

  @doc """
  Creates a game node ready to tie the results together
  A full registerd game contains several nodes of which the actual game node is the hub
  """
  def create( game ) do
    
    { :ok, generated_id } = next_id()

    query = """
    MATCH 
      (u:User)-[:Is]->(p:Player) 
      WHERE 
      u.id = #{ game.creator } 
      CREATE 
      (p)-[:Created]->(g:Game { id:#{ generated_id }, created:TIMESTAMP(), conclusion: "#{ game.conclusion }" })
      RETURN g.id as id;
    """
    
    result = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { created_id } = { row["id"] }

    case created_id == generated_id do
      :true ->
        { :ok, created_id }
      :false ->
        { :error, :insert_failure }
    end
  end

  @doc """
  Connects a single result to a given game node
  """
  def add_result( game_id, deck_id, result_cs ) do
    
    { :ok, generated_id } = next_id()
    result_map = Streamliner.changeset_struct_to_map result_cs

    query = """
    MATCH 
      (d:Deck), 
      (g:Game) 
      WHERE 
      d.id = #{ deck_id } 
      AND g.id = #{ game_id } 
      CREATE 
      (d)-[:Got]->
      (r:Result { 
        id: #{ generated_id }, 
        created: TIMESTAMP(), 
        place: #{ result_map.place }, 
        comment: '#{ result_map.comment }',
        confirmed: false
        })
      -[:In]->(g)
      RETURN r.id as id;
    """
    
    result = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { created_id } = { row["id"] }

    case created_id == generated_id do
      :true ->
        { :ok, created_id }
      :false ->
        { :error, :insert_failure }
    end
  end

  def confirm_result( result_id ) do

    query = """
    MATCH 
      (r:Result)
      WHERE 
        r.id = #{ result_id } 
      SET
        r.confirmed = true
      RETURN r.id as id;
    """
    
    result = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { updated_id } = { row["id"] }

    case updated_id == result_id do
      :true ->
        { :ok, updated_id }
      :false ->
        { :error, :update_failure }
    end
  end

  def comment_result( result_id, result_comment ) do

    query = """
    MATCH 
      (r:Result)
      WHERE 
        r.id = #{ result_id } 
      SET
        r.comment = '#{ result_comment }' 
      RETURN r.id as id;
    """
    
    result = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { updated_id } = { row["id"] }

    case updated_id == result_id do
      :true ->
        { :ok, updated_id }
      :false ->
        { :error, :update_failure }
    end
  end

  def select_all_by_deck( deck_id ) do

    query = """
    MATCH 
      (d:Deck)
      -[:Got]->
      (:Result)
      -[:In]->
      (g:Game) 
    WHERE 
      d.id = #{ deck_id } 
    WITH 
      g 
    MATCH 
      (g)
      <-[:In]-
      (r:Result)
      <-[:Got]-
      (d:Deck)
      <-[:Possess]-
      (p:Player), 
      (p)
      -[:Currently]->
      (pd:Data),
      (d)
      -[:Currently]->
      (dd:Data)  
    RETURN 
      g,d,p,r,pd,dd
    """
    
    result = Bolt.query!(Bolt.conn, query)

    gamesets =
      result
      |> nodes_to_result_sets
      |> group_results_by_game
      |> exctract_associated( deck_id )

    { :ok, gamesets }
  end


  defp nodes_to_result_sets( nodes ) do
    Enum.map( 
      nodes, 
      &node_to_result_map/1 
    )
  end

  defp node_to_result_map( node ) do
    node_to_result_set( node )
    |> Map.from_struct
  end

  defp node_to_result_set( node ) do

    player_data = Map.merge( node["p"].properties, node["pd"].properties )
    player_changeset = Player.changeset( %Player{}, player_data )

    deck_data = Map.merge( node["d"].properties, node["dd"].properties )
    deck_changeset = Deck.changeset( %Deck{}, deck_data )

    result_data = node["r"].properties
    result_changeset = Result.changeset( %Result{}, result_data )

    game_data =node["g"].properties
    game_changeset = Game.changeset( %Game{}, game_data )

    if player_changeset.valid? and deck_changeset.valid? and result_changeset.valid? and game_changeset.valid?  do

      player_map = apply_to_map player_changeset
      deck_map = apply_to_map deck_changeset
      result_map = apply_to_map result_changeset
      game_map = apply_to_map game_changeset

      %GameResultSet{ player: player_map, deck: deck_map, result: result_map, game: game_map }
    else
      { :error, :invalid_data }
    end
  end

  defp apply_to_map( changeset ) do
    changeset
    |> apply_changes 
    |> Streamliner.changeset_struct_to_map
  end

  defp group_results_by_game( result_sets ) do
    Enum.group_by( 
      result_sets,
      &(&1.game) 
    )
    |> Enum.to_list
    |> Enum.map( 
      fn({g,rs}) -> %{
        :game => g, 
        :results => rs
      } end 
    )
  end

  defp exctract_associated( game_result_sets, deck_id ) do
    Enum.map( 
      game_result_sets, 
      fn grs -> %{
        :game => grs.game,
        :associated => filter_deck_associated( grs.results, deck_id ),
        :opponents => filter_deck_opponents( grs.results, deck_id )
      } end
    )
  end

  defp filter_deck_associated( results, deck_id ) do
    Enum.find( 
      results,
      fn r -> 
        r.deck.id == deck_id 
      end
    )
  end

  defp filter_deck_opponents( results, deck_id ) do
    Enum.filter( 
      results,
      fn r -> 
        r.deck.id != deck_id 
      end
    )
  end
end