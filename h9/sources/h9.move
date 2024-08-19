module basic_address::h9 {
    use aptos_framework::object;
    use std::signer;
    use std::string::{String,utf8};
    use aptos_framework::event;

    #[event]
    struct GetObjectAddress has drop, store {
        object_address: address
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct ExampleObject has key {
        name: String,
        balance: u64
    }

    public entry fun create_example_object(user: &signer, name : String, balance: u64) {
        // 1. Create a normal object
        let my_object = ExampleObject {
            name,
            balance
        };

        // 2. Create a signer for that object
        let caller_address = signer::address_of(user);
        let constructor_ref = object::create_object(caller_address);
        let object_signer = object::generate_signer(&constructor_ref);

        // 3. Move the resource to the object you created
        move_to(&object_signer, my_object);

        // 4. Use the constructor_ref to get the address of the object
        // let get_address = object::address_to_object(signer::address_of(&object_signer));
        let get_address = object::address_from_constructor_ref(&constructor_ref);

        // 5. Emit the address using the event you defined
        let object_address_event = GetObjectAddress {
            object_address: get_address
        };

        event::emit(object_address_event)
    }

    #[test(account = @0x1)]
    public fun test_create_example_object(account: signer) {
        create_example_object(&account, utf8(b"TestName"), 100);
    }
}
