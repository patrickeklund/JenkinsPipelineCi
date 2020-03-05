#!groovy

// Command Takes 2 mandatory argument
// logHeader: The log Header
// logMessage: The log message to log
def debug(String logHeader, String logMessage) {
	if ( env.LOG_DEBUG.equals("true") ) {
		level("DEBUG", logHeader, logMessage)
	}
}

// Command Takes 3 mandatory argument
// logHeader: The log Header
// logMessage: The log message to log
// logMessage: The shell command to run and get outut from
def debug(String logHeader, String logMessage, String shellCmd) {
	if ( env.LOG_DEBUG.equals("true") ) {
		level("DEBUG", logHeader, logMessage + " : " + bat( returnStdout: true, script: shellCmd ) )
	}
}


// Command Takes 2 mandatory argument
// logHeader: The log Header
// logMessage: The log message to log
def info(String logHeader, String logMessage) {
	level("INFO", logHeader, logMessage)
}

// Command Takes 3 mandatory argument
// logHeader: The log Header
// logMessage: The log message to log
// Exceptione: The exception message thrown
def info(String logHeader, String logMessage, Throwable e) {
	level("INFO", logHeader, logMessage + "\n" + e.toString() )
}

// Command Takes 2 mandatory argument
// logHeader: The log Header
// logMessage: The log message to log
def error(String logHeader, String logMessage) {
	level("ERROR", logHeader, logMessage)
}

// Command Takes 3 mandatory argument
// logHeader: The log Header
// logMessage: The log message to log
// Exceptione: The exception message thrown
def error(String logHeader, String logMessage, Throwable e) {
	level("ERROR", logHeader, logMessage + "\n" + e.toString() )
}

// Command Takes 3 mandatory arguments
// level: The log level to log to (DEBUG, INFO, ERROR)
// logHeader: The log Header
// logMessage: The log message to log
def level(String logLevel, String logHeader, String logMessage) {
	echo("[${logLevel}] - [${logHeader}] - ${logMessage}")
	if ( logLevel.equals("ERROR")) {
		error("[${logLevel}] - [${logHeader}] - ${logMessage}")
	}
}
