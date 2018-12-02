defmodule MagiratorAppChannel.Game do
    use Ecto.Schema
    import Ecto.Changeset

    schema "game" do
        field :conclusion, :string
        field :created, :integer
        field :creator, :integer
    end

    def changeset( game, params \\%{} ) do
        game
        |> cast(params, [:id, :conclusion, :created, :creator])
        |> validate_required([:conclusion])
    end

end