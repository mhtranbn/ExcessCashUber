//
//  Calculator.swift
//  ExcessCash
//
//  Created by 서상의 on 2020/09/29.
//

import Foundation

protocol Calculator {}

class Evaluator: Calculator {
    var stack: [Double] = []
    func evaluate(_ expression: Expression) -> Double {
        defer { stack.removeAll() }
        expression.forEach { token in
            if let operand = token.extractOperand {
                stack.append(operand)
            } else if let _operator = token.extractOperator {
                let second = stack.removeLast()
                let first = stack.removeLast()
                stack.append(_operator.calculate(first, second))
            }
        }
        return stack.first!
    }
    func clear() {
        self.stack.removeAll()
    }
}
