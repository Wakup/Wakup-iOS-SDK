//
//  AsyncLegacy.swift
//
//  Created by Tobias DM on 15/07/14.
//  Modifed by Joseph Lord
//  Copyright (c) 2014 Human Friendly Ltd.
//
//	OS X 10.9+ and iOS 7.0+
//	Only use with ARC
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

// HACK: For Beta 5, 6
prefix func +(v: qos_class_t) -> Int {
    return Int(v.rawValue)
}

private class GCD {
    
    /* dispatch_get_queue() */
    class final func mainQueue() -> DispatchQueue {
        return DispatchQueue.main
        // Could use return dispatch_get_global_queue(+qos_class_main(), 0)
    }
    class final func userInteractiveQueue() -> DispatchQueue {
        //return dispatch_get_global_queue(+QOS_CLASS_USER_INTERACTIVE, 0)
        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
    }
    class final func userInitiatedQueue() -> DispatchQueue {
        //return dispatch_get_global_queue(+QOS_CLASS_USER_INITIATED, 0)
        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
    }
    class final func defaultQueue() -> DispatchQueue {
        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
    }
    class final func utilityQueue() -> DispatchQueue {
        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low)
    }
    class final func backgroundQueue() -> DispatchQueue {
        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background)
    }
}

open class Async {
    
    //The block to be executed does not need to be retained in present code
    //only the dispatch_group is needed in order to cancel it.
    //private let block: dispatch_block_t
    fileprivate let dgroup: DispatchGroup = DispatchGroup()
    fileprivate var isCancelled = false
    fileprivate init() {}
    
}


extension Async { // Static methods
    
    
    /* dispatch_async() */
    
    fileprivate class final func async(_ block: @escaping ()->(), inQueue queue: DispatchQueue) -> Async {
        // Wrap block in a struct since dispatch_block_t can't be extended and to give it a group
        let asyncBlock =  Async()
        
        // Add block to queue
        queue.async(group: asyncBlock.dgroup, execute: asyncBlock.cancellable(block))
        
        return asyncBlock
        
    }
    class final func main(_ block: @escaping ()->()) -> Async {
        return Async.async(block, inQueue: GCD.mainQueue())
    }
    class final func userInteractive(_ block: @escaping ()->()) -> Async {
        return Async.async(block, inQueue: GCD.userInteractiveQueue())
    }
    class final func userInitiated(_ block: @escaping ()->()) -> Async {
        return Async.async(block, inQueue: GCD.userInitiatedQueue())
    }
    class final func default_(_ block: @escaping ()->()) -> Async {
        return Async.async(block, inQueue: GCD.defaultQueue())
    }
    class final func utility(_ block: @escaping ()->()) -> Async {
        return Async.async(block, inQueue: GCD.utilityQueue())
    }
    class final func background(_ block: @escaping ()->()) -> Async {
        return Async.async(block, inQueue: GCD.backgroundQueue())
    }
    class final func customQueue(_ queue: DispatchQueue, block: @escaping ()->()) -> Async {
        return Async.async(block, inQueue: queue)
    }
    
    
    /* dispatch_after() */
    
    fileprivate class final func after(_ seconds: Double, block: @escaping ()->(), inQueue queue: DispatchQueue) -> Async {
        let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
        let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
        return at(time, block: block, inQueue: queue)
    }
    fileprivate class final func at(_ time: DispatchTime, block: @escaping ()->(), inQueue queue: DispatchQueue) -> Async {
        // See Async.async() for comments
        let asyncBlock = Async()
        asyncBlock.dgroup.enter()
        queue.asyncAfter(deadline: time){
            let cancellableBlock = asyncBlock.cancellable(block)
            cancellableBlock() // Compiler crashed in Beta6 when I just did asyncBlock.cancellable(block)() directly.
            asyncBlock.dgroup.leave()
        }
        return asyncBlock
    }
    class final func main(after: Double, block: @escaping ()->()) -> Async {
        return Async.after(after, block: block, inQueue: GCD.mainQueue())
    }
    class final func userInteractive(after: Double, block: @escaping ()->()) -> Async {
        return Async.after(after, block: block, inQueue: GCD.userInteractiveQueue())
    }
    class final func userInitiated(after: Double, block: @escaping ()->()) -> Async {
        return Async.after(after, block: block, inQueue: GCD.userInitiatedQueue())
    }
    class final func default_(after: Double, block: @escaping ()->()) -> Async {
        return Async.after(after, block: block, inQueue: GCD.defaultQueue())
    }
    class final func utility(after: Double, block: @escaping ()->()) -> Async {
        return Async.after(after, block: block, inQueue: GCD.utilityQueue())
    }
    class final func background(after: Double, block: @escaping ()->()) -> Async {
        return Async.after(after, block: block, inQueue: GCD.backgroundQueue())
    }
    class final func customQueue(after: Double, queue: DispatchQueue, block: @escaping ()->()) -> Async {
        return Async.after(after, block: block, inQueue: queue)
    }
}


extension Async { // Regualar methods matching static once
    
    fileprivate final func chain(block chainingBlock: @escaping ()->(), runInQueue queue: DispatchQueue) -> Async {
        // See Async.async() for comments
        let asyncBlock = Async()
        asyncBlock.dgroup.enter()
        self.dgroup.notify(queue: queue) {
            let cancellableChainingBlock = asyncBlock.cancellable(chainingBlock)
            cancellableChainingBlock()
            asyncBlock.dgroup.leave()
        }
        return asyncBlock
    }
    
    fileprivate final func cancellable(_ blockToWrap: @escaping ()->()) -> ()->() {
        // Retains self in case it is cancelled and then released.
        return {
            if !self.isCancelled {
                blockToWrap()
            }
        }
    }
    
    final func main(_ chainingBlock: @escaping ()->()) -> Async {
        return chain(block: chainingBlock, runInQueue: GCD.mainQueue())
    }
    final func userInteractive(_ chainingBlock: @escaping ()->()) -> Async {
        return chain(block: chainingBlock, runInQueue: GCD.userInteractiveQueue())
    }
    final func userInitiated(_ chainingBlock: @escaping ()->()) -> Async {
        return chain(block: chainingBlock, runInQueue: GCD.userInitiatedQueue())
    }
    final func default_(_ chainingBlock: @escaping ()->()) -> Async {
        return chain(block: chainingBlock, runInQueue: GCD.defaultQueue())
    }
    final func utility(_ chainingBlock: @escaping ()->()) -> Async {
        return chain(block: chainingBlock, runInQueue: GCD.utilityQueue())
    }
    final func background(_ chainingBlock: @escaping ()->()) -> Async {
        return chain(block: chainingBlock, runInQueue: GCD.backgroundQueue())
    }
    final func customQueue(_ queue: DispatchQueue, chainingBlock: @escaping ()->()) -> Async {
        return chain(block: chainingBlock, runInQueue: queue)
    }
    
    
    /* dispatch_after() */
    
    fileprivate final func after(_ seconds: Double, block chainingBlock: @escaping ()->(), runInQueue queue: DispatchQueue) -> Async {
        
        let asyncBlock = Async()
        
        self.dgroup.notify(queue: queue)
            {
                asyncBlock.dgroup.enter()
                let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
                let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
                queue.asyncAfter(deadline: time) {
                    let cancellableChainingBlock = self.cancellable(chainingBlock)
                    cancellableChainingBlock()
                    asyncBlock.dgroup.leave()
                }
                
        }
        
        // Wrap block in a struct since dispatch_block_t can't be extended
        return asyncBlock
    }
    final func main(after: Double, block: @escaping ()->()) -> Async {
        return self.after(after, block: block, runInQueue: GCD.mainQueue())
    }
    final func userInteractive(after: Double, block: @escaping ()->()) -> Async {
        return self.after(after, block: block, runInQueue: GCD.userInteractiveQueue())
    }
    final func userInitiated(after: Double, block: @escaping ()->()) -> Async {
        return self.after(after, block: block, runInQueue: GCD.userInitiatedQueue())
    }
    final func default_(after: Double, block: @escaping ()->()) -> Async {
        return self.after(after, block: block, runInQueue: GCD.defaultQueue())
    }
    final func utility(after: Double, block: @escaping ()->()) -> Async {
        return self.after(after, block: block, runInQueue: GCD.utilityQueue())
    }
    final func background(after: Double, block: @escaping ()->()) -> Async {
        return self.after(after, block: block, runInQueue: GCD.backgroundQueue())
    }
    final func customQueue(after: Double, queue: DispatchQueue, block: @escaping ()->()) -> Async {
        return self.after(after, block: block, runInQueue: queue)
    }
    
    
    /* cancel */
    
    final func cancel() {
        // I don't think that syncronisation is necessary. Any combination of multiple access
        // should result in some boolean value and the cancel will only cancel
        // if the execution has not yet started.
        isCancelled = true
    }
    
    /* wait */
    
    /// If optional parameter forSeconds is not provided, use DISPATCH_TIME_FOREVER
    final func wait(_ seconds: Double = 0.0) {
        if seconds != 0.0 {
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
            dgroup.wait(timeout: time)
        } else {
            dgroup.wait(timeout: DispatchTime.distantFuture)
        }
    }
}


// Convenience

// extension qos_class_t {
//
//	// Calculated property
//	var description: String {
//		get {
//			switch +self {
//				case +qos_class_main(): return "Main"
//				case +QOS_CLASS_USER_INTERACTIVE: return "User Interactive"
//				case +QOS_CLASS_USER_INITIATED: return "User Initiated"
//				case +QOS_CLASS_DEFAULT: return "Default"
//				case +QOS_CLASS_UTILITY: return "Utility"
//				case +QOS_CLASS_BACKGROUND: return "Background"
//				case +QOS_CLASS_UNSPECIFIED: return "Unspecified"
//				default: return "Unknown"
//			}
//		}
//	}
//}
