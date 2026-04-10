enum FailureType { network, database, validation, auth, parsing, unexpected }

class AppFailure {
  final String message;
  final String? code;
  final FailureType type;

  const AppFailure(
    this.message, {
    this.type = FailureType.unexpected,
    this.code,
  });

  // 1. DATABASE Failure Constructor
  const AppFailure.database(String message)
    : this(message, type: FailureType.database, code: 'DB_ERR');

  // 2. NETWORK Failure Constructor
  const AppFailure.network(String message)
    : this(message, type: FailureType.network, code: 'NET_ERR');

  // 3. VALIDATION Failure Constructor
  const AppFailure.validation(String message)
    : this(message, type: FailureType.validation, code: 'VAL_ERR');

  // 4. PARSING Failure Constructor (For JSON/data model issues)
  const AppFailure.parsing(String message)
    : this(message, type: FailureType.parsing, code: 'PARSE_ERR');

  // 5. AUTH Failure Constructor for future app lock
  const AppFailure.auth(String message)
    : this(message, type: FailureType.auth, code: 'AUTH_ERR');
  // Utility to print a clear debug message
  @override
  String toString() => '[$type] $message (Code: $code)';
}
