defmodule DynRelRepro.ManualRelationships.ElementToGroup do
  use Ash.Resource.ManualRelationship

  alias DynRelRepro.Domain.Element

  require Ash.Query

  @impl Ash.Resource.ManualRelationship
  def load(elements, _opts, %{query: group_query}) do
    element_ids = Enum.map(elements, & &1.id)

    filtered_elements_query =
      Element
      |> Ash.Query.select([:id])
      |> Ash.Query.filter(id in ^element_ids)

    element_id_to_groups =
      group_query
      |> Ash.Query.load(elements: filtered_elements_query)
      |> Ash.read!()
      |> Enum.flat_map(&Enum.map(&1.elements, fn element -> {element.id, &1} end))
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Map.new()
      |> Map.take(element_ids)

    {:ok, element_id_to_groups}
  end
end
