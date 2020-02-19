# etherbalance

An ethereum ether and [ERC20](https://eips.ethereum.org/EIPS/eip-20) token balance monitoring application.

See the [example config file](example_config.toml), and command line options (`cargo run -- --help`):

```
FLAGS:
    -h, --help              Prints help information
        --print-balances    Print balances to stdout on update
    -V, --version           Prints version information

OPTIONS:
        --bind <bind>                          Serve the prometheus metrics at this address [default: 0.0.0.0:8080]
        --config <config>                      Path to the config file
        --node <node>                          Url of the ethereum node to communicate with
        --update-interval <update-interval>    Update the balances in this interval in seconds [default: 100]
```

The balance information is exposed as a prometheus metric at `/metrics`. With the example config file:

```
# HELP etherbalance_balance The ether or IERC20 balance of an ethereum address.
# TYPE etherbalance_balance gauge
etherbalance_balance{address_name="company-wallet",token_name="ether"} 74050712600851690000000
etherbalance_balance{address_name="company-wallet",token_name="usdc"} 16964294292618
etherbalance_balance{address_name="company-wallet",token_name="usdt"} 65753664330824
etherbalance_balance{address_name="personal-wallet",token_name="ether"} 2330958999638355500000000
etherbalance_balance{address_name="personal-wallet",token_name="usdc"} 6551827878171
etherbalance_balance{address_name="personal-wallet",token_name="usdt"} 169538279813210
# HELP etherbalance_last_update Unix time of last update of balances.
# TYPE etherbalance_last_update gauge
etherbalance_last_update 1582635522.0656123
```

And additionally on stdout with `--print-balances`:

```
address company-wallet ether balance is 74050712600851692475483
address company-wallet usdt balance is 65753664330824
address company-wallet usdc balance is 16964294292618
address personal-wallet ether balance is 2330958999638355689873774
address personal-wallet usdt balance is 169538279813210
address personal-wallet usdc balance is 6551827878171
```

This information is updated in the background with the specified
`--update-interval`. It is not updated on metric request as is custom for
Prometheus metrics because we want to avoid overloading the ethereum node.

# Development

[contracts/IERC20.sol](contracts/IERC20.sol) is [OpenZeppelin's version of IERC20](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC20).
It is used to generate [contracts/IERC20.json](contracts/IERC20.json) which in
turn is used by ethcontract-rs to generate the rust smart contract bindings.
This file is included in the repository instead of being generated when building
to make building as easy as possible. The smart contract is not expected to
change so the file will not need updating.