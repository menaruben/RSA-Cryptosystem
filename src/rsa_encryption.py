from math import gcd

def get_euler_totient(p: int, q: int):
    return (p-1)*(q-1)

def is_prime(n):
    for i in range(2,int(n/2)):
        if (n%i) == 0:
            return False
    return True

def get_primes(ceiling: int):
    primes = []
    for num in range(2, ceiling):
        if is_prime(num):
            primes.append(num)

    return primes

def get_public_exponent(euler_totient: int):
    primes = get_primes(euler_totient)
    for index in range(len(primes)-1, 1, -1):
        if gcd(primes[index], euler_totient) == 1:
            return primes[index]

def get_private_exponent(ceiling: int, public_exponent: int, euler_totient: int):
    for num in range(ceiling, 0, -1):
        if ((public_exponent * num) %euler_totient) == 1:
            return num

def encrypt_msg(message: str, public_key: list):
    encrypted_message = []
    for char in message:
        encrypted_char = (int(ord(char))**public_key[0]) %public_key[1]
        encrypted_message.append(encrypted_char)

    return encrypted_message

def decrypt_msg(encrypted_message: list, private_key: list):
    decrypted_chars = []
    for encrypted_char in encrypted_message:
        char_ascii = (encrypted_char**private_key[0]) %private_key[1]
        decrypted_chars.append(chr(char_ascii))

    return ''.join(decrypted_chars)

if __name__ == "__main__":
    num_p = 223
    num_q = 229
    num_product = num_p * num_q

    euler_totient = get_euler_totient(num_p, num_q)
    public_exp = get_public_exponent(euler_totient)
    private_exp = get_private_exponent(ceiling=1_000_000, public_exponent=public_exp, euler_totient=euler_totient)

    public_key = [public_exp, num_product]
    private_key = [private_exp, num_product]
    print(public_key, private_key)

    encr_message = encrypt_msg(message="Hello World!", public_key=public_key)
    decr_message = decrypt_msg(encrypted_message=encr_message, private_key=private_key)
    print(decr_message)
