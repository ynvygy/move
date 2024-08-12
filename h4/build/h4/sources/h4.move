module addr_1::h4 {
    struct MyData has key, store {
        value: u8
    }

    fun init_module(sender: &signer) {
        // here we can initialise the data
        let val = aptos_framework::randomness::u8_range(0, 100);
        let my_data = MyData {value: val};
        move_to(sender, my_data)
    }
}
