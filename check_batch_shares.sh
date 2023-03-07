# use this is you're using the CLI downloaded form releases or built.
alias soroban="/Users/tommasodeponti/Downloads/soroban"

VAULT="7a727ce9308c4fa5f94881f0b1085a74d073d94e73404d09e919d7c3077a20ca"
LP_SECRET="SCQIBENLICW73TJKPZMUMZGROQTEBU552C4G5JE27LADE3W6ZHKJL5T3"

soroban contract invoke --id $VAULT --secret-key $LP_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn get_shares -- --id "$1" --batch_n $2
