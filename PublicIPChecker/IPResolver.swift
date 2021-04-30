//
//  IPResolver.swift
//  PublicIPChecker
//
//  Created by Lukáš Hais on 4/30/21.
//

import Foundation



func getPublicIPAddress() -> (Int, String) {
  // see https://www.makeuseof.com/get-public-ip-address-in-linux/
  let cmd = "host myip.opendns.com resolver1.opendns.com | grep \"myip.opendns.com has\" | awk '{print $4}'"
  let IPaddress = shell(cmd)
  
  
  
  return (0, IPaddress)
}

func shell(_ command: String) -> String {
  // see https://developer.apple.com/forums/thread/90111
  
  // create a subprocess
  let task = Process()
  // setup default launch agent
  task.launchPath = "/usr/bin/env"
  // run in `sh` with `-c` flag that runs following `command`
  task.arguments = ["sh", "-c", command]
  
  // create a pipe that points to `stdout` of command
  let pipe = Pipe()
  task.standardOutput = pipe
  
  // launch shell command and wait for it to end
  task.launch()
  task.waitUntilExit()


  // process output of shell command and return it
  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  guard let output: String = String(data: data, encoding: .utf8) else { return ""}

  // trim newline character that is part of returned string
  return output.trimmingCharacters(in: .whitespacesAndNewlines)
}


func resolveIP() -> (Int, String){
  let (returnCode, address) = getPublicIPAddress()
  if (returnCode != 0){
    return (1, address)
  }
  return (0, address)
}
