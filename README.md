# RSA-Cryptosystem
RSA (Rivest–Shamir–Adleman) is a public-key cryptosystem that is widely used for secure data transmission. It is also one of the oldest. The acronym "RSA" comes from the surnames of Ron Rivest, Adi Shamir and Leonard Adleman, who publicly described the algorithm in 1977.

## the math behind RSA
### 1: define two large prime numbers for p, q
We will define p and q small for our demonstration purposes:

$$ p = 2, q = 7 $$

## 2: calculate product (N) of p,q
$$ N = p \times q = 2 * 7 = 14 $$

## 3: calculate euler totient of N
The euler totient is also known as $\phi(N)$:

$$ \phi(N) = \phi(14) = (p-1) \times (q-1) = 1 * 6 = 6 $$

## 4: calculate e (public exponent)
Now we need to calculate the public exponent such that...

$$ 1 < e < \phi(N); \space gcd(e, \phi(N)-1) = gcd(e, 5) $$

$$ e \in {2, 3, 5} $$

We know that our euler totient has ```gcd``` other than 1 with the numbers 2 and 3. This means that our public exponent will now be defined as e = 5.

The public key now consists of {public exponent, N} = {5, 14}.

## 5: calculate d (private exponent)
Now we must calculate the private exponent such that...

$$ (e \times d) \space mod \space \phi(N) = 1 $$

$$ (5d) \space mod \space 6 = 1 $$

The private key now consists of {private exponent, N}. We could now calculate the private exponent with the [extended euclidean algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm) but for now we will just get the value with the following julia code:
```julia
function get_private_exp(ceiling::Integer, public_exp::Integer, euler_totient::Integer)
    for num in reverse(1:ceiling)
        if ((public_exp*num) %euler_totient) == 1
            return num
        end
    end
end

d = get_private_exp(500, 5, 6)
```
Which will give us the value 497. The private key equals {497, 14}.

## 6: Encrypt message with public key
Let's say you would want to send me message "B" to someone and encrypt the message. The ascii value of 'B' is 66. Now we can encrypt the message using the equation...

$$ C = m^e \space mod \space N $$

...where C is the encrypted message, e is the public exponent and N is the product of the prime numbers.

## 7: Decrypt message with private key
In order to decrypt the message we can use the equation...

$$ M = C^d \space mod \space N $$

...where M is the ascii value of our character we sent as a message, C is the new value our encrypted message holds, d is the private exponent and N is the product of the prime numbers.
