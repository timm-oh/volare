defmodule VolareWeb.SessionTokenLiveTest do
  use VolareWeb.ConnCase

  import Phoenix.LiveViewTest
  import Volare.PaymentsFixtures

  @create_attrs %{token: "some token"}
  @update_attrs %{token: "some updated token"}
  @invalid_attrs %{token: nil}

  defp create_session_token(_) do
    session_token = session_token_fixture()
    %{session_token: session_token}
  end

  describe "Index" do
    setup [:create_session_token]

    test "lists all session_tokens", %{conn: conn, session_token: session_token} do
      {:ok, _index_live, html} = live(conn, ~p"/session_tokens")

      assert html =~ "Listing Session tokens"
      assert html =~ session_token.token
    end

    test "saves new session_token", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/session_tokens")

      assert index_live |> element("a", "New Session token") |> render_click() =~
               "New Session token"

      assert_patch(index_live, ~p"/session_tokens/new")

      assert index_live
             |> form("#session_token-form", session_token: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#session_token-form", session_token: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/session_tokens")

      html = render(index_live)
      assert html =~ "Session token created successfully"
      assert html =~ "some token"
    end

    test "updates session_token in listing", %{conn: conn, session_token: session_token} do
      {:ok, index_live, _html} = live(conn, ~p"/session_tokens")

      assert index_live |> element("#session_tokens-#{session_token.id} a", "Edit") |> render_click() =~
               "Edit Session token"

      assert_patch(index_live, ~p"/session_tokens/#{session_token}/edit")

      assert index_live
             |> form("#session_token-form", session_token: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#session_token-form", session_token: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/session_tokens")

      html = render(index_live)
      assert html =~ "Session token updated successfully"
      assert html =~ "some updated token"
    end

    test "deletes session_token in listing", %{conn: conn, session_token: session_token} do
      {:ok, index_live, _html} = live(conn, ~p"/session_tokens")

      assert index_live |> element("#session_tokens-#{session_token.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#session_tokens-#{session_token.id}")
    end
  end

  describe "Show" do
    setup [:create_session_token]

    test "displays session_token", %{conn: conn, session_token: session_token} do
      {:ok, _show_live, html} = live(conn, ~p"/session_tokens/#{session_token}")

      assert html =~ "Show Session token"
      assert html =~ session_token.token
    end

    test "updates session_token within modal", %{conn: conn, session_token: session_token} do
      {:ok, show_live, _html} = live(conn, ~p"/session_tokens/#{session_token}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Session token"

      assert_patch(show_live, ~p"/session_tokens/#{session_token}/show/edit")

      assert show_live
             |> form("#session_token-form", session_token: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#session_token-form", session_token: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/session_tokens/#{session_token}")

      html = render(show_live)
      assert html =~ "Session token updated successfully"
      assert html =~ "some updated token"
    end
  end
end
