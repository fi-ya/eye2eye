defmodule Eye2eye.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :image_url, :string
      add :price, :decimal, precision: 15, scale: 2, null: false

      timestamps()
    end
  end
end
