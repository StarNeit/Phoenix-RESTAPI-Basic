  defmodule Playdays.Api.V1.Admin.CategoryControllerTest do
  use Playdays.ConnCase, async: false

  import Playdays.Utils.MapUtils


  setup do
    admin = create(:admin)
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-auth-token", admin.authentication_token)

    categories = create_list(3, :category)
    category = hd categories
    {:ok, conn: conn, categories: categories, category: category}
  end


  test "list all categories", %{conn: conn} do
    conn = get conn, api_v1_admin_category_path(conn, :index)

    categories = conn.assigns.categories

    expected_data = Enum.map(categories, fn(category) ->
                      %{
                        id: category.id,
                        title: category.title,
                        hex_color_code: category.hex_color_code,
                        image: category.image
                      }
                    end)

    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

  test "show a category", %{conn: conn, category: category} do
    conn = get(conn, api_v1_admin_category_path(conn, :show, category))

    expected_data = %{
                      id: category.id,
                      title: category.title,
                      hex_color_code: category.hex_color_code,
                      image: category.image,
                    }
    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

end
