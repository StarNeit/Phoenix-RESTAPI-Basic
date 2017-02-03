defmodule Playdays.Services.Admin.Admin.RegisterAdmin do

  alias Playdays.Admin
  alias Playdays.Services.Register

  def call(admin_params) do
    Register.call(admin_params, Admin)
  end

end
