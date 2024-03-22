package main

import (
	"fmt"
)

func getEulerTotient(p, q int64) int64 {
	return int64((int(p) - 1) * (int(q) - 1))
}

func isPrime(num int64) bool {
	if num < 2 {
		return false
	}
	for i := int64(2); i*i <= num; i++ {
		if num%i == 0 {
			return false
		}
	}
	return true
}

func getNearestSmallerPrime(num int64) int64 {
	if isPrime(num) {
		return num
	}
	for i := num - 1; i > 1; i-- {
		if isPrime(i) {
			return i
		}
	}
	return 2
}

func getPublicExp(eulerTotient int64) int64 {
	return getNearestSmallerPrime(eulerTotient)
}

func getBezoutCoefficients(a, b int64) (int64, int64) {
	var x, y int64
	var x1, x2, y1, y2 int64
	var q, r int64
	var tempA, tempB int64

	x1, x2 = 1, 0
	y1, y2 = 0, 1
	tempA, tempB = a, b

	for tempB != 0 {
		q = tempA / tempB
		r = tempA % tempB

		x = x2
		y = y2

		x2 = x1 - q*x2
		y2 = y1 - q*y2

		x1 = x
		y1 = y

		tempA = tempB
		tempB = r
	}
	return x1, y1
}

func getPrivateExp(publicExp int64, eulerTotient int64) int64 {
	var x int64
	x, _ = getBezoutCoefficients(publicExp, eulerTotient)
	if x < 0 {
		return eulerTotient + x
	}
	return x
}

func ModPow(base, exponent, modulus int64) int64 {
	result := int64(1)
	base = base % modulus
	for exponent > 0 {
		if exponent%2 == 1 {
			result = (result * base) % modulus
		}
		exponent = exponent >> 1
		base = (base * base) % modulus
	}
	return result
}

func encryptMsg(message string, publicKey []int64) []int64 {
	var encryptedMsg []int64
	var asciiCode int
	var modpowAscii int64
	for _, char := range message {
		asciiCode = int(char)
		modpowAscii = ModPow(int64(asciiCode), publicKey[0], publicKey[1])
		encryptedMsg = append(encryptedMsg, modpowAscii)
	}
	return encryptedMsg
}

func decryptMsg(encryptedMsg []int64, privateKey []int64) string {
	var asciiCode int
	var decryptedMsg string

	for _, encrChar := range encryptedMsg {
		asciiCode = int(ModPow(int64(encrChar), int64(privateKey[0]), int64(privateKey[1])))
		decrChar := rune(asciiCode)
		decryptedMsg = decryptedMsg + string(decrChar)
	}
	return decryptedMsg
}

func main() {
	var numP int64 = 223
	var numQ int64 = 229
	var numProduct int64 = numP * numQ

	var eulerTotient int64 = getEulerTotient(numP, numQ)
	var publicExp int64 = getPublicExp(eulerTotient)
	var privateExp int64 = getPrivateExp(publicExp, eulerTotient)

	publicKey := []int64{publicExp, numProduct}
	privateKey := []int64{privateExp, numProduct}

	var message string = "Hello World!"
	var encrMsg []int64 = encryptMsg(message, publicKey)
	var decrMsg string = decryptMsg(encrMsg, privateKey)

	fmt.Println(decrMsg)
}
