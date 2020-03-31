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

print("Calculo de integrais: 📚🧐 \n")

print("""
Entre com a sentença matemática:
""")

// Utiliza o readline para pegar a equação digitada pelo usuario.
while let input = readLine() {
    guard input.lowercased() != "quit", input.lowercased() != "q" else {
        print("-------------------------------------------------------\n")
        break
    }
    
    if input.count != 0{
        print("""
            
        Você digitou: \(input)
            
        -------------------------------------------------------
        Deseja alterar a função?
        ✅  Sim? Então digite novamente a sua equação novamente
        ❌  Não? Então digite "quit" ou "q".
        """)
        
        function = input.components(separatedBy: " ").filter{ validations.contains($0) == false }
        
    } else {
        print("Dado invalido, digite novamente:")
        continue
    }
}

// Utiliza o readline para pegar os intervalos digitado pelo usuario.
print("""
Agora, digite os intervalos:
ex: 1, 2
""")
while let input = readLine() {
    guard input.lowercased() != "quit", input.lowercased() != "q" else {
        print("-------------------------------------------------------\n")
        break
    }
    
    intervalos = input.components(separatedBy: ", ")
    if intervalos.count == 2 {
        range = Double(intervalos[0])! ... Double(intervalos[1])!
        print("""
            
        Você digitou: \(input)
            
        -------------------------------------------------------
        Deseja alterar os intervalos?
        ✅  Sim? Então digite novamente a sua equação novamente
        ❌  Não? Então digite "quit" ou "q".
        """)
    }
}

/* Tranforma a função que o usúario digitou: numeros para double,
    operadores e variaveis para a biblioteca pode usar. */
public func integral(fullFunction: [Any], x: Double) -> Double {
    var variable: Double = 0.0
    var i = 0
    
    // Converte numeros para double, operadores e variaveis.
    while fullFunction.count > i {
        let current_element = fullFunction[i]
        
        if i == 0 {
            variable = convertToDouble(element: current_element, x: x)
           i += 1
        }
        else if let mathOperator = current_element as? String, mathOperations.contains(mathOperator) == true {
            let next_element = fullFunction[i + 1]
            
            // Caso tiver parenteses na função
            if let parentheses = next_element as? String, parentheses == "(" {
                var functionInsideParentheses = [Any]()
                i += 2
                
                // Pega a parte a função que está dentro do parenteses.
                for k in i ... fullFunction.count {
                    if let insideParentheses = fullFunction[k] as? String, insideParentheses != ")" {
                        functionInsideParentheses.append(insideParentheses)
                        i += 1
                        continue
                    }
                    i += 1
                    break
                }
                
                // Adequa a parte a função que está dentro do parenteses.
                switch mathOperator {
                case "+":
                    variable += (integral(fullFunction: functionInsideParentheses, x: x))
                case "-":
                    variable -= (integral(fullFunction: functionInsideParentheses, x: x))
                case "*":
                    variable *= (integral(fullFunction: functionInsideParentheses, x: x))
                case "/":
                    variable /= (integral(fullFunction: functionInsideParentheses, x: x))
                default:
                    print("Erro em processar a equação")
                    break
                }
                continue
            }
            
            element = convertToDouble(element: next_element, x: x)
            
            switch mathOperator {
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

// Função que converte os elementos numericos da função digitada pelo usuario para Double.
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

// Configurações padrão do Quadrature sobre intervalos maximo e tolerancia de erros.
let quadrature = Quadrature(integrator:.qags(maxIntervals: 10000),
                            absoluteTolerance: 1.0e-8,
                            relativeTolerance: 1.0e-2)

// Onde calcula o integral com o Quadrature.
let result = quadrature.integrate(over: range) { x in
    return integral(fullFunction: function, x: x)
}
 
// Mostra o resultado (sucesso ou erro) do cálculo da integral.
switch result {
    case .success(let integralResult):
        print("Integral calculada:", integralResult)
    case .failure(let error):
        print("Erro no cálculo da integral:", error.errorDescription)
}
