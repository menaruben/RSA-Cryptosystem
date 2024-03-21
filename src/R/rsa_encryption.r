library(bit64)
library(gmp)
# bit64::as.integer64!!

get_euler_totient <- function(p, q) {
  bit64::as.integer64((p-1)*(q-1))
}

is_prime <- function(n) {
  if (n<2) {
    return(FALSE)
  }
  
  if (n==2) {
    return(TRUE)
  }
  
  for(i in 2:ceiling(sqrt(n))) {
    if (n %% i == 0) {
      return(FALSE)
    }
  }
  TRUE
}

get_primes <- function(ceil) {
  primes <- c()
  for (i in 2:ceil) {
    if (is_prime(i)) {
      primes <- append(primes, i)
    }
  }
  primes
}

gcd <- function(x,y) {
  r <- x%%y;
  return(ifelse(r, gcd(y, r), y))
}

get_pub_exp <- function(e) {
  primes <- get_primes(e)
  
  for (p in rev(primes)) {
    if (gcd(p, e) == 1) {
      return(p)
    }
  }
}

get_priv_exp <- function(ceil, pub_exp, e) {
  for (num in ceil:1) {
    if ((pub_exp*num) %% e == 1) {
      return(num)
    }
  }
}


modpow <- function(base, exp, modulus) {
  base <- as.bigz(base)
  exp <- as.bigz(pub_key[1])
  modulus <- as.bigz(pub_key[2])
  result <- gmp::powm(base, exp, modulus)
  
  as.numeric(result)
}

#################################################
p <- 223
q <- 229
prod <- p*q

euler_totient <- get_euler_totient(p, q)
public_exp <- get_pub_exp(euler_totient)
private_exp <- get_priv_exp(1e6, public_exp, euler_totient)

public_key <- c(public_exp, prod)
private_key <- c(private_exp, prod)
print(public_key)
print(private_key)

#encr_msg <- encrypt_msg("Hello World!", public_key)
