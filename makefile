
# Makefile

OUTPUT = main

16:
	circom circuits/luhn16.circom --r1cs --wasm --sym --c

check:
	circom circuits/checkLuhn.circom --r1cs --wasm --sym --c

clean:
	rm -f $(OUTPUT).r1cs $(OUTPUT).wasm $(OUTPUT).sym $(OUTPUT).c
