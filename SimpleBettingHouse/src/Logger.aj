import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public aspect Logger {

    pointcut signUp(String username): execution(* registerUser(String)) && args(username);

    pointcut logIn(String username): execution(* logIn(String)) && args(username);

    pointcut logOut(String username): execution(* logOut(String)) && args(username);

    after(String username): signUp(username) {
        logAction("Register", username);
    }

    after(String username): logIn(username) {
        logAction("LogIn", username);
    }

    after(String username): logOut(username) {
        logAction("LogOut", username);
    }

    private void logAction(String action, String username) {
        String logMessage = generateLogMessage(action, username);
        writeToLog(logMessage);
        System.out.println(logMessage);
    }

    private String generateLogMessage(String action, String username) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String currentTime = dateFormat.format(new Date());
        return "[" + currentTime + "] " + action + " - Username: " + username;
    }

    private void writeToLog(String logMessage) {
        String fileName = logMessage.contains("Register") ? "Register.txt" : "Log.txt";
        try (FileWriter writer = new FileWriter(fileName, true)) {
            writer.write(logMessage + "\n");
        } catch (IOException e) {
            System.err.println("Error writing to log file: " + e.getMessage());
        }
    }
}
