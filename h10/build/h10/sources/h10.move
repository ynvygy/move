module basic_address::h10 {
    use aptos_framework::object::{Self, ObjectCore};
    use std::signer;
    use std::string::{String,utf8};
    use aptos_framework::event;
    use std::error;
    use std::debug;

    #[event]
    struct GetObjectAddress has drop, store {
        object_address: address
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct ExampleObject has key {
        balance: u64
    }

    const ASSET_SYMBOL: vector<u8> = b"TEST";

    public entry fun create_example_named_object(user: &signer) {
        let constructor_ref = object::create_named_object(user, ASSET_SYMBOL);

        let obj_signer = object::generate_signer(&constructor_ref);

        move_to(user, ExampleObject { balance: 20  });

        let get_address = object::address_from_constructor_ref(&constructor_ref);

        event::emit(GetObjectAddress{object_address: get_address})
    }

    #[view]
    public fun get_named_object_address(user: address): address {
        object::create_object_address(&user, ASSET_SYMBOL)
    }

    #[test(account = @0x1)]
    public fun test_get_named_object_address(account: signer) {
        // Call the create_example_object function

        create_example_named_object(&account);
        let caller_address = signer::address_of(&account);
        assert!(exists<ExampleObject>(caller_address), error::not_found(0));
    }
}
