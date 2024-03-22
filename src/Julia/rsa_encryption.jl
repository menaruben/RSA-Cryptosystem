using Primes

function get_euler_totient(p::Integer, q::Integer)
    return (p-1)*(q-1)
end

function get_public_exp(euler_totient::Integer)
    euler_totient_primes = primes(euler_totient-1)
    for prime in reverse(euler_totient_primes)
        if gcd(prime, euler_totient) == 1
            return prime
        end
    end
end

function get_private_exp(ceiling::Integer, public_exp::Integer, euler_totient::Integer)
    for num in reverse(1:ceiling)
        if ((public_exp*num) %euler_totient) == 1
            return num
        end
    end
end

function encrypt_msg(message::String, public_key::Array)
    encr_msg = []
    for char in message
        encr_char = modpow(Int(char), public_key[1], public_key[2])
        append!(encr_msg, encr_char)
    end

    return encr_msg
end

function decrypt_msg(encrypted_message::Vector{Any}, private_key::Array)
    decr_chars = []
    for num in encrypted_message
        char_value = modpow(num, private_key[1], private_key[2])
        char_ascii = Char(char_value)
        append!(decr_chars, char_ascii)
    end

    decr_message = join(decr_chars, "")
    return decr_message
end

function modpow(base::Integer, exp::Integer, mod::Integer)
    result = 1
    base = base % mod
    while exp > 0
        if isodd(exp)
            result = (result * base) % mod
        end
        exp = exp >> 1
        base = (base * base) % mod
    end
    return result
end

num_q = 223
num_p = 229
num_product = num_p * num_q

euler_totient = get_euler_totient(num_p, num_q)
public_exp = get_public_exp(euler_totient)
private_exp = get_private_exp(1000000, public_exp, euler_totient)

public_key = [public_exp, num_product]
private_key = [private_exp, num_product]
#println(public_key, private_key)

message = "Hello World!"
encr_msg = encrypt_msg(message, public_key)
decr_msg = decrypt_msg(encr_msg, private_key)
#println(encr_msg)
println(decr_msg)

