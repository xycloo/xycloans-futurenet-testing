# use this is you're using the CLI downloaded form releases or built.
# alias soroban="/Users/tommasodeponti/Downloads/soroban"

# After having deployed a `simple.wasm` (https://github.com/xycloo/xycloans/tree/main/examples/simple), set the contract's id as RECEIVER and set the strkey encoded contract's id as RECEIVER_ADDR (you can use https://strkey-encode.xycloo.com/)
RECEIVER="6e936c4a7490ece4eb0816907d1e7ce9ab8e3cd502b15c6f4daacfb835b13327"
RECEIVER_ADDR="CBXJG3CKOSIOZZHLBALJA7I6PTU2XDR42UBLCXDPJWVM7OBVWEZSO2YA"


PROXY="7fd59b4aa2c634157a08727406e37dc8b4a4b68c4ea4e747ea4bf17073f18f6e"
PROXY_ADDR="CB75LG2KULDDIFL2BBZHIBXDPXELJJFWRRHKJZ2H5JF7C4DT6GHW4PJQ"
FLASH_LOAN_ADDR="CBXLI4HIOKWWOUT5OHCCQYDSCLOVGBWXCGFVI44SC3BJA6QHFJFIKM7R"
FLASH_LOAN="6eb470e872ad67527d71c428607212dd5306d7118b54739216c2907a072a4a85"

# Your settings:
FEES_ADDR="GDAJ7LTOQLTAQCDKHTI3MXSY6LNQZE4OP2ZZGVTZLIONJ6D3Y6WSHBCQ"
FEES_ADDR_SECRET="SDOTFZRK3TPVMBWGOWBZQA7DHZOFQGGZ73NJTOQZQDRCDTVRIGRBN4KG"
BORROWER_ADDR="GDCZNP76XCMXRTLBTL4AESVN4XBJUWUYIDBRZG2CEWKY5RI5AFQW5ZSK"
BORROWER_SECRET="SB3YEWVNEGSPARBL2E3NPXFPGCPBNB4UUDXKSYFGEPVLRG2IJ6E3AHJV"
AMOUNT=10000000000 # we're borrowing 1000 XLM

# Set parameters for the receiver contract
soroban contract invoke --id $RECEIVER --secret-key $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn init -- --token_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --fl_address "$FLASH_LOAN_ADDR" --amount $AMOUNT

# Execute the flash loan borrow
soroban contract invoke --id $PROXY --secret-key $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn borrow -- --token_contract_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --amount $AMOUNT --receiver_contract_id "$RECEIVER" --receiver_address "$RECEIVER_ADDR"

echo "Receiver contract balance: "

soroban contract invoke --id d93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813 --secret-key $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn balance -- --id "$RECEIVER_ADDR"

