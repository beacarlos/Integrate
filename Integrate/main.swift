//
//  main.swift
//  Integrate - Calculo de integrais: 📚🧐
//
//  Created by Beatriz Carlos e Ronaldo Gomes on 30/03/20.
//  Copyright © 2020 Beatriz Carlos. All rights reserved.
//

import Foundation
import Accelerate


var function: [Any] = []
var equation: [Double] = []
var intervalos: [String] = []
var range: ClosedRange<Double> = 0 ... 0
var integral: Double = 0
var element: Double = 0
let mathOperations: [String] = ["+", "-", "*", "/"]
let validations: [String] = ["", "/n", "'", "\"", "#", "_", "˜", "`", "|", "?", ".", ","]

print("Calculo de integrais: 📚🧐")

print("""
Entre com a sentença matemática:
""")

// validar para quando o usuário digitar nada.
while let input = readLine() {
    guard input.lowercased() != "sair", input.lowercased() != "s" else {
        break
    }
    
    if input.count != 0{
        print("""
        Você digitou: \(input)
        Voce digitou certo? Se sim aperte "sair" ou "s", se não digite novamente.
        """)
        function = input.components(separatedBy: " ").filter{ validations.contains($0) == false }
    } else {
        print("Dado invalido, digite novamente:")
        continue
    }
}

print("Agora digite os intervalos: ex: 1, 2")
while let input = readLine() {
    guard input.lowercased() != "sair", input.lowercased() != "s" else {
        break
    }
    
    intervalos = input.components(separatedBy: ", ")
    if intervalos.count == 2 {
        range = Double(intervalos[0])! ... Double(intervalos[1])!
        print("""
        Você digitou: \(input)
        Voce digitou certo? Se sim aperte "sair" ou "s", se não digite novamente.
        """)
    }
}

print(range)
print(function)

public func integral(functionParentheses: [Any], x: Double) -> Double {
    var variable: Double = 0.0
    var i = 0
    
    while functionParentheses.count > i {
        let current_element = functionParentheses[i]
        
        if i == 0 {
            variable = convertToDouble(element: current_element, x: x)
           i += 1
        }
        else if let value = current_element as? String, mathOperations.contains(value) == true {
            let next_element = functionParentheses[i + 1]
            
            if let parentheses = next_element as? String, parentheses == "(" {
                 var functionInsideParentheses = [Any]()
                i += 2
                
                for k in i ... functionParentheses.count {
                    if let insideParentheses = functionParentheses[k] as? String, insideParentheses != ")" {
                        functionInsideParentheses.append(insideParentheses)
                        i += 1
                        continue
                    }
                    i += 1
                    break
                }
                
                switch value {
                case "+":
                    variable += (integral(functionParentheses: functionInsideParentheses, x: x))
                case "-":
                    variable -= (integral(functionParentheses: functionInsideParentheses, x: x))
                case "*":
                    variable *= (integral(functionParentheses: functionInsideParentheses, x: x))
                case "/":
                    variable /= (integral(functionParentheses: functionInsideParentheses, x: x))
                default:
                    print("Erro em processar a equação")
                    break
                }
                continue
            }
            
            element = convertToDouble(element: next_element, x: x)
            
            switch value {
            case "+":
                variable += element
            case "-":
                variable -= element
            case "*":
                variable *= element
            case "/":
                variable /= element
            default:
                print("Erro em processar a equação")
                break
            }
            
            i += 2
        }
    }
    
    return variable
}

public func convertToDouble(element: Any, x: Double) -> Double {
    var convertedValue: Double = 0.00
    if let value = element as? String, value == "x"  {
        convertedValue = x
    }
    else if let value = element as? String, let num_double = Double(value) {
        convertedValue = num_double
    }
        
    return convertedValue
}

let quadrature = Quadrature(integrator:.qags(maxIntervals: 10),
                            absoluteTolerance: 1.0e-8,
                            relativeTolerance: 1.0e-2)

let result = quadrature.integrate(over: range) { x in
    return integral(functionParentheses: function, x: x)
}
 
// fazer uma extension para mostrar o resultado de forma mais intuitiva.
switch result {
    case .success(let integralResult):
        print("Integral calculada:", integralResult)
    case .failure(let error):
        print("Erro no cálculo da integral:", error.errorDescription)
}
