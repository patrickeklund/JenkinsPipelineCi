def call() {
  node("master") {
    String logHeader = "getEnv"
    String logMessage = "Environment variables available: "
    String logCommand = "set"
    log.debug( logHeader, logMessage , logCommand)
  }
}
