defmodule DynRelRepro.Domain.Element do
  use Ash.Resource,
    otp_app: :dyn_rel_repro,
    domain: Domain,
    extensions: [AshGraphql.Resource],
    data_layer: AshPostgres.DataLayer

  alias DynRelRepro.ManualRelationships.ElementToGroup

  postgres do
    table "elements"
    repo DynRelRepro.Repo
  end

  graphql do
    type :element
  end

  actions do
    defaults [:read, :destroy, create: [:tags], update: [:tags]]
  end

  attributes do
    uuid_primary_key :id

    attribute :tags, {:array, :string} do
      allow_nil? false
      public? true
    end
  end

  relationships do
    has_many :groups, DynRelRepro.Domain.Group do
      public? true
      writable? false
      manual ElementToGroup
    end
  end
end
