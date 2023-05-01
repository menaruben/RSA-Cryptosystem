#include <stdio.h>

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

int main() {
    int my_char = (int)'H';
    int my_char2 = (int)'e';
    long long e = 50599;
    long long N = 51067;

    // encryption
    long long C = modpow(my_char, e, N);
    long long C2 = modpow(my_char2, e, N);
    printf("encrypted: %lld, %lld\n", C, C2);

    // decryption
    long long d = 976591;
    long long M = modpow(C, d, N);
    long long M2 = modpow(C2, d, N);
    printf("decrypted: %lld, %lld\n", M, M2);

    return 0;
}
