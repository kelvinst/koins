# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Koins.Repo.insert!(%Koins.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Koins.Repo
alias Koins.Brokerage.Account
alias Koins.Brokerage.Transaction

a1 = Repo.insert!(%Account{name: "Cash"})
a2 = Repo.insert!(%Account{name: "Bank of Brazil"})

Repo.insert!(%Transaction{account: a1, amount: 100})
Repo.insert!(%Transaction{account: a2, amount: 200})
