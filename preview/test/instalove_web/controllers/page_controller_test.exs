defmodule PreviewWeb.PageControllerTest do
  use PreviewWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Podlove"
  end
end
