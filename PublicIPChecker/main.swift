//
//  main.swift
//  PublicIPChecker
//
//  Created by Lukáš Hais on 4/26/21.
//

import Foundation

/// Checks that given email addresses are in valid format
/// - Parameter addresses: Array of email addresses
/// - Returns: True if all addresses were valid, otherwise false
func checkAddresses(_ addresses: [String.SubSequence]) -> Bool {
  let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
  for address in addresses {
    if address.range(of: regex, options: .regularExpression) == nil {
      print("Encountered invalid email address: " + address)
      return false
    }
  }
  return true
}

/// Main function of application
func main() -> Result<Void, RunError> {
  // get arguments from commandline
  let args = CommandLine.arguments
  // check number of arguments
  if args.count > 2 || args.count < 2 {
    print("Try running with `-h` flag to find out how to operate this script")
    return .failure(.InvalidNumberOfArguments)
  }

  let arg = args[1]
  // check if should print help message
  if arg == "help" || arg == "-h" || arg == "--help" {
    print("usage: ./PublicIPChecker [-h|--help|help] path/to/file.csv")
    print("\t [-h|--help|help] - prints this message")
    print("\t path/to/file.csv - relative path to CSV file containing email addresses to send email to")
    return .success(())
  }
  
  // try to get content of csv file
  let fm = FileManager.default
  let path = fm.currentDirectoryPath+"/"+arg
  let data: String
  if fm.fileExists(atPath: path) {
    do {
      data = try String(contentsOf: URL(fileURLWithPath: path)).trimmingCharacters(in: .whitespacesAndNewlines)
    } catch {
      return .failure(.FileOpenError)
    }
  } else {
    print("File with name " + arg + " was not found in current directory")
    return .failure(.NonExistingFile)
  }
  
  // check that file is not empty
  if data.count == 0 {
    return.failure(.EmptyFile)
  }
  
  // split csv by ',' and check addresses
  let addresses = data.split(separator: ",")
  let result = checkAddresses(addresses)
  if (!result) {
    return .failure(.InvalidEmail)
  }
  
  let (returnCode, IPaddress) = resolveIP()
  print("Return code is: " + String(returnCode))
  print("IP address is: " + IPaddress)
  
  return .success(())
}


var result = main()

switch result {
  case.success:
    break
  case.failure(let error):
    var stderr = STDERRStream()
    print("Error: " + error.description, to: &stderr)
    exit(Int32(error.code))
}
