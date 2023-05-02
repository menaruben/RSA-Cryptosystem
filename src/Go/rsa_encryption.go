package main

import (
	"fmt"

	p "github.com/fxtlabs/primes"
)

func get_euler_totient(p, q int64) int64 {
	return int64((int(p) - 1) * (int(q) - 1))
}

func get_public_exp(euler_totient int64) int64 {
	var primes []int = p.Sieve(int(euler_totient) - 1)
	for i := len(primes) - 1; i >= 0; i-- {
		if p.Coprime(primes[i], int(euler_totient)) {
			return int64(primes[i])
		}
	}
	return 1
}

func get_private_exp(ceiling int64, public_exp int64, euler_totient int64) int64 {
	for num := ceiling; num > 0; num-- {
		if (public_exp*num)%euler_totient == 1 {
			return num
		}
	}
	return 1
}

// Modular Exponentiation algorithm
func ModPow(base, exponent, modulus int64) int64 {
	result := int64(1)
	base = base % modulus
	for exponent > 0 {
		if exponent%2 == 1 {
			result = (result * base) % modulus
		}
		exponent = exponent >> 1
		base = (base * base) % modulus
	}
	return result
}

func encrypt_msg(message string, public_key []int64) []int64 {
	var encrypted_msg []int64
	var ascii_code int
	var modpow_ascii int64
	for _, char := range message {
		ascii_code = int(char)
		modpow_ascii = ModPow(int64(ascii_code), public_key[0], public_key[1])
		encrypted_msg = append(encrypted_msg, modpow_ascii)
	}
	return encrypted_msg
}

func decrypt_msg(encrypted_msg []int64, private_key []int64) string {
	var ascii_code int
	var decrypted_msg string

	for _, encr_char := range encrypted_msg {
		ascii_code = int(ModPow(int64(encr_char), int64(private_key[0]), int64(private_key[1])))
		decr_char := rune(ascii_code)
		decrypted_msg = decrypted_msg + string(decr_char)
	}
	return decrypted_msg
}

func main() {
	var num_p int64 = 223
	var num_q int64 = 229
	var num_product int64 = num_p * num_q

	var euler_totient int64 = get_euler_totient(num_p, num_q)
	var public_exp int64 = get_public_exp(euler_totient)
	var private_exp int64 = get_private_exp(1_000_000, public_exp, euler_totient)

	public_key := []int64{public_exp, num_product}
	private_key := []int64{private_exp, num_product}
	// fmt.Println(public_key)
	// fmt.Println(private_key)

	var message string = "Hello World!"
	var encr_msg []int64 = encrypt_msg(message, public_key)
	var decr_msg string = decrypt_msg(encr_msg, private_key)

	// fmt.Println(encr_msg)
	fmt.Println(decr_msg)
}
