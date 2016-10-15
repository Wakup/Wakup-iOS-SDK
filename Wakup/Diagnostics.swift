//
//  Diagnostics.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 16/2/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

class Diagnostics : NSObject {
    
    //MARK: Device Platform
    /** A String value of the device platform information */
    class var platform: String {
        // Declare an array that can hold the bytes required to store `utsname`, initilized
        // with zeros. We do this to get a chunk of memory that is freed upon return of
        // the method
        var sysInfo: [CChar] = Array(repeating: 0, count: MemoryLayout<utsname>.size)
        
        // We need to get to the underlying memory of the array:
        let machine = sysInfo.withUnsafeMutableBufferPointer {
            (ptr: inout UnsafeMutableBufferPointer<CChar>) -> String in
            // Call uname and let it write into the memory Swift allocated for the array
            uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
            
            // Now here is the ugly part: `machine` is the 5th member of `utsname` and
            // each member member is `_SYS_NAMELEN` sized. We skip the the first 4 members
            // of the struct which will land us at the memory address of the `machine`
            // member
            let machinePtr = ptr.baseAddress?.advanced(by: Int(_SYS_NAMELEN * 4))
            
            // Create a Swift string from the C string
            return String(cString: machinePtr!)
        }
        return machine
    }
}
