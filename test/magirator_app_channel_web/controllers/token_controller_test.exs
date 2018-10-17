defmodule MagiratorAppChannelWeb.TokenControllerTest do
  use MagiratorAppChannelWeb.ConnCase

  test "GET /api/token/:user/:pwd", %{conn: conn} do
    conn = get conn, "/api/token/Bertil/Hemligt"
    assert json_response(conn, 200)
  end
end
