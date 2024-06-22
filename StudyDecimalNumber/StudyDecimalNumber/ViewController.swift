//
//  ViewController.swift
//  StudyDecimalNumber
//
//  Created by MacBook Pro on 6/20/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let numStr1 = "0.14"
        let db2 = Double(numStr1.numberText) ?? 0
        let db3 = numStr1.decimalNumber.doubleValue
        let db4 = numStr1.doubleValue
        
        let roundType: RoundType = .up
        let a0 = numStr1.roundToStr(decimalCount: 0, roundType: roundType, minZeroCount: 2) // "1"
        let a1 = numStr1.roundToStr(decimalCount: 1, roundType: roundType, minZeroCount: 2) // "0.20"
        let a2 = numStr1.roundToStr(decimalCount: 2, roundType: roundType, minZeroCount: 2) // "0.14"
        let a3 = numStr1.roundToStr(decimalCount: 3, roundType: roundType, minZeroCount: 2) // "0.14"

        let c0 = db2.roundToStr(decimalCount: 0, roundType: roundType, minZeroCount: 2) // "1"
        let c1 = db2.roundToStr(decimalCount: 1, roundType: roundType, minZeroCount: 2) // "0.20"
        let c2 = db2.roundToStr(decimalCount: 2, roundType: roundType, minZeroCount: 2) // "0.15"
        let c3 = db2.roundToStr(decimalCount: 3, roundType: roundType, minZeroCount: 2) // "0.14"
        
        print(a0, c0)
        
        // 延迟时间与设置的延迟时间会有轻微的差异，大体是没问题的

        let now0 = Date.systemMilliseconds_int64()
        print("==**>>--AA-->>: now0:\(now0)")
        // ==**>>--AA-->>: now0:1719038441921

        // .now()+数字，数字代表秒数，可以写整数，也可以写小数，表示延迟xxx秒后执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
            let now1 = Date.systemMilliseconds_int64()
            print("==**>>--BB1-->>: now0:\(now0) now1:\(now1) dis:\(now1-now0)")
            // ==**>>--BB1-->>: now0:1719038441921 now1:1719038442422 dis:501
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let now1 = Date.systemMilliseconds_int64()
            print("==**>>--BB2-->>: now0:\(now0) now1:\(now1) dis:\(now1-now0)")
            // ==**>>--BB2-->>: now0:1719038441921 now1:1719038442971 dis:1050
        })

        // .now() + .seconds(xxx), xxx必须是整数，.seconds(xxx)就是延迟xxx秒执行
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5) , execute: {
            let now2 = Date.systemMilliseconds_int64()
            print("==**>>--CC-->>: now0:\(now0) now2:\(now2) dis:\(now2-now0)")
            // ==**>>--CC-->>: now0:1719038441921 now2:1719038447171 dis:5250
        })

        // .now() + .milliseconds(xxx), xxx必须是整数，.milliseconds(xxx)就是延迟xxx毫秒执行
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300) , execute: {
            let now3 = Date.systemMilliseconds_int64()
            print("==**>>--DD-->>: now0:\(now0) now3:\(now3) dis:\(now3-now0)")
            // ==**>>--DD-->>: now0:1719038441921 now3:1719038442224 dis:303
        })
        // 还有微妙、纳秒，很少使用，就不列出来了
        
    }


}

extension Date {
    static func systemMilliseconds_int64() -> Int64 {
        return Int64(Date().timeIntervalSince1970*1000)
    }
}
