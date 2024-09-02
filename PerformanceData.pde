class PerformanceData {
    int totalNodes = 0;
    int successfulHits = 0;
    int missedHits = 0;
    long startTime;
    long endTime;
    long totalReactionTime = 0;

    void startSession() {
        startTime = System.currentTimeMillis();
    }

    void endSession() {
        endTime = System.currentTimeMillis();
    }

    void logReactionTime(long reactionTime) {
        totalReactionTime += reactionTime;
    }

    float getAccuracy() {
        return successfulHits * 100.0f / totalNodes;
    }

    float getAverageReactionTime() {
        return successfulHits > 0 ? totalReactionTime / (float) successfulHits : 0;
    }

    long getTotalTime() {
        return endTime - startTime;
    }

    void reset() {
        totalNodes = 0;
        successfulHits = 0;
        missedHits = 0;
        totalReactionTime = 0;
        startTime = 0;
        endTime = 0;
    }
}
