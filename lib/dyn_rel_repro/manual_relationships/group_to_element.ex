defmodule DynRelRepro.ManualRelationships.GroupToElement do
  use Ash.Resource.ManualRelationship

  alias Ash.Resource.ManualRelationship
  alias DynRelRepro.Domain.Element

  import Ash.Expr

  require Ash.Query
  require IEx

  @impl ManualRelationship
  def load(groups, _opts, %{query: query}) do
    group_id_to_elements =
      Map.new(groups, fn group ->
        included_tags = String.split(group.included_tags, ",")

        filters = Enum.map(included_tags, &selector/1)

        filtered_query =
          Enum.reduce(filters, query, fn filter, q ->
            Ash.Query.filter(q, ^filter)
          end)

        dbg(filtered_query)

        elements = Ash.read!(filtered_query)

        {group.id, elements}
      end)

    {:ok, group_id_to_elements}
  end

  defp selector(included_tag), do: expr(exists(Element, ^included_tag in tags))
end
