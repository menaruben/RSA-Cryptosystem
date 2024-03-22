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

;; quot a b == a//b <=> meaning a/b floored
(defn divmod [a b]
    [(quot a b) (mod a b)])

;; returns the bezout coefficients a and b such that
;; ax + by = gcd(x, y) = 1
(defn get-bezout-coefficients [x y]
    (if (zero? y)
        [1 0]
        (let [[q r] (divmod x y)
        [a b] (get-bezout-coefficients y r)]
            [b (- a (* q b))])))

(defn get-private-exponent [public-exponent euler-totient]
  (let [[a b] (get-bezout-coefficients public-exponent euler-totient)]
    (mod a euler-totient)))

(defn modpow [base exponent modulus]
  (if (= modulus 1)
    0
    (loop [result 1 e 0]
      (if (= e exponent)
        result
        (recur (mod (* result base) modulus) (+ e 1))))))

(defn encrypt-msg [msg public-key]
  (def ascii-chars (map int (seq msg)))
  (map #(modpow % (first public-key) (last public-key)) ascii-chars))

(defn decrypt-msg [msg private-key]
  (apply str (map #(char (modpow % (first private-key) (last private-key))) msg)))

(defn main []
  (def p 23)
  (def q 29)
  (def prod (* p q))
  (def euler-totient (get-euler-totient p q))
  (def public-exponent (get-public-exponent euler-totient))
  (def private-exponent (get-private-exponent public-exponent euler-totient))
  (def message "Hello World!")
  (def public-key [public-exponent prod])
  (def private-key [private-exponent prod])
  (def encrypted-message (encrypt-msg message public-key))
  (def decrypted-message (decrypt-msg encrypted-message private-key))
  (println decrypted-message))

(main)
