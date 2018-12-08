defmodule MagiratorAppChannel.Result do
    use Ecto.Schema
    import Ecto.Changeset

    schema "result" do
        field :place, :integer
        field :comment, :string
        field :created, :integer
        field :confirmed, :boolean
    end

    def changeset( result, params \\%{} ) do
        result
        |> cast(params, [:id, :place, :comment, :created, :confirmed])
        |> validate_required([:place])
    end

end