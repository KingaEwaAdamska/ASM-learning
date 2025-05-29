public class sito_eratostenesa {
    public static void main(String[] args) {
        long startTime = System.nanoTime();

        final int N = 10000;
        final int sqrtN = 100;
        int[] numall = new int[N + 1]; // +1 aby uwzględnić 0
        int[] primes = new int[N + 1];  // maksymalnie może być N liczb pierwszych
        int nprimes = 0;

        // Inicjalizacja tablicy numall
        for (int i = 0; i <= N; i++) {
            numall[i] = i;
        }

        numall[1] = 0; // 1 nie jest liczbą pierwszą

        // Sito Eratostenesa
        for (int i = 2; i <= sqrtN; i++) {
            if (numall[i] != 0) {
                for (int j = 2 * i; j <= N; j += i) {
                    numall[j] = 0;
                }
            }
        }

        // Zbieranie liczb pierwszych do tablicy primes
        for (int i = 2; i <= N; i++) {
            if (numall[i] != 0) {
                primes[nprimes++] = numall[i];
            }
        }

        // Pomiar czasu
        long endTime = System.nanoTime();
        double duration = (endTime - startTime) / 1_000_000.0; // w milisekundach

        // Wyświetlanie wyników
        System.out.println("Ilosc liczb pierwszych: " + nprimes);
        System.out.print("Liczby pierwsze: ");
        for (int i = 0; i < nprimes; i++) {
            System.out.print(primes[i] + " ");
        }
        System.out.println("\nCzas wykonania: " + duration + " ms");
    }
}