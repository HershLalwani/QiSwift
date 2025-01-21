import Foundation
import Accelerate

var stateUp = s_qubit(complex(1, 0), complex(0, 0))
var stateDown = s_qubit(complex(0, 0), complex(1, 0))
var state_x = s_qubit(complex(1, 0), complex(1, 0))
var state_y = s_qubit(complex(1, 0), complex(0, 1))

var sv_up = s_sv(stateUp)
var sv_down = s_sv(stateDown)
var sv_x = s_sv(state_x)
var sv_y = s_sv(state_y)

var sv_up_bra = sv_up.conj().T()
var sv_down_bra = sv_down.conj().T()
var sv_x_bra = sv_x.conj().T()
var sv_y_bra = sv_y.conj().T()

print("Initial x state: \n \(sv_x)")
print("Initial y state: \n \(sv_y)")
print("X After Hermitian conjugate: \n \(sv_x_bra)")
print("Y After Hermitian conjugate: \n \(sv_y_bra)")

print(sv_x_bra * sv_x)

sv_up.normalize()
sv_down.normalize()
sv_x.normalize()
sv_y.normalize()

sv_up_bra = sv_up.conj().T()
sv_down_bra = sv_down.conj().T()
sv_x_bra = sv_x.conj().T()
sv_y_bra = sv_y.conj().T()

print("==================AFTER NORMALIZATION=====================")

print("Initial x state: \n \(sv_x)")
print("Initial y state: \n \(sv_y)")
print("X After Hermitian conjugate: \n \(sv_x_bra)")
print("Y After Hermitian conjugate: \n \(sv_y_bra)")

print(sv_x_bra * sv_y)