import Foundation
import simd

var qbit1 = s_qubit(complex(1, 0), complex(0, 0))
var qbit2 = s_qubit(complex(1, 0), complex(0, 0))
var qbit3 = s_qubit(complex(1, 0), complex(0, 0))


var qc = s_qcircuit([qbit1, qbit2, qbit3])

qc.h(0)


var one = 0
var zero = 0
print(qc.getQubits())
for _ in 0..<100 {
    if qc.measure() == 0 {
        zero += 1
    } else {
        one += 1
    }
}

print("Zero: \(zero), One: \(one)")