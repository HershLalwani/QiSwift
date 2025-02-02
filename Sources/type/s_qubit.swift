import Foundation

struct s_qubit: Equatable, CustomStringConvertible {
    var alpha: complex
    var beta: complex

    public init(_ alpha: complex, _ beta: complex) {
        self.alpha = alpha
        self.beta = beta
    }

    public init(_ statevector: s_sv) {
        self.alpha = statevector.at(0, 0)
        self.beta = statevector.at(1, 0)
    }

    public mutating func measure() -> Int {
        let probabilities = [alpha.mag() * alpha.mag(), beta.mag() * beta.mag()]
        let random = Double.random(in: 0...1)
        if random < probabilities[0] {
            self.alpha = complex(1, 0)
            self.beta = complex(0, 0)
            return 0
        } else {
            self.alpha = complex(0, 0)
            self.beta = complex(1, 0)
            return 1
        }
    }

    var description: String {
        return "\(alpha)|0> + \(beta)|1>"
    }
}