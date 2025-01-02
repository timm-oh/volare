defmodule Volare.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Volare.Payments` context.
  """

  @doc """
  Generate a session_token.
  """
  def session_token_fixture(attrs \\ %{}) do
    {:ok, session_token} =
      attrs
      |> Enum.into(%{
        token: "some token"
      })
      |> Volare.Payments.create_session_token()

    session_token
  end
end
