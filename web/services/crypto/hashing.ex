defmodule Playdays.Crypto.Hashing do
  defdelegate call(plain_text), to: Playdays.Crypto, as: :sha256
end
