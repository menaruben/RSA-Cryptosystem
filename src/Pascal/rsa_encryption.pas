program rsa;
Uses math;

type
  Int64Array = array of Int64;

var
  num_p, num_q, num_prod, euler_totient: Int64;
  n: integer;
  primes: array of Int64;

function get_euler_totient(p, q: Int64) :Int64;
begin
  get_euler_totient := (p-1)*(q-1);
end;

function is_prime(n: Int64) :boolean;
var ceil, i, subres: Int64;
begin
  if n<2 then
    exit(false);

  if n<>2 then
    subres := n mod 2;
    if subres=0 then
      exit(false);
  
  ceil := Floor(sqrt(n));
  i := 2;
  while i<ceil do
  begin
    subres := n mod i;
    if subres=0 then
      exit(false);

    inc(i);
  end;
  exit(true)
end;

(* function get_primes(ceil: Int64) :Int64Array;
var primes: Int64Array;
begin *)
  
end;

begin
  num_p := 223;
  num_q := 229;
  num_prod := num_p*num_q;
  euler_totient := get_euler_totient(num_p, num_q);
  primes := get_primes(20);
  writeln(primes);
end.
