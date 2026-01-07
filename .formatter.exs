[
  import_deps: [
    :ash_postgres,
    :ash_graphql,
    :absinthe,
    :ash,
    :reactor,
    :ecto,
    :ecto_sql,
    :phoenix
  ],
  subdirectories: ["priv/*/migrations"],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"],
  plugins: [Absinthe.Formatter, Spark.Formatter]
]
