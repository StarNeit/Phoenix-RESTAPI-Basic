defmodule Playdays.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Playdays.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import Playdays.Router.Helpers

      import Playdays.Factory

      # The default endpoint for testing
      @endpoint Playdays.Endpoint

      defp put_auth_token(conn, auth_token) do
        conn |> put_req_header("x-auth-token", auth_token)
      end

      defp assert_status(conn, expected_status) do
        assert conn.status == expected_status
      end

    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Playdays.Repo)

    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end
