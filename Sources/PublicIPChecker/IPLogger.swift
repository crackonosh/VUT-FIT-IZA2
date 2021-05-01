//
//  IPLogger.swift
//  PublicIPChecker
//
//  Created by Lukáš Hais on 4/30/21.
//

import Foundation

/// Checks whether current IP address is same as logged IP address in a file
/// - Parameter address: Current public IP address of device
/// - Returns: Tuple where boolean value represents if any further work is necessary and string contains old IP address, occured error or is empty if boolean is false
func checkNewIPAddress(_ address: String) -> (Bool, String) {
  let fm = FileManager.default
  let path = fm.currentDirectoryPath + "/iplog.txt"
  
  // check existence of logging file
  if !fm.fileExists(atPath: path) {
    // write to logging file and return
    do {
      try address.write(toFile: path, atomically: true, encoding: .utf8)
    } catch {
      return (true, "WriteError")
    }
    return (false, "")
  }
  
  // get file content
  let data: String
  do {
    data = try String(contentsOf: URL(fileURLWithPath: path)).trimmingCharacters(in: .whitespacesAndNewlines)
  } catch {
    return (true, "ReadError")
  }
  
  // check that file is not empty
  if data.count == 0 {
    // write to logging file and return
    do {
      try address.write(toFile: path, atomically: true, encoding: .utf8)
    } catch {
      return (true, "WriteError")
    }
    return (false, "")
  }
    
  // check if logged IP address is identical to current IP address
  if data == address {
    return (false, "")
  }
    
  // rewrite file with new IP address
  do {
    try address.write(toFile: path, atomically: true, encoding: .utf8)
  } catch {
    return (true, "WriteError")
  }
  // return old logged IP address
  return (true, data)
}
