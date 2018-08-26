defmodule MagiratorAppChannel.Player do
    use Ecto.Schema
    import Ecto.Changeset

    schema "player" do
        field :name, :string
        field :created, :integer
    end

    def changeset( player, params \\%{} ) do
        player
        |> cast(params, [:id, :name, :created])
        |> validate_required([:name])
    end

end