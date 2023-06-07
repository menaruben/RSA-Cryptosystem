defmodule Rsa do
  def get_euler_totient(p, q) do
    (p - 1) * (q - 1)
  end

  def get_public_exponent(euler_totient) do
    range = 1..euler_totient

    possible_pub_exps =
      Enum.filter(range, fn x -> Integer.gcd(x, euler_totient) == 1 and Prime.test(x) end)

    length = Enum.count(possible_pub_exps)
    pub_exp = Enum.at(possible_pub_exps, length - 1)
    pub_exp
  end

  def get_private_exponent(ceiling, pub_exp, euler_totient) do
    range = 1..ceiling

    possible_private_exps = Enum.filter(range, fn x -> rem(pub_exp * x, euler_totient) == 1 end)
    length = Enum.count(possible_private_exps)
    private_exp = Enum.at(possible_private_exps, length - 1)
    private_exp
  end

  def modpow(base, exp, modulus), do: modpow_recursive(base, exp, modulus, 1)
  defp modpow_recursive(_, 0, _, result), do: result

  defp modpow_recursive(base, exp, modulus, result) do
    if rem(exp, 2) == 1 do
      new_result = rem(result * base, modulus)
      modpow_recursive(rem(base * base, modulus), div(exp, 2), modulus, new_result)
    else
      modpow_recursive(rem(base * base, modulus), div(exp, 2), modulus, result)
    end
  end

  def encrypt_msg(message, public_key) do
    ascii_codes = message |> to_charlist()

    encr_chars =
      Enum.map(ascii_codes, fn ch ->
        modpow(ch, Enum.at(public_key, 0), Enum.at(public_key, 1))
      end)

    encr_chars
  end

  def decrypt_msg(encr_chars, private_key) do
    decr_ascii_codes =
      Enum.map(encr_chars, fn ch ->
        modpow(ch, Enum.at(private_key, 0), Enum.at(private_key, 1))
      end)

    List.to_string(decr_ascii_codes)
  end
end

defmodule Main do
  def main do
    IO.puts("Starting RSA encryption...")
    num_p = 223
    num_q = 229
    num_product = num_p * num_q

    euler_totient = Rsa.get_euler_totient(num_p, num_q)
    pub_exp = Rsa.get_public_exponent(euler_totient)
    private_exp = Rsa.get_private_exponent(1_000_000, pub_exp, euler_totient)

    public_key = [pub_exp, num_product]
    private_key = [private_exp, num_product]

    message = "Hello World!"
    encr_chars = Rsa.encrypt_msg(message, public_key)
    decr_msg = Rsa.decrypt_msg(encr_chars, private_key)
    IO.puts(decr_msg)
  end
end

Main.main()
