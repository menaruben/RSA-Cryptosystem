from math import gcd

def get_euler_totient(p: int, q: int):
    return (p-1)*(q-1)

def is_prime(n):
    for i in range(2,int(n/2)):
        if (n%i) == 0:
            return False
    return True

def get_nearest_smaller_prime(n: int):
    for num in range(n-1, 1, -1):
        if is_prime(num):
            return num

def get_public_exponent(euler_totient: int):
    return get_nearest_smaller_prime(euler_totient)

def get_bezout_coefficients(a, b):
    if b == 0:
        return 1, 0, a
    x1, y1, gcd = get_bezout_coefficients(b, a % b)
    x, y = y1, x1 - (a // b) * y1
    return x, y, gcd

def get_private_exponent(public_exponent: int, euler_totient: int):
    x, y, gcd = get_bezout_coefficients(public_exponent, euler_totient)
    return x % euler_totient

def encrypt_msg(message: str, public_key: list):
    encrypted_message = []
    for char in message:
        encrypted_char = modpow(int(ord(char)), public_key[0], public_key[1])
        encrypted_message.append(encrypted_char)

    return encrypted_message

def decrypt_msg(encrypted_message: list, private_key: list):
    decrypted_chars = []
    for encrypted_char in encrypted_message:
        char_ascii = modpow(encrypted_char, private_key[0], private_key[1])
        decrypted_chars.append(chr(char_ascii))

    return ''.join(decrypted_chars)

def modpow(base, exponent, modulus):
    result = 1
    while exponent > 0:
        if exponent % 2 == 1:
            result = (result * base) % modulus
        exponent = exponent >> 1
        base = (base * base) % modulus
    return result

if __name__ == "__main__":
    num_p = 223
    num_q = 229
    num_product = num_p * num_q

    euler_totient = get_euler_totient(num_p, num_q)
    public_exp = get_public_exponent(euler_totient)
    private_exp = get_private_exponent(public_exponent=public_exp, euler_totient=euler_totient)

    public_key = [public_exp, num_product]
    private_key = [private_exp, num_product]

    encr_message = encrypt_msg(message="Hello World!", public_key=public_key)
    decr_message = decrypt_msg(encrypted_message=encr_message, private_key=private_key)
    print(decr_message)
