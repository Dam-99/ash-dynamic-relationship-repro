defmodule Domain do
  use Ash.Domain, otp_app: :dyn_rel_repro, extensions: [AshGraphql.Domain]

  alias DynRelRepro.Domain.Group
  alias DynRelRepro.Domain.Element

  graphql do
    queries do
      root_level_errors? true

      list Element, :elements, :read do
        description "The elements"
      end

      list Group, :groups, :read do
        description "The groups"
      end
    end

    mutations do
      create Element, :create_element, :create do
        description "Creates an element"
      end

      update Element, :update_element, :update do
        description "Updates an element"
      end

      destroy Element, :destroy_element, :destroy do
        description "Destroys an element"
      end

      create Group, :create_group, :create do
        description "Creates a group"
      end

      update Group, :update_group, :update do
        description "Updates a group"
      end

      destroy Group, :destroy_group, :destroy do
        description "Updates a group"
      end
    end
  end

  resources do
    resource Element
    resource Group
  end
end
