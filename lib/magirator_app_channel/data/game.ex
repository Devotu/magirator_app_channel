defmodule MagiratorAppChannel.Game do
    use Ecto.Schema
    import Ecto.Changeset

    schema "game" do
        field :end, :string
        field :created, :integer
    end

    def changeset( game, params \\%{} ) do
        game
        |> cast(params, [:id, :end, :created])
        |> validate_required([:end])
    end

end