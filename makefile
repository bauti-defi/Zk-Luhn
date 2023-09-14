
# Makefile

compile:
	circom circuits/luhn16.circom -o build/ --r1cs --wasm --sym --c

# generate witness
witness:
	node build/luhn16_js/generate_witness.js build/luhn16_js/luhn16.wasm input.json build/witness.wtns

ptau:
	./scripts/ptau.sh

ptau2:
	./scripts/ptau-phase2.sh

# generate proof
generate:
	snarkjs groth16 prove build/luhn16_final.zkey build/witness.wtns out/proof.json out/public.json

sol-verifier:
	snarkjs zkey export solidityverifier build/luhn16_final.zkey contracts/Luhn16Verifier.sol

# run with ptau ceremony
run-c:
	make ptau
	make run

# run without ptau ceremony
run:
	make compile
	make witness
	make ptau2
	make generate
	make sol-verifier

clean:
	@echo "Deleting all files in contracts and build directories..."
	-rm -rf contracts/*
	-rm -rf build/*
	-rm -rf out/*
