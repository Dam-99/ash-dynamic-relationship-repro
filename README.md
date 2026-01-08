# DynRelRepro

## Description of the problem

I was trying to add relay pagination on a manual relationship, and I encountered problems.
First things first, the reason we've been using a manual relationship in the first place:
the relationship is built dynamically when requested, by taking an attribute on the source
and creating an ash expression out of it to filter the destination resource.
I started with adding the `paginate_relationship_with :relay` option in the `graphql` block
like we did for all other relationships. For this, AshPostgres errors while using the
application, asking to implement the `ash_postgres_subquery/4` callback. I thought "no problem,
i'll just check the docs and see what it needs", but the documentation on manual relationships
for AshPostgres are lackluster: https://hexdocs.pm/ash_postgres/2.6.23/manual-relationships.html
or https://hexdocs.pm/ash_postgres/2.6.23/AshPostgres.ManualRelationship.html, the best is
a short description of the arguments (which I only really understood after diving into the
Ecto docs for a while), but no real explanation about what either this or the other
callback (`ash_postgres_join/6`) are used for or what they should return.
I tried to hack something together, but without context nothing really worked. I then
noticed that Ash's documentation for manual relationships (https://hexdocs.pm/ash/3.7.6/relationships.html#manual-relationships)
actually suggests to try and avoid using them if possible, preferring instead the
`no_attributes? true` flag and filters. From this I came up with two possible solutions
that I tried, both without success.

The first solution was to store the computed Ash expression on a different attribute
everytime the original is updated: just to test things out I created a new Type, (tried
both `subtype_of: :map` and `subtype_of: :struct`, couldn't really get it to compile),
and used this as the type of the attribute; I created a `Ash.Relationship.Change` to
execute the computation, and added it to all the relevant actions. To make it be
recorded in the data layer, I had to derive the `Jason.Decoder` protocol on a bunch of
Ash's structs, but the result was that not all the metadata was stored, making it
impossible to read from the database.
The second solution I thought of was instead to use a calculation, and use that in
the filter of the relationship. In this case a was a bit more successful, but still
wouldn't work: I assigned it the same type as above, and it asked me to implement
the `expression/2` callback, which also doesn't really have great documentation on
what specifically it should return, so I tried to build the expression I would expect
by extracting the source records from the context and then executing the same computation
as in the `calculate/3` callback; it resulted in a error in the data layer, where
postgres was trying to coerce a boolean into a jsonb object or the other way around.

What I'd like to know: is there an easy way to achieve relay pagination on a manual
relationship of this kind? Is it something that could be realistically automated by Ash,
at least the AshPostgres callbacks, in the future? Is there maybe a better way to relate
records dynamically than what we are doing that'd make things easier?

Anyway, sorry for the wall of text.

## How to test it out

You can use the GraphQL playground at [localhost:4000/graphiql](http://localhost:4000/graphiql)
to run queries and mutations. Make sure that you have a Postgres instance running
on port `5432`.
Create some `Element`s and some `Group`s resources with the `createElement` and `createGroup` mutations.
The `elements` and `groups` queries will allow you to see the appearance of the issue:
in the `main` branch, everything should work, but on the `relationship-relay-pagination`
branch, you will see the error described above pop up.

## Phoenix related stuff:

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
