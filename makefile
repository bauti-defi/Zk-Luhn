
# Makefile

OUTPUT = main

compile:
	circom circuits/luhn16.circom --r1cs --wasm --sym --c

witness:
	node luhn16_js/generate_witness.js luhn16_js/luhn16.wasm input.json luhn16_js/witness.wtns

ptau:
	./scripts/ptau.sh

clean:
	rm -f $(OUTPUT).r1cs $(OUTPUT).wasm $(OUTPUT).sym $(OUTPUT).c
