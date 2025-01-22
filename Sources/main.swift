import Foundation
import simd

var qbit1 = s_qubit(complex(1, 0), complex(0, 0))
var qbit2 = s_qubit(complex(1, 0), complex(0, 0))

var qc = s_qcircuit([qbit1, qbit2])
qc.h(0)
qc.cnot(0, 1)

var one = 0
var zero = 0
print(qc.getQubits()[0], qc.getQubits()[1])
for _ in 0..<10000 {
    if qc.measure() == 0 {
        zero += 1
    } else {
        one += 1
    }
}

print("Zero: \(zero), One: \(one)")