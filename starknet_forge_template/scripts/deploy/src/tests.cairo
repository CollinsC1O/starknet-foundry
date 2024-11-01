// use sncast_std::{
//     declare, declare::DeclareResult,
//     deploy, deploy::DeployResult,
//     get_nonce,
//     get_balance,
//     ContractClassType,
// };
// use core::result::ResultTrait;

// #[test]
// fn test_get_nonce() {
//     let nonce = get_nonce();
//     assert(nonce.is_ok(), 'Failed to get nonce');
// }

// #[test]
// fn test_get_balance() {
//     let balance = get_balance();
//     assert(balance.is_ok(), 'Failed to get balance');
// }

// #[test]
// fn test_declare_contract() {
//     let declare_result = declare("HelloStarknet", ContractClassType::V2);
//     assert(declare_result.is_ok(), 'Declaration failed');

//     let result = declare_result.unwrap();
//     assert(result.class_hash != 0, 'Invalid class hash');
// }

// #[test]
// fn test_deploy_contract() {
//     // First declare the contract
//     let declare_result = declare("HelloStarknet", ContractClassType::V2).unwrap();

//     // Then try to deploy it
//     let constructor_calldata = array![];
//     let salt = 0x1234;

//     let deploy_result = deploy(
//         declare_result.class_hash,
//         constructor_calldata.span(),
//         salt,
//         true
//     );

//     assert(deploy_result.is_ok(), 'Deployment failed');
//     let result = deploy_result.unwrap();
//     assert(result.contract_address != 0, 'Invalid contract address');
//     assert(result.transaction_hash != 0, 'Invalid transaction hash');
// }

// use core::option::OptionTrait;
// use core::result::ResultTrait;
// use array::ArrayTrait;
// use snforge_std::{declare, deploy, ContractClassType};

// #[test]
// fn test_declare_contract() {
//     let declare_tx = declare('HelloStarknet', ContractClassType::V2);
//     assert(declare_tx.is_ok(), 'Declaration failed');

//     let result = declare_tx.unwrap();
//     assert(result.class_hash != 0, 'Invalid class hash');
// }

// #[test]
// fn test_deploy_contract() {
//     // First declare
//     let declare_tx = declare('HelloStarknet', ContractClassType::V2);
//     let declare_result = declare_tx.unwrap();

//     // Then deploy
//     let mut calldata = ArrayTrait::new();
//     let salt = 0x1234;

//     let deploy_tx = deploy(
//         declare_result.class_hash,
//         calldata.span(),
//         salt,
//         true
//     );

//     assert(deploy_tx.is_ok(), 'Deployment failed');
//     let result = deploy_tx.unwrap();
//     assert(result.contract_address != 0, 'Invalid contract address');
//     assert(result.transaction_hash != 0, 'Invalid transaction hash');
// }

use array::ArrayTrait;
use core::result::ResultTrait;
use snforge_std::declare::ContractClass;

#[test]
fn test_contract_deployment() {
    let contract_class = ContractClass::from_path('HelloStarknet');
    let declare_result = contract_class.declare();

    assert(declare_result.is_ok(), 'Declaration failed');

    let mut calldata = ArrayTrait::new();
    let deployment = contract_class.deploy(@calldata);

    assert(deployment.is_ok(), 'Deployment failed');
}

#[test]
fn test_declare_contract() {
    let contract = snforge_std::declare('HelloStarknet');
    match contract {
        Result::Ok(declared_contract) => {
            assert(declared_contract.class_hash != 0, 'Invalid class hash');
        },
        Result::Err(_) => { panic_with_felt252('Declaration failed') }
    }
}

#[test]
fn test_deploy_contract() {
    // First declare the contract
    let contract = snforge_std::declare('HelloStarknet');
    let declared_contract = contract.unwrap();
    let class_hash = declared_contract.class_hash;

    // Then deploy it
    let mut calldata = ArrayTrait::new();
    let salt = 0x1234;
    let deployment = snforge_std::deploy(class_hash, calldata.span(), salt, true);

    match deployment {
        Result::Ok(deployed_contract) => {
            // Verify contract address
            assert(deployed_contract.contract_address != 0, 'Invalid contract address');
            // Verify transaction hash
            assert(deployed_contract.transaction_hash != 0, 'Invalid transaction hash');
        },
        Result::Err(_) => { panic_with_felt252('Deployment failed') }
    }
}

#[test]
fn test_deployment_with_different_salt() {
    // Test with a different salt value
    let contract = snforge_std::declare('HelloStarknet').unwrap();
    let mut calldata = ArrayTrait::new();
    let salt = 0x5678; // Different salt

    let deployment = snforge_std::deploy(contract.class_hash, calldata.span(), salt, true);

    assert(deployment.is_ok(), 'Deployment should succeed');
}
