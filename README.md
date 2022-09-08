# zk-test
Repo for testing stark.js

##  Setup circom

```bash
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
cargo build --release
cargo install --path circom
export $HOME/.cargo/bin
```

## Setup

```bash
export CEREMONY_DIR=./.tau
yarn ceremony
```

## Compile test

```bash
mkdir -p ./src/test
circom ./src/circuit/test.circom --r1cs --wasm --sym --output  ./src/test
npx snarkjs r1cs info ./src/test/test.r1cs
npx snarkjs r1cs print ./src/test/test.r1cs ./src/test/test.sym
```

## Export r1cs to JSON

```bash
npx snarkjs r1cs export json ./src/test/test.r1cs ./src/test/test.r1cs.json
```

## Calculate the witness

Create `./src/test/input.json` with the content:

```json
{ "a": 3, "b": 11 }
```

Generate witness

```bash
node ./src/test/test_js/generate_witness.js ./src/test/test_js/test.wasm ./src/test/input.json ./src/test/witness.wtns
```

## Setup Plonk

Create zkey

```bash
npx snarkjs plonk setup ./src/test/test.r1cs $CEREMONY_DIR/pot12_final.ptau ./src/test/test_circuit_final.zkey
```

Export zkey

```bash
npx snarkjs zkey export verificationkey ./src/test/test_circuit_final.zkey ./src/test/verification_key.json
```

## Create the proof

```bash
npx snarkjs plonk prove ./src/test/test_circuit_final.zkey ./src/test/witness.wtns ./src/test/proof.json ./src/test/public.json
```

## Verify the proof

```bash
npx snarkjs plonk verify ./src/test/verification_key.json ./src/test/public.json ./src/test/proof.json
```

## Create simple verifier contract

```bash
npx snarkjs zkey export solidityverifier ./src/test/test_circuit_final.zkey ./src/test/verifier.sol
```

## Simulate verification call

```bash
npx snarkjs zkey export soliditycalldata ./src/test/public.json ./src/test/proof.json
```
