// enum ApiErrorType {
//   network,
//   timeout,
//   platform,
//   client,
//   server,
//   jsonFormat,
//   missingUUID,
//   unknown,
// }

// class ApiError {
//   /// Static method to get readable description of the error
//   static String describe(ApiErrorType error) {
//     switch (error) {
//       case ApiErrorType.network:
//         return "No internet connection.";
//       case ApiErrorType.timeout:
//         return "Request timed out.";
//       case ApiErrorType.platform:
//         return "Platform error.";
//       case ApiErrorType.client:
//         return "Client error.";
//       case ApiErrorType.server:
//         return "Server error.";
//       case ApiErrorType.jsonFormat:
//         return "Invalid response format.";
//       case ApiErrorType.missingUUID:
//         return "User ID not found.";
//       case ApiErrorType.unknown:
//       default:
//         return "An unknown error occurred.";
//     }
//   }
// }