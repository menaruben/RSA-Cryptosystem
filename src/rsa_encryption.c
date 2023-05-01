#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int get_euler_totient(int p, int q) {

    return (p-1)*(q-1);
}

typedef enum Bool {false=0, true=1} bool;   //enables boolean functions

bool is_prime(int num) {
    for (int i = 2; i <= (int)floor(sqrt(num)); i++) {
        if ((num % i) == 0)  {
            return false;
        }
    }
    return true;
}

int* get_primes(int ceiling, int* size) {
    int* primes = calloc(ceiling, sizeof(int)); // Initialize to 0

    int i = 0;
    for (int num = 2; num < ceiling; num++) {
        if (is_prime(num)) {
            primes[i] = num;
            i++;
        }
    }

    *size = i;  // Update size of primes array
    return primes;
}

int gcd(int num1, int num2) {
    int gcd;
    for(int i = 1; i <= num1 && i <= num2; ++i)
    {
        // Checks if i is factor of both integers
        if(num1%i==0 && num2%i==0)
            gcd = i;
    }

    return gcd;
}

int get_public_exp(int euler_totient) {
    int size;
    int* primes = get_primes(euler_totient, &size);
    for (int i = size - 1; i >= 0; i--) {
        if (gcd(primes[i], euler_totient) == 1) {
            return primes[i];
        }
    }

    return 0;
}

long long int get_private_exp(long long int ceiling, long long int public_exponent, long long int euler_totient) {
    for (long long int num = ceiling; num > 0; num--) {
        if ((public_exponent * num) % euler_totient == 1) {
            return num;
        }
    }
}

// calculates the result of a^b mod n without computing the intermediate result of a^b
long long modpow(long long base, long long exponent, long long modulus) {
    long long result = 1;
    base = base % modulus;
    while (exponent > 0) {
        if (exponent % 2 == 1) {
            result = (result * base) % modulus;
        }
        exponent = exponent >> 1;
        base = (base * base) % modulus;
    }
    return result;
}

int* encrypt_msg(char* message, int* public_key) {
    int msg_size = strlen(message);
    int* encr_chars = calloc(msg_size, sizeof(int));
    int ascii_code;

    // printf("function encrypt_msg: %s\n", message);

    for (int i = 0; i < msg_size; i++) {
        ascii_code = (int)message[i];
        encr_chars[i] = modpow(ascii_code, public_key[0], public_key[1]);
        // printf("ascii_code: %d\tencr_char: %d\n", ascii_code, encr_chars[i]);
    }

    return encr_chars;
}


char* decrypt_msg(int* encrypted_message, int* private_key, int msg_size) {
    char* decrypted_chars = malloc(msg_size + 1); // Allocate memory for the string

    // printf("function decrypt_msg: private0 %d\t private1 %d\n", private_key[0], private_key[1]);

    for (int i = 0; i < msg_size; i++) {
        int ascii_code = (int)modpow(encrypted_message[i], private_key[0], private_key[1]);
        char ascii_value = (char)ascii_code;
        // printf("function decrypt_msg: \n\t ascii_code %d\n\t char %c\n", ascii_code, ascii_value);
        // printf("------------------------------------------------------------------------------\n");
        decrypted_chars[i] = ascii_value;
    }

    decrypted_chars[msg_size] = '\0'; // Add null terminator at the end of the string
    return decrypted_chars;
}

int main() {

    int num_q = 223;
    int num_p = 229;
    int num_product = num_p * num_q;
    int euler_totient = get_euler_totient(num_p, num_q);
    int public_exp = get_public_exp(euler_totient);
    int private_exp = get_private_exp(1000000, public_exp, euler_totient);
    int public_key[2] = {public_exp, num_product};
    int private_key[2] = {private_exp, num_product};
    // printf("public0: %d\tpublic1: %d\n", public_key[0], public_key[1]);
    // printf("private0: %d\tprivate1: %d\n", private_key[0], private_key[1]);

    char* message = "Hello World!";
    int* encr_msg = encrypt_msg(message, public_key);
    char* decr_msg = decrypt_msg(encr_msg, private_key, strlen(message));
    printf("%s", decr_msg);

    free(encr_msg);
    free(decr_msg);
    return 0;
}
