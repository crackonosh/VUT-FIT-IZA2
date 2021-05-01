//
//  STDERRStream.swift
//  PublicIPChecker
//
//  Created by Lukáš Hais on 4/26/21.
//

import Foundation

// this was kindly stolen from 1. IZA project folder
final class STDERRStream: TextOutputStream {
  func write(_ string: String) {
    FileHandle.standardError.write(Data(string.utf8))
  }
}
