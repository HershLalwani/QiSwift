import Foundation

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

    public init(_ rows: Int, _ cols: Int) {
        self.data = Array(repeating: complex(0, 0), count: rows * cols)
        self.rows = rows
        self.cols = cols
        self.isTransposed = false
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

    public mutating func set(_ row: Int, _ col: Int, _ value: complex) {
        let index = isTransposed ? col * rows + row : row * cols + col
        self.data[index] = value
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

    /* static func *(lhs: s_sv, rhs: s_sv) -> complex {
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
    } */
    static func *(lhs: s_sv, rhs: s_sv) -> s_sv {
        // Check if dimensions are compatible
        guard lhs.cols == rhs.rows else {
            fatalError("Incompatible dimensions for multiplication: (\(lhs.rows)×\(lhs.cols)) and (\(rhs.rows)×\(rhs.cols))")
        }
        
        // Create result with appropriate dimensions
        var result = s_sv(lhs.rows, rhs.cols)
        
        // Matrix × Matrix or Matrix × Vector multiplication
        for i in 0..<lhs.rows {
            for j in 0..<rhs.cols {
                var sum = complex(0, 0)
                for k in 0..<lhs.cols {
                    sum = sum + lhs.at(i, k) * rhs.at(k, j)
                }
                result.set(i, j, sum)
            }
        }
        
        // Special case: if both inputs are vectors (1×n and n×1), return scalar
        if lhs.rows == 1 && rhs.cols == 1 {
            return s_sv([result.at(0, 0)], 1, 1)
        }
        
        return result
    }
}