public class sito_eratostenesa {
    public static void main(String[] args) {
        final int N = 10000; // stała N, ilość liczb
        int[] numall = new int[N + 1]; // N + 1, żeby zapisać też 0
        int[] primes = new int[N + 1];
        int nprimes = 0;

        // Rozpoczęcie pomiaru czasu
        long startTime = System.nanoTime();

        // Inicjalizacja tablicy numall
        for (int i = 0; i <= N; i++) {
            numall[i] = i;
        }
        
        // 1 nie jest liczbą pierwszą
        numall[1] = 0;

        System.out.print("Liczby pierwsze: ");

        // Sito Eratostenesa
        for (int i = 2; i <= N; i++) {
            if (numall[i] != 0) { // jeśli aktualna liczba nie została wyzerowana
                // Zapisz liczbę pierwszą
                primes[nprimes] = numall[i];
                nprimes++;
                
                // Wyświetl liczbę pierwszą
                System.out.print(numall[i] + " ");
                
                // Usuń wielokrotności
                for (int j = i * i; j <= N; j += i) {
                    numall[j] = 0;
                }
            }
        }

        // Zakończenie pomiaru czasu
        long endTime = System.nanoTime();
        long duration = (endTime - startTime); // czas w nanosekundach

        System.out.println(); // nowa linia
        System.out.println("Ilosc liczb pierwszych: " + nprimes);
        
        // Wyświetlenie czasu wykonania
        System.out.println("Czas wykonania: " + (duration / 1_000_000.0) + " ms");
    }
}