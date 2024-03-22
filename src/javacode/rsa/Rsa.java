package javacode.rsa;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class Rsa {
    private int p;
    private int q;
    private int primeProduct;
    private int eulerTotient;
    private int publicExponent;
    private int privateExponent;
    private int[] publicKey;
    private int[] privateKey;

    public Rsa(int p, int q) {
        this.p = p;
        this.q = q;
        this.primeProduct = p * q;
        createKeys();
    }

    private void calculateEulerTotient() {
        eulerTotient = (p - 1) * (q - 1);
    }

    private boolean isPrime(int n) {
        for (int i = 2; i < Math.sqrt(n); i++) {
            if (primeProduct % i == 0) {
                return false;
            }
        }

        return true;
    }

    private int getNearestSmallerPrime(int ceil) {
        for (int i = ceil; i > 1; i--) {
            if (isPrime(i)) {
                return i;
            }
        }

        throw new IllegalArgumentException("No prime number found");
    }

    private int[] getBezoutCoefficients(int a, int b) {
        int[] coefficients = new int[2];
        int x = 0;
        int y = 1;
        int lastX = 1;
        int lastY = 0;
        int temp;

        while (b != 0) {
            int quotient = a / b;
            int remainder = a % b;

            a = b;
            b = remainder;

            temp = x;
            x = lastX - quotient * x;
            lastX = temp;

            temp = y;
            y = lastY - quotient * y;
            lastY = temp;
        }

        coefficients[0] = lastX;
        coefficients[1] = lastY;

        return coefficients;
    }

    private void calculatePublicExponent() {
        publicExponent = getNearestSmallerPrime(eulerTotient);
    }

    private void calculatePrivateExponent() {
        int[] coefficients = getBezoutCoefficients(publicExponent, eulerTotient);
        privateExponent = coefficients[0];

        if (privateExponent < 0) {
            privateExponent += eulerTotient;
        }
    }

    private void createKeys() {
        calculateEulerTotient();
        calculatePublicExponent();
        calculatePrivateExponent();
        publicKey = new int[] {primeProduct, publicExponent};
        privateKey = new int[] {primeProduct, privateExponent};
    }

    public List<BigInteger> encryptMessage(String message) {
        List<BigInteger> encryptedMessage = new ArrayList<>();
        for (char c : message.toCharArray()) {
            encryptedMessage.add(BigInteger.valueOf(c).modPow(BigInteger.valueOf(publicExponent), BigInteger.valueOf(primeProduct)));
        }

        return encryptedMessage;
    }

    public String decryptMessage(List<BigInteger> encryptedMessage) {
        StringBuilder decryptedMessage = new StringBuilder();
        for (BigInteger c : encryptedMessage) {
            decryptedMessage.append((char) c.modPow(BigInteger.valueOf(privateExponent), BigInteger.valueOf(primeProduct)).intValue());
        }

        return decryptedMessage.toString();
    }

    public static void main(String[] args) {
        Rsa rsa = new Rsa(223, 229);
        List<BigInteger> encryptedMessage = rsa.encryptMessage("Hello, World!");
        // System.out.println(encryptedMessage);
        String decryptedMessage = rsa.decryptMessage(encryptedMessage);
        System.out.println(decryptedMessage);
    }
}
