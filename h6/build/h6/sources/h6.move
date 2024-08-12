module basic_address::h6 {

    struct TokenAsset has key {
        value: u8
    }

    public entry fun create_Asset(account: &signer) {
        let newToken: TokenAsset = create();
        move_to(account, newToken);
    }

    fun create(): TokenAsset {
        TokenAsset{value: 0}
    }
}
