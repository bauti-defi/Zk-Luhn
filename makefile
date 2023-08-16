
# Makefile

OUTPUT = main

compile:
	circom circuits/luhn16.circom -o build/ --r1cs --wasm --sym --c

witness:
	node build/luhn16_js/generate_witness.js build/luhn16_js/luhn16.wasm input.json build/luhn16_js/witness.wtns

ptau:
	./scripts/ptau.sh

generate:
	./scripts/ptau-phase2.sh

clean:
	rm -f $(OUTPUT).r1cs $(OUTPUT).wasm $(OUTPUT).sym $(OUTPUT).c
