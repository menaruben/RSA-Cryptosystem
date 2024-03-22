def get_euler_totient(p, q)
    return (p-1)*(q-1)
end

def is_prime(n)
    (2..(n/2).floor()).each do |i|
        if n % i == 0
            return false
        end
    end
    return true
end

def get_primes(ceiling)
    primes = []

    (2..ceiling).each do |num|
        if is_prime(num)
            primes.append(num)
        end
    end

    return primes
end

def get_public_exponent(euler_totient)
    primes = get_primes(euler_totient)

    (primes.reverse()).each do |num|
        if num.gcd(euler_totient) == 1
            return num
        end
    end
end

def get_private_exponent(ceiling, public_exp, euler_totient)
    (ceiling).downto(1).each do |num|
        if ((public_exp * num) % euler_totient) == 1
            return num
        end
    end
end

def encrypt_message(message, public_key)
    encr_message = []

    message.each_byte do |ch|
        encr_char = modpow(ch, public_key[0], public_key[1])
        encr_message.append(encr_char)
    end

    return encr_message
end

def decrypt_message(encr_message, private_key)
    decr_chars = []

    encr_message.each do |encr_ch|
        ascii = modpow(encr_ch, private_key[0], private_key[1])
        decr_chars.append(ascii.chr)
    end

    return decr_chars.join()
end

def modpow(base, exp, mod)
    res = 1

    (1..exp).each do |i|
        res = (res * base) % mod
    end

    return res
end

def main()
    num_p = 223
    num_q = 229
    num_product = num_p * num_q

    euler_totient = get_euler_totient(num_p, num_q)
    public_exp = get_public_exponent(euler_totient)
    private_exp = get_private_exponent(1_000_000, public_exp, euler_totient)

    public_key = [public_exp, num_product]
    private_key = [private_exp, num_product]
    # print(public_key, private_key)

    encr_message = encrypt_message("Hello World!", public_key)
    decr_message = decrypt_message(encr_message, private_key)
    print(decr_message)
end

main()
