//
//  NSDecimalNumber+Extension.swift
//  StudyDecimalNumber
//
//  Created by MacBook Pro on 6/20/24.
//

import Foundation

public extension Double {
    func roundTo(roundType: FloatingPointRoundingRule = .toNearestOrAwayFromZero, decimalCount: Int32) -> Double {
        // 乘以10的要保留的小数位的长度，10^n, 最小只能是保留0位小数
        let divisor = pow(10.0, Double(max(decimalCount, 0)))
        // 获取整数
        let bigDouble: Double = (self * divisor)
        // 截取，通过type，向上截取、向下截取、四舍五入截取只保留整数位
        let integerDouble = bigDouble.rounded(roundType)
        // 回归要保留的小数位
        let result = integerDouble / divisor
        return result
    }
    func roundToStr(roundType: FloatingPointRoundingRule = .toNearestOrAwayFromZero, decimalCount: Int32) -> String {
        let result = self.roundTo(roundType: roundType, decimalCount: decimalCount)
        return "\(result)"
    }
}

public extension String {
    var numberText: String {
        // 去掉文本里的一些特殊字符，防止转移成数字时出错
        var txt = self
        // 去掉千分位
        txt = txt.replacingOccurrences(of: ",", with: "")
        txt = txt.replacingOccurrences(of: "，", with: "")
        // 去掉金额符号
        txt = txt.replacingOccurrences(of: "$", with: "")
        txt = txt.replacingOccurrences(of: "￥", with: "")
        // 去掉空格
        txt = txt.replacingOccurrences(of: " ", with: "")
        // 去掉百分比符号
        txt = txt.replacingOccurrences(of: "%", with: "")
        // 去掉数字里的正数符号+
        txt = txt.replacingOccurrences(of: "+", with: "")
        return txt
    }
    
    var decimalNumber: NSDecimalNumber {
        let txt = self.numberText
        if txt.count == 0 {
            // 空字符串会生成NaN，与其他值计算会崩溃
            return .zero
        }
        let res = NSDecimalNumber(string: txt)
        if res == .notANumber {
            // 空字符串会生成NaN，与其他值计算会崩溃
            return .zero
        }
        return res
    }
}

public extension NSDecimalNumber {
    // MARK: - 加减乘除
    static func + (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.adding(rhs)
    }
    
    static func - (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.subtracting(rhs)
    }
    
    static func * (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.multiplying(by: rhs)
    }
    
    static func / (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        if rhs == .zero {
            // 防止崩溃
            return .zero
        }
        return lhs.dividing(by: rhs)
    }
    // MARK: - 比较大小
    static func > (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        let result = lhs.compare(rhs)
        return result == .orderedDescending
    }
    static func >= (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        let result = lhs.compare(rhs)
        return result == .orderedDescending || result == .orderedSame
    }
    static func < (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        let result = lhs.compare(rhs)
        return result == .orderedAscending
    }
    static func <= (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        let result = lhs.compare(rhs)
        return result == .orderedAscending || result == .orderedSame
    }
    static func == (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        let result = lhs.compare(rhs)
        return result == .orderedSame
    }
    // MARK: - 最大最小值
    func min(_ val: NSDecimalNumber) -> NSDecimalNumber {
        if self > val {
            return val
        }
        return self
    }
    func max(_ val: NSDecimalNumber) -> NSDecimalNumber {
        if self < val {
            return val
        }
        return self
    }
    static func min(_ nums: NSDecimalNumber...) -> NSDecimalNumber {
        return nums.reduce(nums.first ?? .zero, { ($0 > $1) ? $1 : $0 })
    }
    static func max(_ nums: NSDecimalNumber...) -> NSDecimalNumber {
        return nums.reduce(nums.first ?? .zero, { ($0 < $1) ? $1 : $0 })
    }
    // MARK: - 限制小数位
    func roundTo(decimalCount: Int16, roundingMode: RoundingMode = .plain) -> NSDecimalNumber {
        /**
        plain: 保留位数的下一位四舍五入
        down: 保留位数的下一位直接舍去
        up: 保留位数的下一位直接进一位
        bankers: 当保留位数的下一位不是5时，四舍五入，当保留位数的下一位是5时，其前一位是偶数直接舍去，是奇数直接进位（如果5后面还有数字则直接进位）
         */
        /**
        raiseOnExactness: 发生精确错误时是否抛出异常，一般为false
        raiseOnOverflow: 发生溢出错误时是否抛出异常，一般为false
        raiseOnUnderflow: 发生不足错误时是否抛出异常，一般为false
        raiseOnDivideByZero: 除数是0时是否抛出异常，一般为true
         */

        let behavior = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: decimalCount,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: true)
        let product = multiplying(by: .one, withBehavior: behavior)
        return product
    }
    func roundToStr(roundingMode: RoundingMode = .plain, decimalCount: Int16 = 2,  minZeroCount: Int = 2) -> String {
        /**
        plain: 保留位数的下一位四舍五入
        down: 保留位数的下一位直接舍去
        up: 保留位数的下一位直接进一位
        bankers: 当保留位数的下一位不是5时，四舍五入，当保留位数的下一位是5时，其前一位是偶数直接舍去，是奇数直接进位（如果5后面还有数字则直接进位）
         */
        /**
        raiseOnExactness: 发生精确错误时是否抛出异常，一般为false
        raiseOnOverflow: 发生溢出错误时是否抛出异常，一般为false
        raiseOnUnderflow: 发生不足错误时是否抛出异常，一般为false
        raiseOnDivideByZero: 除数是0时是否抛出异常，一般为true
         */
        let result = self.roundTo(decimalCount: decimalCount, roundingMode: roundingMode)
        var resultStr = result.stringValue
        if decimalCount > 0 {
            // 如果不是整数，设计小数位
            // 小数位不足，补齐 10.1 -> 10.10
            let nowCount = resultStr.components(separatedBy: ".").last?.count ?? 0
            let disCount = minZeroCount - nowCount
            if disCount > 0 {
                resultStr = resultStr + Array(repeating: "0", count: disCount).joined()
            }
        }
        return resultStr
    }
    
    // MARK: - 快捷数字
    static var num100: NSDecimalNumber {
        return NSDecimalNumber(value: 100)
    }
}