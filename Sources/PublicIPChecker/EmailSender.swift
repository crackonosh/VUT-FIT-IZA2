//
//  EmailSender.swift
//  PublicIPChecker
//
//  Created by Lukáš Hais on 4/30/21.
//

import Foundation

func sendEmail(old: String, new: String) -> Void {
  print("Old: " + old)
  print("New: " + new)
  // get current time and date
  var datetime: String
  if #available(OSX 10.12, *) {
    datetime = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
  } else {
    // Fallback on earlier versions
    datetime = "kek"
  }
  
  print(datetime)
}
