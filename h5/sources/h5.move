module basic_address::h5 {
    // use std::debug::print;

    struct Asset has drop {
      value: u64,
      flag: u8
    }

    fun build_asset_function(value: u64, flag: u8) : Asset {
      assert!(value > 100, 17);
      assert!(flag < 2, 17);
      // assert!(flag == 0 || flag == 1, 17);
      create(value, flag)
    }

    fun create(value: u64, flag: u8) : Asset {
      Asset{value, flag}
    }

    #[test]
    fun normal_parameters_pass(){
        build_asset_function(150, 1);
    }

    #[test, expected_failure]
    fun flag_over_one_fails(){
        build_asset_function(150, 2);
    }

    #[test, expected_failure]
    fun value_under_one_hundred_fails(){
        build_asset_function(50, 1);
    }
}
