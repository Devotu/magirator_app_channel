defmodule MagiratorAppChannel.Deck do
    use Ecto.Schema
    import Ecto.Changeset

    schema "deck" do
        field :name, :string
        field :theme, :string
        field :format, :string
        field :black, :boolean
        field :white, :boolean
        field :red, :boolean
        field :green, :boolean
        field :blue, :boolean
        field :colorless, :boolean
        field :budget, :float
        field :worth, :float
        field :created, :integer
    end

    def changeset( deck, params \\%{} ) do
        deck
        |> cast(params, [:id, :name, :theme, :format, :black, :white, :red, :green, :blue, :colorless, :budget, :worth, :created])
        |> validate_required([:name, :theme, :format, :black, :white, :red, :green, :blue, :colorless])
    end

end