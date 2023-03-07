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
