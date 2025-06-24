import java.util.Scanner;

public class wielomian {
    public static void main(String[] args) {
        float[] coefs = {2.0f, 3.43f, 4.0f, 5.13f};
        int degree = 3;
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.print("Podaj X do wyliczenia wartosci wielomianu: ");
            float x = scanner.nextFloat();

            double result = evalPoly(coefs, degree, x);

            System.out.print("Wartosc wielomianu dla podanego x to: ");
            System.out.println((float)result); // Wyświetlamy z konwersją do float dla zgodności z oryginałem
        }
    }

    public static double evalPoly(float[] coefs, int degree, double x) {
        double result = coefs[0]; // Zacznij od współczynnika najwyższego stopnia

        for (int i = 1; i <= degree; i++) {
            // Schemat Hornera: wynik = wynik * x + współczynnik
            result = result * x + coefs[i];
        }

        return result;
    }
}
