# RSA-Cryptosystem
RSA (Rivest–Shamir–Adleman) is a public-key cryptosystem that is widely used for secure data transmission. It is also one of the oldest. The acronym "RSA" comes from the surnames of Ron Rivest, Adi Shamir and Leonard Adleman, who publicly described the algorithm in 1977.

## Annotation
All the programs will get optimized with a better prime sieving function. Julia already uses the [sieve of eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) but I will try to find and benchmark prime sieving functions until I find the fastest one. I will then implmenent it into every progam.

## the math behind RSA
### 1: define two large prime numbers for p, q
We will define p and q small for demonstration purposes:

$$ p = 23, q = 29 $$

### 2: calculate product (N) of p,q
$$ N = p \times q = 667 $$

### 3: calculate euler totient of N
The euler totient is also known as $\phi(N)$:

$$ \phi(N) = (p-1) \times (q-1) = 22 \times 28 = 616 $$

### 4: calculate e (public exponent)
Now we need to calculate the public exponent such that...

$$ 1 < e < \phi(N) $$ and $$ \space gcd(e, \phi(N)-1) $$

In order to simplify this calculation I have implemented a function `get-public-exponent` which returns the nearest smaller prime of a number n:
```clojure
(defn prime-rec? [n i ceil]
  (if (> i ceil)
    true
    (if (= 0 (mod n i))
      false
      (recur n (+ i 2) ceil))))

(defn prime? [n]
  (if (= 0 (mod n 2))
    false
    (let [ceil (Math/sqrt n)]
    (prime-rec? n 3 ceil))))

(defn get-euler-totient [p q]
  (* (- p 1) (- q 1)))

(defn get-nearest-smaller-prime-of [n]
  (if (prime? (- n 1))
    (- n 1)
    (get-nearest-smaller-prime-of (- n 1))))

(defn get-public-exponent [euler-totient]
  (get-nearest-smaller-prime-of euler-totient))

(get-public-exponent 616) ;; => 613
```
The public key now consists of `{public-exponent, N} = {613, 667}`.

### 5: calculate d (private exponent)
Now we must calculate the private exponent such that...

$$ (e \times d) \mod \phi(N) = 1 $$

$$ (613d) \mod 616 = 1 $$

It doesn't make any difference how much we multiply the public exponent because any multiple of
it produces the same outcome since the [modular multiplicative inverse](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse) stays the same. Therefore we can remove d from the equation which leaves us with this: $613 \mod 616 = 1$

The private key consists of {private exponent, N}. We now calculate the private exponent using the [extended euclidean algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm). In order to get the private exponent `d` we must calculate the [Bézout coefficients](https://en.wikipedia.org/wiki/B%C3%A9zout%27s_identity).
> Bézout's identity — Let a and b be integers with greatest common divisor d. Then there exist integers x and y such that ax + by = d.

Now don't confuse the variable `d` in the quote with our variable for the private exponent. Let's calculate the private exponent with this equation: $613 \mod 616 = 1$

$$ 616 = 1 * 613 + 3 $$

$$ 613 = 204 * 3 + 1 $$

Now we rearrange the equations above in the following manner (basically resubstitution):

$$ 1 = 1 * 613 - (204 * 3) $$

$$ = 1 * 613 - (204 * (1 * 616 - 1 * 613)) $$

$$ = 1 * 616 - 204 * 616 + 204 * 613 $$

$$ = 205 * 613 - 203 * 616 $$

Now we can see that the private exponent `d` equals 205.

### 6: Encrypt message with public key
Let's say you would want to send me message "B" to someone and encrypt the message. The ascii value of 'B' is 66. Now we can encrypt the message using the equation...

$$ C = m^e \mod N $$

...where C is the encrypted message, e is the public exponent and N is the product of the prime numbers. If you have chosen big prime numbers for p and q this [modular exponentiation](https://en.wikipedia.org/wiki/Modular_exponentiation) could take very long or even lead to an [integer overflow](https://en.wikipedia.org/wiki/Integer_overflow).
> In computer programming, an integer overflow occurs when an arithmetic operation attempts to create a numeric value that is outside of the range that can be represented with a given number of digits – either higher than the maximum or lower than the minimum representable value.

In order to get rid of this we can implement a simple function called `modpow` which uses a simple algorithm to speed up the process and use less memory. Many languages like Java ([modpow in java](https://docs.oracle.com/en/java/javase/19/docs/api/java.base/java/math/BigInteger.html#modPow(java.math.BigInteger,java.math.BigInteger))) already implement such methods.
```clojure
(defn modpow [base exponent modulus]
  (if (= modulus 1)
    0
    (loop [result 1 e 0]
      (if (= e exponent)
        result
        (recur (mod (* result base) modulus) (+ e 1))))))
```
The mainflow of the algorithm is as follows:
1. It checks if the modulus is equal to 1. If it is, the algorithm returns 0.
2. If the modulus is not equal to 1, the algorithm enters a loop.
3. Inside the loop, the algorithm multiplies the result by the base and takes the modulus of the product with the modulus.
4. The algorithm then increments the e (exponent) by 1.
5. The loop continues until the e is equal to the exponent.
6. Once the loop ends, the algorithm returns the final result.

Wikipedia visualized this algorithm very well [here](https://en.wikipedia.org/wiki/Modular_exponentiation):
```
The example base = 4, exponent = 13, and modulus = 497 is presented again. The algorithm performs the iteration thirteen times:
    (e =  1)   result = (4 ⋅ 1) mod 497 = 4 mod 497 = 4
    (e =  2)   result = (4 ⋅ 4) mod 497 = 16 mod 497 = 16
    (e =  3)   result = (4 ⋅ 16) mod 497 = 64 mod 497 = 64
    (e =  4)   result = (4 ⋅ 64) mod 497 = 256 mod 497 = 256
    (e =  5)   result = (4 ⋅ 256) mod 497 = 1024 mod 497 = 30
    (e =  6)   result = (4 ⋅ 30) mod 497 = 120 mod 497 = 120
    (e =  7)   result = (4 ⋅ 120) mod 497 = 480 mod 497 = 480
    (e =  8)   result = (4 ⋅ 480) mod 497 = 1920 mod 497 = 429
    (e =  9)   result = (4 ⋅ 429) mod 497 = 1716 mod 497 = 225
    (e = 10)   result = (4 ⋅ 225) mod 497 = 900 mod 497 = 403
    (e = 11)   result = (4 ⋅ 403) mod 497 = 1612 mod 497 = 121
    (e = 12)   result = (4 ⋅ 121) mod 497 = 484 mod 497 = 484
    (e = 13)   result = (4 ⋅ 484) mod 497 = 1936 mod 497 = 445

The final answer for c is therefore 445
```
With this algorithm you never have to calculate the immediate result of $base^{exponent} \mod modulus$ because we split it into multiple small operations.

After implementing this method we can just use it inside our `encrypt-msg` function:
```clojure
(defn encrypt-msg [msg public-key]
  (def ascii-chars (map int (seq msg)))
  (map #(modpow % (first public-key) (last public-key)) ascii-chars))
```
If we entered "Hello World!" as the function we should now get `(282 427 380 380 451 565 522 451 482 380 4 527)`.

### 7: Decrypt message with private key
In order to decrypt the message we can use the equation...

$$ M = C^d \mod N $$

...where M is the ascii value of our character we sent as a message, C is the new value our encrypted message holds, d is the private exponent and N is the product of the prime numbers.

This uses the exact same `modpow` function mentioned previously. In order to decrypt the message we will have to iterate over every integer of the encrypted message and get back it's old ascii char. Then we can join the characters and form a string:
```clojure
(defn decrypt-msg [msg private-key]
  (apply str (map #(char (modpow % (first private-key) (last private-key))) msg)))
```
