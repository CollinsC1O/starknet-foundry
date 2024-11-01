mod deploy;
#[cfg(test)]
mod tests;

#[starknet::contract]
mod hello_starknet {
    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[external(v0)]
    fn get_balance(self: @ContractState) -> felt252 {
        self.balance.read()
    }
}
