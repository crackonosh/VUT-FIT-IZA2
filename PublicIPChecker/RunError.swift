//
//  RunError.swift
//  PublicIPChecker
//
//  Created by Lukáš Hais on 4/26/21.
//

enum RunError: Error {
  case InvalidNumberOfArguments
  case NonExistingFile
  case FileOpenError
  case EmptyFile
  case InvalidEmail
  case ResolverError
  case Internal
}

//
extension RunError {
  var code: Int {
    switch self {
      case .InvalidNumberOfArguments:
        return 1
      case .NonExistingFile:
        return 2
      case .FileOpenError:
        return 3
      case .EmptyFile:
        return 4
      case .InvalidEmail:
        return 5
      case .ResolverError:
        return 6
      case .Internal:
        return 99
    }
  }
}

extension RunError: CustomStringConvertible {
  var description: String {
    switch self {
    case .InvalidNumberOfArguments:
      return "Invalid number of arguments passed!"
    case.NonExistingFile:
      return "Non existing file passed from command line!"
    case .FileOpenError:
      return "Unable to open file and get it's content!"
    case .EmptyFile:
      return "Passed file is empty!"
    case .InvalidEmail:
      return "Invalid email address found in CSV file!"
    case .ResolverError:
      return "Error while resolving IP address!"
    case .Internal:
      return "Unexpected internal error occured!"
    }
  }
}
