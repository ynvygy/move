module basic_address::h7 {
    use std::signer;
    struct TokenAsset has key {
        value: u8
    }

    public entry fun create_Asset(account: &signer, value: u8) {
        let newToken: TokenAsset = create(value);
        move_to(account, newToken);
    }

    fun create(value: u8): TokenAsset {
        TokenAsset{value}
    }

    // Retrieve by address
    fun retrieve_token_value(addr: address): u8 acquires TokenAsset {
        assert!(exists<TokenAsset>(addr), 17);
        borrow_global<TokenAsset>(addr).value
    }

    // Retrieve by signer
    fun view_Asset(account: &signer): u8 acquires TokenAsset {
        let tokenAsset = borrow_global<TokenAsset>(signer::address_of(account));
        tokenAsset.value
    }

    #[test(account = @0x1)]
    fun test_create_and_retrieve_token_asset(account: signer) acquires TokenAsset {
        let test_value: u8 = 42;
        create_Asset(&account, test_value);

        let retrieved_value = retrieve_token_value(signer::address_of(&account));

        assert!(retrieved_value == test_value, 1);
    }

    #[test(account = @0x1), expected_failure]
    fun test_fail_retrieve_token_asset(account: signer) acquires TokenAsset {
        retrieve_token_value(signer::address_of(&account));
    }

    #[test(account = @0x1)]
    fun test_create_and_retrieve_token_asset_two(account: signer) acquires TokenAsset {
        let test_value: u8 = 42;
        create_Asset(&account, test_value);

        let retrieved_value = view_Asset(&account);

        assert!(retrieved_value == test_value, 1);
    }

    #[test(account = @0x1), expected_failure]
    fun test_create_and_retrieve_token_asset_three(account: signer) acquires TokenAsset {
        view_Asset(&account);
    }
}
