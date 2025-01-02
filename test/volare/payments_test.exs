defmodule Volare.PaymentsTest do
  use Volare.DataCase

  alias Volare.Payments

  describe "session_tokens" do
    alias Volare.Payments.SessionToken

    import Volare.PaymentsFixtures

    @invalid_attrs %{token: nil}

    test "list_session_tokens/0 returns all session_tokens" do
      session_token = session_token_fixture()
      assert Payments.list_session_tokens() == [session_token]
    end

    test "get_session_token!/1 returns the session_token with given id" do
      session_token = session_token_fixture()
      assert Payments.get_session_token!(session_token.id) == session_token
    end

    test "create_session_token/1 with valid data creates a session_token" do
      valid_attrs = %{token: "some token"}

      assert {:ok, %SessionToken{} = session_token} = Payments.create_session_token(valid_attrs)
      assert session_token.token == "some token"
    end

    test "create_session_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_session_token(@invalid_attrs)
    end

    test "update_session_token/2 with valid data updates the session_token" do
      session_token = session_token_fixture()
      update_attrs = %{token: "some updated token"}

      assert {:ok, %SessionToken{} = session_token} = Payments.update_session_token(session_token, update_attrs)
      assert session_token.token == "some updated token"
    end

    test "update_session_token/2 with invalid data returns error changeset" do
      session_token = session_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_session_token(session_token, @invalid_attrs)
      assert session_token == Payments.get_session_token!(session_token.id)
    end

    test "delete_session_token/1 deletes the session_token" do
      session_token = session_token_fixture()
      assert {:ok, %SessionToken{}} = Payments.delete_session_token(session_token)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_session_token!(session_token.id) end
    end

    test "change_session_token/1 returns a session_token changeset" do
      session_token = session_token_fixture()
      assert %Ecto.Changeset{} = Payments.change_session_token(session_token)
    end
  end
end
