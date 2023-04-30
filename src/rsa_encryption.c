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
    int* primes = get_primes(20, &size);
    for (int i = size - 1; i >= 0; i--) {
        if (gcd(primes[i], euler_totient) == 1) {
            return primes[i];
        }
    }

    return 0;
}

int get_private_exp(int ceiling, int public_exponent, int euler_totient) {
    for (int num = ceiling; num > 0; num--) {
        if ((public_exponent * num) % euler_totient == 1) {
            return num;
        }
    }
}

int* encrypt_msg(char* message, int* public_key) {
    char* ptr = message;
    int* encr_chars = calloc(strlen(message), sizeof(int));

    int i = 0;
    while (*ptr != '\0') {
        int ascii_code = (int)(*ptr);
        encr_chars[i] = (int)(fmod(pow(ascii_code, public_key[0]), public_key[1]));
        i++;
        ptr++;
    }

    return encr_chars;
}

char* decrypt_msg(int* encrypted_message, int* private_key, int size) {
    char* decrypted_chars = malloc(size + 1); // Allocate memory for the string

    for (int i = 0; i < size; i++) {
        int ascii_code = (int)(fmod(pow(encrypted_message[i], private_key[0]), private_key[1]));
        char ascii_value = (char)(ascii_code);
        decrypted_chars[i] = ascii_value;
    }

    decrypted_chars[size] = '\0'; // Add null terminator at the end of the string
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

    char* message = "Hello World!";
    int* encr_msg = encrypt_msg(message, public_key);
    char* decr_msg = decrypt_msg(encr_msg, private_key, strlen(message));

    printf("%s", decr_msg);

    for (int i = 0; i < strlen(decr_msg); i++) {
        printf("%d\n", encr_msg[i]);
    }

    free(encr_msg); // free memory allocated by malloc/calloc
    free(decr_msg);
    return 0;
}
