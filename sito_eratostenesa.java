import java.util.Arrays;

public class sito_eratostenesa {
    public static void main(String[] args) {
        final int N = 1_000_000; // Stała liczba N
        long startTime = System.nanoTime();
        
        boolean[] isPrime = sito_eratostenesa(N);
        
        long endTime = System.nanoTime();
        long duration = (endTime - startTime) / 1_000_000; // Czas w milisekundach
        
        // Wyświetlanie wyników
        System.out.println("Liczby pierwsze do " + N + ":");
        // Wypisz tylko kilka przykładów dla dużych N
        int printLimit = 100;
        int count = 0;
        for (int i = 2; i <= N; i++) {
            if (isPrime[i]) {
                if (count < printLimit) {
                    System.out.print(i + " ");
                }
                count++;
            }
        }
        
        if (count > printLimit) {
            System.out.println("\n... i " + (count - printLimit) + " więcej.");
        }
        
        System.out.println("\nZnaleziono " + count + " liczb pierwszych.");
        System.out.println("Czas wykonania: " + duration + " ms");
    }
    
    public static boolean[] sito_eratostenesa(int n) {
        boolean[] isPrime = new boolean[n + 1];
        Arrays.fill(isPrime, true);
        isPrime[0] = false;
        isPrime[1] = false;
        
        for (int i = 2; i * i <= n; i++) {
            if (isPrime[i]) {
                for (int j = i * i; j <= n; j += i) {
                    isPrime[j] = false;
                }
            }
        }
        
        return isPrime;
    }
}