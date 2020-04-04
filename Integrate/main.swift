//
//  main.swift
//  Integrate - Calculo de integrais: 📚🧐
//
//  Created by Beatriz Carlos e Ronaldo Gomes on 30/03/20.
//  Copyright © 2020 Beatriz Carlos. All rights reserved.
//

import Foundation
import Accelerate

//Variaveis Globais
var intervalos: [String] = []
var range: ClosedRange<Double> = 0 ... 0

// variavel que recebe a entrada do usuario para uso da NSExpression
var formula: String = ""

// enum para representar se o dado e funcao ou intervalo
enum TypeInput{
    case function
    case interval
    
    var description: String {
        switch self {
        case .function:
            return "a funçao"
        case .interval:
            return "os intervalos"
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

        Você digitou \(type.description): \(input)

        -------------------------------------------------------
        
        ✅  Correto? Digite "sim" ou "s".
        ❌  Não? Então digite novamente a função.
        """)
}

func inputUsuario(tipodeInput: TypeInput){
    
    while let input = readLine() {
        
        guard input.lowercased() != "sim", input.lowercased() != "s" else {
            print("-------------------------------------------------------\n")
            break
        }
        
        //Verifica se é uma funcao ou um intervalo
        
        if tipodeInput == TypeInput.function {
            
            // Utiliza o readline para pegar a equação digitada pelo usúario.
            if input.count != 0 {
                mostraOpcoes(type: TypeInput.function, input: input)
                formula = input
            } else {
                print("Dado invalido, digite novamente:")
                continue
            }
        }
        else if tipodeInput == TypeInput.interval {
            
            // Utiliza o readline para pegar os intervalos digitados pelo usúario.
            intervalos = input.components(separatedBy: ",")
            if intervalos.count == 2 && intervalos[0] < intervalos[1]{
                
                //Verifica de os intervalos foram digitados corretamente
                guard let primeiroIntervalo = Double(intervalos[0]) else {
                    print("Primeiro intervalo inválido, digite novamente:")
                    continue
                }
                guard let segundoIntervalo = Double(intervalos[1]) else {
                    print("Segundo intervalo inválido, digite novamente:")
                    continue
                }
                
                
                range = primeiroIntervalo ... segundoIntervalo
                mostraOpcoes(type: TypeInput.interval, input: input)
            }
            else {
                print("Dados invalidos, digite novamente:")
            }
        }
    }
}

func Menu() {
    
    print("Calculo de integrais: 📚🧐 \n")

    print("""
    Esse script resolve integrais definidas.
    Digite + para adição
    Digite - para subtração
    Digite * para multiplicação
    Digite / para divisão
    Digite x para representar a variavel da função
    Digite ( ) para inserir parenteses
    Exemplo de um modelo de função: x + 1 / ( 2*x - 5 )

    """)

    print("""
    Entre com a sentença matemática:
    """)

    inputUsuario(tipodeInput: TypeInput.function)

    // Utiliza o readline para pegar os intervalos digitados pelo usúario.
    print("""
    Agora, digite os intervalos:
    ex: 1,2
    """)
    
    inputUsuario(tipodeInput: TypeInput.interval)
}

while(true){
    // Iniciando programa inicial
    Menu()

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
    
    
    print("""

    -------------------------------------------------------\n
    Deseja resolver outra integral?
    ✅  Caso sim, digite "sim" ou  "s"
    ❌  Caso não, digite qualquer outra tecla
    """)
    
    let inputFinal: String? = readLine()
    guard inputFinal!.lowercased() == "sim" || inputFinal!.lowercased() == "s" else {
        break
    }
    
}

