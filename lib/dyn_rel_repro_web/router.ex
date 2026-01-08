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

    forward "/", Absinthe.Plug, schema: DynRelReproWeb.GraphqlSchema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: DynRelReproWeb.GraphqlSchema,
    socket: DynRelReproWeb.GraphqlSocket,
    interface: :playground

  scope "/api", DynRelReproWeb do
    pipe_through :api
  end
end
