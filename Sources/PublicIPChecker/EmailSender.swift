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
  let frm = DateFormatter()
  frm.dateFormat = "yyyy-MM-dd HH:mm:ssXXX"
  let datetime = frm.string(from: Date()).replacingOccurrences(of: " ", with: "T")
  
  print(datetime)
}
