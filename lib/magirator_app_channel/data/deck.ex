defmodule MagiratorAppChannel.Deck do
    use Ecto.Schema
    import Ecto.Changeset

    schema "deck" do
        field :name, :string
        field :theme, :string
    end

    def changeset(deck, params \\%{}) do
        deck
        |> cast(params, [:name, :theme])
        |> validate_required([:name, :theme])
    end

end