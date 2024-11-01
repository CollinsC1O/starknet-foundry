// use sncast_std::{
//     declare, declare::DeclareResult,    // For contract declaration functionality
//     deploy, deploy::DeployResult,       // For contract deployment functionality
//     get_nonce,                          // To fetch current nonce
//     get_balance,                        // To check account balance
//     ContractClassType,                  // Enum for contract class versions
// };

// fn main() {
//     // Getting the current nonce for deployment
//     let nonce = get_nonce().unwrap();
//     println!("Current nonce: {}", nonce);

//     // Checking account balance before deployment
//     let balance = get_balance().unwrap();
//     println!("Account balance: {}", balance);

//     let declare_result = declare("HelloStarknet", ContractClassType::V2).expect('Declaration
//     failed');
//     println!("Contract declared with class hash: {}", declare_result.class_hash);

//     // Preparing to deploy your contract
//     let constructor_calldata = array![];    // empty array, in case of contracts without a
//     constructor. You can add constructor arguments if needed let salt = 0x1234;
//     // Unique value to determine contract address 'unique salt'

//     // Deploying the declared contract
//     let deploy_result = deploy(
//         declare_result.class_hash,       // Use hash from declaration
//         constructor_calldata.span(),     // Constructor arguments
//         salt,                            // Unique salt value
//         true                             // set to true to make deployment address unique
//     ).expect('Deployment failed');

//     println!("Contract deployed at: {}", deploy_result.contract_address);   // Print contract
//     address println!("Transaction hash: {}", deploy_result.transaction_hash);       // Print
//     transaction hash
// }

// snforge_std = { git = "https://github.com/foundry-rs/starknet-foundry.git", tag = "v0.32.0" }
// sncast_std = { git = "https://github.com/foundry-rs/starknet-foundry.git", tag = "v0.32.0" }

// use starknet::ContractAddress;
// use array::ArrayTrait;
// use core::result::ResultTrait;
// use core::option::OptionTrait;
// use core::debug::PrintTrait;
// use core::traits::Into;
// use snforge_std::declare::{declare, ContractClass, ContractClassTrait};

// fn main() {
//     // Create contract class
//     let contract = declare('HelloStarknet');

//     match contract {
//         Result::Ok(declared) => {
//             'Class hash: '.print();
//             let hash: felt252 = declared.class_hash.into();
//             hash.print();

//             // Deploy contract
//             let mut constructor_args = ArrayTrait::new();
//             let deploy_result = declared.deploy(constructor_args).unwrap();

//             'Contract address: '.print();
//             deploy_result.contract_address.print();
//         },
//         Result::Err(_) => {
//             'Declaration failed'.print();
//             panic_with_felt252('failed to declare');
//         }
//     }
// }



use starknet::ContractAddress;
use array::ArrayTrait;
use core::result::ResultTrait;
use core::option::OptionTrait;
use core::debug::PrintTrait;
use snforge_std::{declare, ContractClass, ContractClassTrait};
use starknet::class_hash::ClassHash;
use starknet::{deploy_syscall, SyscallResultTrait};

// Script for deploying contracts
fn main() {
    // Step 1: Contract declaration
    let contract = snforge_std::declare('HelloStarknet');

    match contract {
        Result::Ok(declared) => {
            'Class hash: '.print();
            // Print class hash
            declared.class_hash.print();

            // Step 2: Contract deployment
            let mut constructor_calldata = ArrayTrait::new();
            let salt = 0x1234; // Unique salt for deployment
            let deployment = snforge_std::deploy(
                declared.class_hash,
                constructor_calldata.span(),
                salt,
                true // Make deployment address unique
            );

            match deployment {
                Result::Ok(deployed) => {
                    'Contract deployed successfully'.print();
                    'Contract address: '.print();
                    deployed.contract_address.print();
                    'Transaction hash: '.print();
                    deployed.transaction_hash.print();
                },
                Result::Err(_) => {
                    'Deployment failed'.print();
                    panic_with_felt252('Deployment failed');
                },
            }
        },
        Result::Err(_) => {
            'Declaration failed'.print();
            panic_with_felt252('Declaration failed');
        },
    }
}


// use starknet::ContractAddress;
// use array::ArrayTrait;
// use core::result::ResultTrait;
// use core::option::OptionTrait;
// use core::debug::PrintTrait;
// use snforge_std::{declare, start_prank, stop_prank, CheatTarget};
// use snforge_std::ContractClassTrait;
// use starknet::class_hash::ClassHash;

// // Script for deploying contracts
// fn main() {
//     // Step 1: Contract declaration
//     let contract = snforge_std::declare('HelloStarknet');

//     match contract {
//         Result::Ok(declared) => {
//             'Class hash: '.print();
//             // Print class hash - fixed access
//             declared.contract_class.class_hash.print();

//             // Step 2: Contract deployment
//             let mut constructor_calldata = ArrayTrait::new();
//             let salt = 0x1234; // Unique salt for deployment
//             let deployment = snforge_std::deploy(
//                 declared.contract_class.class_hash,
//                 constructor_calldata.span(),
//                 salt,
//                 true // Make deployment address unique
//             );

//             match deployment {
//                 Result::Ok(deployed) => {
//                     'Contract deployed successfully'.print();
//                     'Contract address: '.print();
//                     deployed.contract_address.print();
//                     'Transaction hash: '.print();
//                     deployed.transaction_hash.print();
//                 },
//                 Result::Err(_) => {
//                     'Deployment failed'.print();
//                     panic_with_felt252('Deployment failed');
//                 },
//             }
//         },
//         Result::Err(_) => {
//             'Declaration failed'.print();
//             panic_with_felt252('Declaration failed');
//         },
//     }
// }