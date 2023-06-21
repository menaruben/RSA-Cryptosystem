(defn get-euler-totient[p q]
    (* (+ p -1) (+ q -1))
)

(defn prime?[n]
    (var primebool true)
    (if (< n 2)
        (set primebool false)
    )

    (def ceil (math/trunc (math/sqrt n)))
    (loop [i :range [2 (+ ceil 1)]]
        (if (= (% n i) 0)
            (set primebool false)
        )
    )
    primebool
)

(defn get-primes[ceil]
    (var primes @[])
    (loop [i :range [2 ceil]]
        (if (prime? i)
            (array/push primes i)
        )
    )
    primes
)

(defn get-public-exponent[euler-totient]
    (var public-exp 0)
    (var primes (reverse (get-primes euler-totient)))

    (var i 0)
    (while (= public-exp 0)
        (if (= (math/gcd (get primes 0) euler-totient) 1)
            (set public-exp (get primes 0))
        )
    )
    public-exp
)

(defn get-private-exponent[ceil pub-exp euler-totient]
    (var private-exp 0)
    (var num ceil)
    (while (= private-exp 0)
        (if (= (% (* pub-exp num) euler-totient) 1)
            (set private-exp num)
        )
        (-- num)
    )
    private-exp
)

# modular exponentiation algorithm
(defn modpow[base exponent modulus]
    (var result 1)
    (var exp exponent)
    (var b base)

    (var b (% b modulus))

    (while (> exp 0)
        (if (= (% exp 2) 1)
            (set result (% (* result b) modulus))
        )
        (set exp (brshift exp 1))
        (set b (% (math/pow b 2) modulus))
    )
    result
)

(defn encrypt-msg[message public-key]
    (var encrypted-message @[])
    (var asciis (string/bytes message))
    (var encr-ch 0)
    (each ascii asciis
        (set encr-ch (modpow ascii (get public-key 0) (get public-key 1)))
        (array/push encrypted-message encr-ch)
    )
    encrypted-message
)

(defn decrypt-msg[encr-msg private-key]
    (var asciis @[])
    (var decr-ch 0)
    (var decr-msg "")

    (each ch encr-msg
        (set decr-ch (modpow ch (get private-key 0) (get private-key 1)))
        (array/push asciis decr-ch)
    )

    (set decr-msg (string/from-bytes (splice asciis)))
    decr-msg
)

(defn main[&]
    (def p 223)
    (def q 229)
    (def num-prod (* p q))

    (def euler-totient (get-euler-totient p q))
    (def public-exp (get-public-exponent euler-totient))
    (def private-exp (get-private-exponent 1e6 public-exp euler-totient))

    (def public-key @[public-exp num-prod])
    (def private-key @[private-exp num-prod])

    (def encr-msg (encrypt-msg "Hello World!" public-key))
    (def decr-msg (decrypt-msg encr-msg private-key))
    (print decr-msg)
)
