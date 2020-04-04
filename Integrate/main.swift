
import Foundation

//Variaveis Globais
var intervalos: [String] = []
var range: ClosedRange<Double> = 0 ... 0
var formula: String = ""
var calculando: Bool = true

while(calculando){
    //Iniciando programa inicial
    Menu()

    Integrate()
    
    mostraOpcoes(type: TypeInput.integral)
    
}

