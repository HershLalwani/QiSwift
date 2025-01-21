import Foundation
import Accelerate

struct complex: Equatable, CustomStringConvertible {
    var real: Double
    var imag: Double

    public init(_ real: Double, _ imag: Double) {
        self.real = real
        self.imag = imag
    }

    public init(_ real: Double) {
        self.real = real
        self.imag = 0
    }

    public func conj() -> complex {
        return complex(self.real, -self.imag)
    }

    public func mag() -> Double {
        return sqrt(self.real * self.real + self.imag * self.imag)
    }

    public func abs() -> Double {
        return sqrt(self.real * self.real + self.imag * self.imag)
    }

    static func +(lhs: complex, rhs: complex) -> complex {
        return complex(lhs.real + rhs.real, lhs.imag + rhs.imag)
    }

    static func -(lhs: complex, rhs: complex) -> complex {
        return complex(lhs.real - rhs.real, lhs.imag - rhs.imag)
    }

    static func *(lhs: complex, rhs: complex) -> complex {
        return complex(lhs.real * rhs.real - lhs.imag * rhs.imag, lhs.real * rhs.imag + lhs.imag * rhs.real)
    }

    static func /(lhs: complex, rhs: complex) -> complex {
        let denominator = rhs.real * rhs.real + rhs.imag * rhs.imag
        return complex((lhs.real * rhs.real + lhs.imag * rhs.imag) / denominator,
                       (lhs.imag * rhs.real - lhs.real * rhs.imag) / denominator)
    }

    static func ==(lhs: complex, rhs: complex) -> Bool {
        return lhs.real == rhs.real && lhs.imag == rhs.imag
    }

    static prefix func - (value: complex) -> complex {
        return complex(-value.real, -value.imag)
    }

    var description: String {
        if self.imag.sign == .minus {
            return "\(real)-\(Swift.abs(imag))i"
        }
        return "\(real)+\(imag)i"
    }
}

struct s_qubit: Equatable, CustomStringConvertible {
    var alpha: complex
    var beta: complex

    public init(_ alpha: complex, _ beta: complex) {
        self.alpha = alpha
        self.beta = beta
    }

    var description: String {
        return "\(alpha)|0> + \(beta)|1>"
    }
}

struct s_sv: Equatable, CustomStringConvertible {
    private var data: [complex]
    private var rows: Int
    private var cols: Int
    private var isTransposed: Bool

    public init(_ qubit: s_qubit) {
        self.data = [qubit.alpha, qubit.beta]
        self.rows = 2
        self.cols = 1
        self.isTransposed = false
    }

    public init(_ data: [complex], _ rows: Int, _ cols: Int, transposed: Bool = false) {
        self.data = data
        self.rows = rows
        self.cols = cols
        self.isTransposed = transposed
    }

    public func conj() -> s_sv {
        return s_sv(self.data.map { $0.conj() }, self.rows, self.cols, transposed: self.isTransposed)
    }

    public func T() -> s_sv {
        return s_sv(self.data, self.cols, self.rows, transposed: !self.isTransposed)
    }

    public mutating func normalize() {
        let norm = sqrt(self.data.map { $0.mag() * $0.mag() }.reduce(0, +))
        self.data = self.data.map { $0 / complex(norm) }
    }

    public func at(_ row: Int, _ col: Int) -> complex {
        let index = isTransposed ? col * rows + row : row * cols + col
        return data[index]
    }

    var description: String {
        var result = ""
        for i in 0..<rows {
            for j in 0..<cols {
                result += "\(at(i, j)) "
            }
            result += "\n"
        }
        return result
    }

    static func ==(lhs: s_sv, rhs: s_sv) -> Bool {
        return lhs.data == rhs.data && 
               lhs.rows == rhs.rows && 
               lhs.cols == rhs.cols && 
               lhs.isTransposed == rhs.isTransposed
    }

    static func *(lhs: s_sv, rhs: s_sv) -> complex {
        assert(lhs.cols == rhs.rows, "Dimensions must match for dot product")
        var result = complex(0, 0)
        for i in 0..<lhs.rows {
            for j in 0..<rhs.cols {
                var sum = complex(0, 0)
                for k in 0..<lhs.cols {
                    sum = sum + lhs.at(i, k) * rhs.at(k, j)
                }
                result = result + sum
            }
        }
        return result
    }
}