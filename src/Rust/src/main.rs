use primal::Primes;
use num::bigint::BigInt;
use num::FromPrimitive;
use std::convert::TryInto;
use num::ToPrimitive;
use chrono::Utc;

fn gcd(mut n: i64, mut m: i64) -> i64 {
    assert!(n != 0 && m != 0);
    while m != 0 {
        if m < n {
            std::mem::swap(&mut m, &mut n);
        }
        m %= n;
    }
    n
}

fn get_euler_totient(p: i64, q: i64) -> i64 {
    return (p - 1) * (q - 1);
}

fn get_primes(end: i64) -> Vec<i64> {
    let start = 2;
    let mut primes = vec![];
    for prime in Primes::all()
        .skip_while(|p| *p < start)
        .take_while(|p| *p < end.try_into().unwrap())
    {
        primes.push(prime.try_into().unwrap());
    }
    return primes;
}

fn get_public_exp(euler_totient: i64) -> i64 {
    let primes = get_primes(euler_totient);
    for prime in primes.iter().rev() {
        if gcd(*prime, euler_totient) == 1 {
            return *prime;
        }
    }
    return 0;
}

fn get_private_exp(ceiling: i64, public_exp: i64, euler_totient: i64) -> i64 {
    for num in (1..ceiling).rev() {
        if (public_exp * num) % euler_totient == 1 {
            return num;
        }
    }
    return 0;
}

fn encrypt_msg(message: &str, public_key: Vec<i64>) -> Vec<i64> {
    let mut encrypted_message: Vec<i64> = Vec::new();
    let mut ascii_code;
    let mut encrypted_char: BigInt = FromPrimitive::from_i64(0).unwrap();
    let mut base: i64;
    let mut exponent: usize;
    let mut modulus: BigInt;

    for char in message.chars() {
        ascii_code = char as i64;
        base = FromPrimitive::from_i64(ascii_code).unwrap();
        exponent = public_key[0].try_into().unwrap();
        modulus = FromPrimitive::from_i64(public_key[1]).unwrap();

        encrypted_char = BigInt::modpow(
            &base.into(),
            &exponent.into(),
            &modulus
        );

        encrypted_message.push(encrypted_char.to_i64().unwrap());
    }

    return encrypted_message;
}

fn decrypt_msg(encrypted_message: Vec<i64>, private_key: Vec<i64>) -> String {
    let mut decrypted_chars: Vec<char> = Vec::new();
    let mut base: i64;
    let mut exponent: usize;
    let mut modulus: BigInt;
    let mut decr_char_int;
    let mut decr_char: char;

    for encr_char in encrypted_message.iter() {
        base = *encr_char;
        exponent = private_key[0].try_into().unwrap();
        modulus = FromPrimitive::from_i64(private_key[1]).unwrap();

        decr_char_int = BigInt::modpow(
            &base.into(),
            &exponent.into(),
            &modulus
        );

        decr_char = std::char::from_u32(decr_char_int.to_u32().unwrap()).unwrap();
        decrypted_chars.push(decr_char);
    }

    return decrypted_chars.iter().collect();
}

fn main() {
    // let start_time = Utc::now().time();
    let num_p: i64 = 223;
    let num_q: i64 = 229;
    let num_product: i64 = num_p * num_q;

    let euler_totient = get_euler_totient(num_p, num_q);
    let public_exp = get_public_exp(euler_totient);
    let private_exp = get_private_exp(1_000_000, public_exp, euler_totient);
    let public_key = [public_exp, num_product];
    let private_key = [private_exp, num_product];
    //println!("public key = {:?}", public_key);
    //println!("private key = {:?}", private_key);

    let message = "Hello World!";
    let encr_message = encrypt_msg(message, public_key.to_vec());
    let decr_message = decrypt_msg(encr_message, private_key.to_vec());
    println!("{}", decr_message);
    // let end_time = Utc::now().time();
    // let diff = end_time - start_time;
    // println!("Finished in {}", diff.num_seconds())
}
