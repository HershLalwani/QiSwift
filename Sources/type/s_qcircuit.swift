import Foundation
import simd



public class s_qcircuit {

    private var qubits: [s_qubit]
    
    init(_ qubits: [s_qubit]) {
        self.qubits = qubits
    }

    func getQubits() -> [s_qubit] {
        return self.qubits
    }
    
    public func x(_ qubit: Int) {
        let svq = s_sv(qubits[qubit])
        let x = s_sv([complex(0, 0), complex(1, 0),
                            complex(1, 0), complex(0, 0)], 2, 2)
        let result = x * svq
        self.qubits[qubit] = s_qubit(result)
    }
    
    public func h(_ qubit: Int) {
        let svq = s_sv(qubits[qubit])
        let h = s_sv([complex(1/sqrt(2), 0), complex(1/sqrt(2), 0),
                            complex(1/sqrt(2), 0), complex(-1/sqrt(2), 0)], 2, 2)
        let result = h * svq
        self.qubits[qubit] = s_qubit(result)
    }

    public func y(_ qubit: Int) {
        let svq = s_sv(qubits[qubit])
        let y = s_sv([complex(0, 0), complex(0, -1), 
                            complex(0, 1), complex(0, 0)], 2, 2)
        let result = y * svq
        self.qubits[qubit] = s_qubit(result)
    }

    public func z(_ qubit: Int) {
        let svq = s_sv(qubits[qubit])
        let y = s_sv([complex(1, 0), complex(0, 0), 
                            complex(0, 0), complex(-1, 0)], 2, 2)
        let result = y * svq
        self.qubits[qubit] = s_qubit(result)
    }

    public func s(_ qubit: Int) {
        let beta = qubits[qubit].beta
        let betaNew = complex(beta.imag, -beta.real)
        self.qubits[qubit].beta = betaNew
    }

    public func t(_ qubit: Int) {
        let beta = qubits[qubit].beta
        let betaNew = complex(beta.real / sqrt(2), beta.imag / sqrt(2))
        self.qubits[qubit].beta = betaNew
    }

    public func cx(_ control: Int, _ target: Int) {
        if self.qubits[control].measure() == 1 {
            self.x(target)
        }
    }
    public func cz(_ control: Int, _ target: Int) {
        if self.qubits[control].measure() == 1 {
            self.z(target)
        }
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
        return 1
    }
}