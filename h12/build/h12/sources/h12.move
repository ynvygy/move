module basic_address::h12 {
    //use aptos_framework::object::{Self, Object};
    use aptos_token_objects::collection;
    use std::option;
    use std::string::{utf8};
    use aptos_token_objects::token::{create_named_token};

    const COLLECTION_NAME: vector<u8> = b"My Test Collection";
    const COLLECTION_DESCRIPTION: vector<u8> = b"My Collection Description";
    const TOKEN_DESCRIPTION: vector<u8> = b"My Token Description";
    const TOKEN_NAME: vector<u8> = b"MTT";

    fun init_module(account: &signer) {
        create_collection(account);
    }

    public entry fun create_collection(creator: &signer) {
        let max_supply = 1000;
        let collection_name = utf8(COLLECTION_NAME);

        collection::create_fixed_collection(
            creator,
            utf8(COLLECTION_DESCRIPTION),
            max_supply,
            collection_name,
            option::none(),
            utf8(b"https://mycollection.com"),
        );

        mint_token(creator)
    }

    public entry fun mint_token(creator: &signer) {
        let collection_name = utf8(COLLECTION_NAME);

        create_named_token(
            creator,
            collection_name,
            utf8(TOKEN_DESCRIPTION),
            utf8(TOKEN_NAME),
            option::none(),
            utf8(b"https://mycollection.com"),
        );
    }

    #[test(account = @0x1)]
    public fun test_init(account: signer) {
        init_module(&account);
    }
}
