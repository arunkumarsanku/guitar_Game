// The PerformanceData class tracks and manages the player's performance data during a game session
class PerformanceData {
    int totalNodes = 0;            // Total number of nodes generated during the session
    int successfulHits = 0;        // Number of nodes successfully hit by the player
    int missedHits = 0;            // Number of nodes missed by the player
    long startTime;                // Start time of the session in milliseconds
    long endTime;                  // End time of the session in milliseconds
    long totalReactionTime = 0;    // Cumulative reaction time for all successful hits

    // Method to start the session, recording the start time
    void startSession() {
        startTime = System.currentTimeMillis();  // Record the current time as the session start time
    }

    // Method to end the session, recording the end time
    void endSession() {
        endTime = System.currentTimeMillis();    // Record the current time as the session end time
    }

    // Method to log the reaction time for a successful hit
    void logReactionTime(long reactionTime) {
        totalReactionTime += reactionTime;  // Add the reaction time to the cumulative total
    }

    // Method to calculate the accuracy of the player as a percentage
    float getAccuracy() {
        return totalNodes > 0 ? (successfulHits * 100.0f / totalNodes) : 0;  // Return the accuracy as a percentage
    }

    // Method to calculate the average reaction time for successful hits
    float getAverageReactionTime() {
        return successfulHits > 0 ? (totalReactionTime / (float) successfulHits) : 0;  // Return the average reaction time
    }

    // Method to calculate the total time elapsed during the session
    long getTotalTime() {
        return endTime - startTime;  // Return the total time in milliseconds
    }

    // Method to reset all performance data for a new session
    void reset() {
        totalNodes = 0;              // Reset total nodes
        successfulHits = 0;          // Reset successful hits
        missedHits = 0;              // Reset missed hits
        totalReactionTime = 0;       // Reset total reaction time
        startTime = 0;               // Reset start time
        endTime = 0;                 // Reset end time
    }
}
