defmodule Playdays.Services.Admin.Admin.UpdateAdmin do

  alias Playdays.Repo
  alias Playdays.Admin

  def call(admin, admin_params) do
    admin_params = admin_params |> preprocess
    Admin.changeset(admin, admin_params) |> Repo.update
  end

  defp preprocess(admin_params) do
    admin_params =
      admin_params
      |> Enum.reject(&is_nil(elem(&1,1)))
      |> Enum.into(%{})
    if admin_params[:password] do
      admin_params
      |> Map.put(:hashed_password, admin_params.password)
      |> Map.drop([:password])
    else
      admin_params
    end
  end
end
