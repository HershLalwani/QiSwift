import Accelerate

public class s_qcircuit {

    private var qubits: [s_qubit]
    
    init(_ qubits: [s_qubit]) {
        self.qubits = qubits
    }
    
    public func x(_ qubit: Int) {
        var temp = complex(0, 0)
        temp = qubits[qubit].alpha
        self.qubits[qubit].alpha = qubits[qubit].beta
        self.qubits[qubit].beta = temp
    }
    
    public func h(_ qubit: Int) {
        let alpha = qubits[qubit].alpha
        let beta = qubits[qubit].beta
        let h = 1 / sqrt(2)
        let alphaNew = complex(h * (alpha.real + beta.real), h * (alpha.imag + beta.imag))
        let betaNew = complex(h * (alpha.real - beta.real), h * (alpha.imag - beta.imag))
        self.qubits[qubit].alpha = alphaNew
        self.qubits[qubit].beta = betaNew
    }

    public func y(_ qubit: Int) {
        let alpha = qubits[qubit].alpha
        let beta = qubits[qubit].beta
        let alphaNew = complex(-beta.imag, beta.real)
        let betaNew = complex(alpha.imag, -alpha.real)
        self.qubits[qubit].alpha = alphaNew
        self.qubits[qubit].beta = betaNew
    }

    public func z(_ qubit: Int) {
        let beta = qubits[qubit].beta
        let betaNew = complex(-beta.real, -beta.imag)
        self.qubits[qubit].beta = betaNew
    }

    public func s(_ qubit: Int) {
        let beta = qubits[qubit].beta
        let betaNew = complex(beta.imag, -beta.real)
        self.qubits[qubit].beta = betaNew
    }

    public func t(_ qubit: Int) {
        let beta = qubits[qubit].beta
        let betaNew = complex(-beta.imag, beta.real)
        self.qubits[qubit].beta = betaNew
    }

    public func measure() -> Int {
        let probabilities = self.qubits.map { $0.alpha.real * $0.alpha.real + $0.alpha.imag * $0.alpha.imag }
        let random = Double.random(in: 0...1)
        var sum = 0.0
        for i in 0..<probabilities.count {
            sum += probabilities[i]
            if random < sum {
                return i
            }
        }
        return -1
    }
}