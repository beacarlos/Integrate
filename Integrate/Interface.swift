
import Foundation

// funcao que utiliza o enum e realiza o melhor print de acordo com a entrada de dados
func mostraOpcoes(type: TypeInput, input: String = "") {
    if type == TypeInput.integral {
        
        print("""

        -------------------------------------------------------\n
        Deseja resolver outra \(type.description)?
        ✅  Caso sim, digite "sim" ou  "s"
        ❌  Caso não, digite qualquer outra tecla
        """)
        inputUsuario(tipodeInput: TypeInput.integral)
        
    }else{
        
        print("""

        Você digitou \(type.description): \(input)

        -------------------------------------------------------
        
        ✅  Correto? Digite "sim" ou "s".
        ❌  Não? Então digite novamente a função.
        """)
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

