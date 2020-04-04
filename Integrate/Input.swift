
import Foundation

// enum para representar se o dado e funcao ou intervalo
enum TypeInput{
    case function
    case interval
    case integral
    
    var description: String {
        switch self {
        case .function:
            return "a funçao"
        case .interval:
            return "os intervalos"
        case .integral:
            return "integral"
        }
    }
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
        else if tipodeInput == TypeInput.integral {
            calculando = false
            break
        }
    }
}
