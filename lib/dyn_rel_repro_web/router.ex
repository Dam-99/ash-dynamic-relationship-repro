defmodule DynRelReproWeb.Router do
  use DynRelReproWeb, :router

  pipeline :graphql do
    plug AshGraphql.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/gql" do
    pipe_through [:graphql]

    forward "/playground", Absinthe.Plug.GraphiQL,
      schema: Module.concat(["DynRelReproWeb.GraphqlSchema"]),
      socket: Module.concat(["DynRelReproWeb.GraphqlSocket"]),
      interface: :simple

    forward "/", Absinthe.Plug, schema: Module.concat(["DynRelReproWeb.GraphqlSchema"])
  end

  scope "/api", DynRelReproWeb do
    pipe_through :api
  end
end
