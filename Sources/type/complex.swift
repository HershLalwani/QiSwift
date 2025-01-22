import Foundation

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
