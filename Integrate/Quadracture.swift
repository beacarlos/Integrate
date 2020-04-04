
import Foundation
import Accelerate

// extension pra uso da nsexpression
extension String {
    var expression: NSExpression {
        return NSExpression(format: self)
    }
}

func Integrate(){
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

}

