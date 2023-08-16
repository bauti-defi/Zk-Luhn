
# Makefile

compile:
	circom circuits/luhn16.circom -o build/ --r1cs --wasm --sym --c

witness:
	node build/luhn16_js/generate_witness.js build/luhn16_js/luhn16.wasm input.json build/luhn16_js/witness.wtns

ptau:
	./scripts/ptau.sh

generate:
	./scripts/ptau-phase2.sh

sol-verifier:
	snarkjs zkey export solidityverifier build/luhn16_final.zkey contracts/Luhn16Verifier.sol

run-all:
	make compile
	make witness
	make ptau
	make generate
	make sol-verifier

clean:
	@echo "Deleting all files in contracts and build directories..."
	-rm -rf contracts/*
	-rm -rf build/*
