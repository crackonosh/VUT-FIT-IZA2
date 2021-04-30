//
//  IPResolver.swift
//  PublicIPChecker
//
//  Created by Lukáš Hais on 4/30/21.
//

import Foundation

enum IPResolverErrors: Error {
  case UnexpectedRunningTaskError
}


func getPublicIPAddress() -> (Int, String) {
  // see https://www.makeuseof.com/get-public-ip-address-in-linux/
  let cmd = "host myip.opendns.com resolver1.opendns.com | grep \"myip.opendns.com has\" | awk '{print $4}'"
  
  // run shell command
  var stderr: String?
  var stdout: String?
  do {
    (stderr, stdout) = try shell(cmd)
  } catch {
    return (99, "Unexpected error occured when running task.")
  }
  
  if stderr!.contains("connection") {
    return (1, "Unable to resolve IP address, possibly not connected to internet.")
  } else if stderr!.contains("stderrPipe") || stderr!.contains("stdoutPipe") {
    return (2, "Error occured when handling pipes from command.")
  } else if stderr! != "" {
    return (99, "Unexpected error occured during exectuion of command")
  }
  
  // handle given IP address
  print (stdout!)
  return (0, stdout!)
}

func shell(_ command: String) throws -> (String, String){
  // see https://www.hackingwithswift.com/example-code/system/how-to-run-an-external-program-using-process
  
  // create a subprocess
  let task = Process()
  // give subprocess a path to enviro
  task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
  // run in `sh` with `-c` flag that runs following `command`
  task.arguments = ["sh", "-c", command]
  
  // create a pipes that point to `stdout` & `stderr` of command
  let stdoutPipe = Pipe()
  let stderrPipe = Pipe()
  task.standardOutput = stdoutPipe
  task.standardError = stderrPipe
  
  // run shell command and catch occuring errors
  do {
    try task.run()
  } catch {
    throw IPResolverErrors.UnexpectedRunningTaskError
  }

  // process stderr of shell command
  let errData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
  guard let err = String(data: errData, encoding: .utf8) else {
    return ("Error processing stderrPipe", "")
  }

  // handle occuring errors from command
  if (err.contains("host: couldn't get address for")) {
    print(err)
    return ("No connection", "")
  } else if (!err.isEmpty) {
    return (err, "")
  }
  
  // process stdout of shell command
  let data = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
  guard let output: String = String(data: data, encoding: .utf8) else {
    return ("Error processing stdoutPipe", "")
  }

  // trim newline character that is part of returned string
  return ("", output.trimmingCharacters(in: .whitespacesAndNewlines))
}


func resolveIP() -> (Int, String){
  let (returnCode, address) = getPublicIPAddress()
  if (returnCode != 0){
    return (1, address)
  }
  return (0, address)
}
