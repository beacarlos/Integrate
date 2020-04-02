//
//  main.swift
//  Integrate - Calculo de integrais: 📚🧐
//
//  Created by Beatriz Carlos e Ronaldo Gomes on 30/03/20.
//  Copyright © 2020 Beatriz Carlos. All rights reserved.
//

import Foundation
import Accelerate

// enum para representar se o dado e funcao ou intervalo
enum TypeInput{
    case function
    case interval
    
    var description: String {
        switch self {
        case .function:
            return "funçao"
        case .interval:
            return "intervalo"
        }
    }
}

// extension pra uso da nsexpression
extension String {
    var expression: NSExpression {
        return NSExpression(format: self)
    }
}

// funcao que utiliza o enum e realiza o melhor print de acordo com a entrada de dados
func mostraOpcoes(type: TypeInput, input: String){
        print("""

        Você digitou: \(input)

        -------------------------------------------------------
        Deseja alterar: \(type.description)?
        ✅  Sim? Então digite novamente.
        ❌  Não? Então digite "quit" ou "q".
        """)
}

var intervalos: [String] = []
var range: ClosedRange<Double> = 0 ... 0

// variavel que recebe a entrada do usuario para uso da NSExpression
var formula: String = ""

print("Calculo de integrais: 📚🧐 \n")

print("""
Esse script resolve integrais definidas.
Digite + para adição
Digite - para subtração
Digite * para multiplicação
Digite / para divisão
Digite x para representar a variavel da função
Digite ( ) para inserir parenteses
Não insira um bloco de parenteses dentro de outro. Exemplo: ( ( ) )
Digite todos os elementos separados por um espaço em branco
Exemplo de um modelo de função: x / ( 2 * x )
""")

print("""
Entre com a sentença matemática:
""")

// Utiliza o readline para pegar a equação digitada pelo usúario.
while let input = readLine() {
    guard input.lowercased() != "quit", input.lowercased() != "q" else {
        print("-------------------------------------------------------\n")
        break
    }

    if input.count != 0 {
        mostraOpcoes(type: TypeInput.function, input: input)
        formula = input
    } else {
        print("Dado invalido, digite novamente:")
        continue
    }
}

// Utiliza o readline para pegar os intervalos digitados pelo usúario.
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
        mostraOpcoes(type: TypeInput.interval, input: input)
    }
}

// Configurações padrão do Quadrature sobre intervalos máximo e tolerância de erros.
let quadrature = Quadrature(integrator:.qags(maxIntervals: 10000),
                            absoluteTolerance: 1.0e-8,
                            relativeTolerance: 1.0e-2)

// Onde calcula o integral com o Quadrature.
let result = quadrature.integrate(over: range) { x in
    // aqui eh montado o dicinario que a NSExpression necessita
    let intDictionary = ["x": x]
    
    // aqui onde eh calculado o valor da equacao baseado na string formula
    if let timesResult = formula.expression.expressionValue(with: intDictionary, context: nil) as? Double {
        return timesResult
    } else { return 0 } // caso de algum erro, deve-se ainda fazer uma verificacao mais fiel, por o return 0 causara erros na saida
}

// Mostra o resultado (sucesso ou erro) do cálculo da integral.
switch result {
    case .success(let integralResult):
        print("Integral calculada:\n\(integralResult)")
    case .failure(let error):
        print("Erro no cálculo da integral:", error.errorDescription)
}
