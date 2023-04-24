# use this is you're using the CLI downloaded form releases or built.
# alias soroban="/Users/tommasodeponti/Downloads/soroban"

# After having deployed a `simple.wasm` (https://github.com/xycloo/xycloans/tree/main/examples/simple), set the contract's id as RECEIVER and set the strkey encoded contract's id as RECEIVER_ADDR (you can use https://strkey-encode.xycloo.com/)
RECEIVER="1e5e838e77fb5989db19e56bc02989dce62eb7768d87857c4874d2358c64d573"
RECEIVER_ADDR="CAPF5A4OO75VTCO3DHSWXQBJRHOOMLVXO2GYPBL4JB2NENMMMTKXH3LL"

alias soroban="../soroban-tools/target/release/soroban"

PROXY="e2c37af75db0e7975360b13678f3dd3b733f2341019003b4b3692cd173111423"
PROXY_ADDR="CDRMG6XXLWYOPF2TMCYTM6HT3U5XGPZDIEAZAA5UWNUSZULTCEKCGDQ7"
FLASH_LOAN_ADDR="CBPOQYNBQBMW5SUA2VWVLSH7VR654GD7LICTWDKZPWC3E5ARHNHSYLO4"
FLASH_LOAN="5ee861a180596eca80d56d55c8ffac7dde187f5a053b0d597d85b274113b4f2c"

# Your settings:
FEES_ADDR="GDAJ7LTOQLTAQCDKHTI3MXSY6LNQZE4OP2ZZGVTZLIONJ6D3Y6WSHBCQ"
FEES_ADDR_SECRET="SDOTFZRK3TPVMBWGOWBZQA7DHZOFQGGZ73NJTOQZQDRCDTVRIGRBN4KG"
BORROWER_ADDR="GDCZNP76XCMXRTLBTL4AESVN4XBJUWUYIDBRZG2CEWKY5RI5AFQW5ZSK"
BORROWER_SECRET="SB3YEWVNEGSPARBL2E3NPXFPGCPBNB4UUDXKSYFGEPVLRG2IJ6E3AHJV"
AMOUNT=1000000000 # we're borrowing 100 XLM

# Set parameters for the receiver contract
soroban contract invoke --id $RECEIVER --source-account $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' -- init --token_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --fl_address "$FLASH_LOAN_ADDR" --amount $AMOUNT

# Let's say that the receiver contract is able to make a profit of 10 XLM:
soroban contract invoke --id d93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813 --source-account $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' -- xfer --from "$FEES_ADDR" --to "$RECEIVER_ADDR" --amount 100000000

# Execute the flash loan borrow
soroban contract invoke --id $FLASH_LOAN --source-account $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' -- borrow --receiver_id "$RECEIVER_ADDR" --amount $AMOUNT

# The receiver contract should be now left with (9.5 * k) XLM where k is the number of times this script was executed
echo "Receiver contract balance: "

soroban contract invoke --id d93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813 --source-account $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' -- balance --id "$RECEIVER_ADDR"

