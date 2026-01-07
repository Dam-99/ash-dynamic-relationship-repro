defmodule Domain do
  use Ash.Domain, otp_app: :dyn_rel_repro, extensions: [AshGraphql.Domain]

  resources do
    resource DynRelRepro.Domain.Element
    resource DynRelRepro.Domain.Group
  end
end
