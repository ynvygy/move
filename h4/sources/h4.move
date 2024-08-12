module 0xa19a0ee429b5311629be59c030574e43ae7be8dd55a098e7475dd0fb8dd4e214::h4 {
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
