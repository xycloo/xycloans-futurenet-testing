> all the secret keys in the below scripts are for demonstration purposes only and are not to be used in any environment which isn't the test network.

# Xycloans testing on Futurenet

> Since Sorban doesn't have an ecosysten of protocols yet, you won't be able to leverage flash loans in a real-use-case scenario as of now. 

In this write-up you'll find instructions to borrow your first flash loan on Soroban through XycLoans.

Before we start, remember that the latest version of XycLoans is now on Futurenet:

| Component        | Hash                                                             | Address                                                  |
|------------------|------------------------------------------------------------------|----------------------------------------------------------|
| proxy            | 7fd59b4aa2c634157a08727406e37dc8b4a4b68c4ea4e747ea4bf17073f18f6e | CB75LG2KULDDIFL2BBZHIBXDPXELJJFWRRHKJZ2H5JF7C4DT6GHW4PJQ |
| protocol account | N/A (will be replaced by governance contract)                    | GADHYKDDVZBD5DUKS4A6KKOFXEFUZ32PHLAMGDIAGY3STJUDYYZEMORK |
| xlm vault        | 7a727ce9308c4fa5f94881f0b1085a74d073d94e73404d09e919d7c3077a20ca | CB5HE7HJGCGE7JPZJCA7BMIILJ2NA46ZJZZUATIJ5EM5PQYHPIQMVOGW |
| xlm flash loan   | 6eb470e872ad67527d71c428607212dd5306d7118b54739216c2907a072a4a85 | CBXLI4HIOKWWOUT5OHCCQYDSCLOVGBWXCGFVI44SC3BJA6QHFJFIKM7R |


## Providing liquidity to the XLM pool
Since currently there only is an XLM vault/flash-loan pair, you're going to be able to only provide liquidity for XLM flash loans.

The process of depositing and becoming an owner of a part of the future yield of the flash loans is very simple as it only requires you to invoke one proxy function: the `deposit` function (https://github.com/xycloo/xycloans/blob/main/proxy/src/contract.rs#L92). Before calling this function though, you'll need an existing futurenet account with some XLM balance. You can go ahead and create and fund a brand-new futurenet account from https://laboratory.stellar.org/#account-creator?network=futurenet.

Then open the `deposit.sh` bash script, and change these three lines so that you're depositing an `AMOUNT` (remember these are stroops) from your `LP` (liquidity provider) account. For example:

```bash
# Your settings:
LP_SECRET="SCQIBENLICW73TJKPZMUMZGROQTEBU552C4G5JE27LADE3W6ZHKJL5T3"
LP="GBPZTUMOULFU4XVRMF6S34LIRISHH7EHJ5S7DKCS22XZCTRQY2VKBW6F"
AMOUNT=40000000000
```

After running it, you'll see that the proxy deposited successfully `AMOUNT` into the XLM vault (assuming `LP` had enough XLM balance) and that it returns the batch number of your fee shares (read more about fee shares in the [litepaper](https://github.com/xycloo/xycloans/blob/main/xycloans.pdf)).


## Withdrawing batch fee shares
Before withdrawing you can take a look at how many shares you have for your batch (for batch number `0`) with the `check_batch_shares.sh` script:

```
$ ./check_batch_shares.sh GBPZTUMOULFU4XVRMF6S34LIRISHH7EHJ5S7DKCS22XZCTRQY2VKBW6F 0
success
{"curr_s":"39999779407","deposit":"40000000000","init_s":"39979779407"}
```

Here, `curr_s` is the shares that currently exist for `GBPZTUMOULFU4XVRMF6S34LIRISHH7EHJ5S7DKCS22XZCTRQY2VKBW6F`'s batch `0`, and `init_s` where the shares that were minted for the batch initially (I've already withdrawn `20000000` stroops in the above example).

> Important: there seems to be a bug in the CLI when displaying the `BatchObj` struct as the value inside `curr_s` should be the one in `init_s` and the same goes for the other way round. You can check that the vault contract performs this operation correclty in this test (https://github.com/xycloo/xycloans/blob/main/proxy/tests/test.rs#L323).

When you want to withdraw fee shares from a batch you can use the `withdraw_batch.sh` script. Again, you'll need to modify some settings:

```bash
# Your settings:
LP_SECRET="same secret you used for the deposit"
LP="same public key you used for the deposit"
BATCH_N=0
SHARES=20000000
```

`BATCH_N` is the batch number, so in your case `0` since you havent withdrawn any fees yet. `SHARES` can be any number between 0 and the `current_s` number of the batch (as for the possible CLI bug we've described above, the shares will actually have to be between 0 and `init_s`).

After running the script the proxy will have forwarded your call to the vault, which has burned `SHARES` from batch `0` and minted some fresh shares (according the amount of burned shares `SHARES`) in a new batch `1`.

In fact, we can run `./check_batch_shares.sh GBPZTUMOULFU4XVRMF6S34LIRISHH7EHJ5S7DKCS22XZCTRQY2VKBW6F 1` to check this new batch:

```
success
{"curr_s":"19993903","deposit":"20000000","init_s":"19993903"}
```

## Borrowing a flash loan
If you want to try borrowing rather than lending, the `borrow.sh` script will help you borrow your first flash loan on Soroban.

First things first, you'll need to deploy the example receiver contract from https://github.com/xycloo/xycloans/tree/main/examples/simple. So, you'll need to clone the xycloans repo, then:

```
$ cd xycloans/receiver-standard
$ cargo +nightly build \
    --target wasm32-unknown-unknown \
    --release \
    -Z build-std=std,panic_abort \
    -Z build-std-features=panic_immediate_abort
$ cd examples/simple
$ cargo +nightly build \
    --target wasm32-unknown-unknown \
    --release \
    -Z build-std=std,panic_abort \
    -Z build-std-features=panic_immediate_abort
$ soroban contract deploy --wasm ../target/wasm32-unknown-unknown/release/simple.wasm --secret-key $YOUR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' 
```

Once you deployed the contract and have the contract's id hash, you'll need to open the `borrow.sh` script, set the contract hash id as the `RECEIVER` (line 5), then go to https://strkey-encode.xycloo.com/ to strkey encode the contract hash and set it as the `RECEIVER_ADDR` (line 6). 

Then, change the following lines changing the accounts for accounts that you have created on Futurenet. `AMOUNT` is the amount of stroops you are going to borrow.

```
# Your settings:
FEES_ADDR="GDAJ7LTOQLTAQCDKHTI3MXSY6LNQZE4OP2ZZGVTZLIONJ6D3Y6WSHBCQ"
FEES_ADDR_SECRET="SDOTFZRK3TPVMBWGOWBZQA7DHZOFQGGZ73NJTOQZQDRCDTVRIGRBN4KG"
BORROWER_ADDR="GDCZNP76XCMXRTLBTL4AESVN4XBJUWUYIDBRZG2CEWKY5RI5AFQW5ZSK"
BORROWER_SECRET="SB3YEWVNEGSPARBL2E3NPXFPGCPBNB4UUDXKSYFGEPVLRG2IJ6E3AHJV"
AMOUNT=10000000000 # we're borrowing 1000 XLM
```

Once you're done you're ready to run the script!

You should see the invocation executing successfully. You can also check the state of the chain after the borrow by looking at the XLM balance of the receiver contract (that should have 9.5 XLM since we xferred 10 XLM to it before borrowing (emulating that the receiver contract has earned 10 XLM from its operations) at line 25 of the script, of which 0.5 went to the vault as fees (0.05% of the borrowed amount)).

