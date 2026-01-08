defmodule DynRelRepro.Domain.Group do
  use Ash.Resource,
    otp_app: :dyn_rel_repro,
    domain: Domain,
    extensions: [AshGraphql.Resource],
    data_layer: AshPostgres.DataLayer

  alias DynRelRepro.ManualRelationships.GroupToElement

  postgres do
    table "groups"
    repo DynRelRepro.Repo
  end

  graphql do
    type :group

    paginate_relationship_with elements: :relay
  end

  actions do
    defaults [:read, :destroy, create: [:included_tags], update: [:included_tags]]
  end

  attributes do
    uuid_primary_key :id

    attribute :included_tags, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    has_many :elements, DynRelRepro.Domain.Element do
      public? true
      writable? false
      manual GroupToElement
    end
  end
end
