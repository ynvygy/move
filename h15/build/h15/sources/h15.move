module basic_address::h15 {
    use std::signer::address_of;
    use std::signer;
    use std::error;
    use std::vector;
    use aptos_framework::randomness;
    use aptos_std::debug;

    struct DiceRollHistory has key, drop {
        rolls: vector<u64>,
    }

    #[lint::allow_unsafe_randomness]
    public entry fun roll_v0(_account: signer) {
        let _ = randomness::u64_range(0, 6);
    }

    #[randomness]
    entry fun roll(account: &signer) acquires DiceRollHistory {
        let addr = address_of(account);
        let roll_history = if (exists<DiceRollHistory>(addr)) {
            move_from<DiceRollHistory>(addr)
        } else {
            DiceRollHistory { rolls: vector[] }
        };
        let new_roll = randomness::u64_range(0, 6);

        // Check that the vector is not longer than 12
        if (vector::length(&roll_history.rolls) == 12) {
            vector::remove(&mut roll_history.rolls, 1);
        };
        vector::push_back(&mut roll_history.rolls, new_roll);
        move_to(account, roll_history);
    }

    #[view]
    fun roll_sum_of_6(account: address): u64 acquires DiceRollHistory {
        let roll_history = if (exists<DiceRollHistory>(account)) {
            move_from<DiceRollHistory>(account)
        } else {
            DiceRollHistory { rolls: vector[] }
        };

        if (vector::length(&roll_history.rolls) < 1) {
            return 0;
        };

        let len = vector::length(&roll_history.rolls);
        let result = vector::empty<u64>();

        let sum: u64 = 0;

        if (len < 6) {
            let i = 0;
            while (i < len) {
                let val: u64 = *vector::borrow(&roll_history.rolls, i);
                sum = sum + val;
                i = i + 1;
            }
        } else {
            let i = len - 6;
            while (i < len) {
                let val: u64 = *vector::borrow(&roll_history.rolls, i);
                sum = sum + val;
                i = i + 1;
            }
        };

        sum
    }

    #[randomness(max_gas=56789)]
    entry fun roll_v2(_account: signer) {
        let _ = randomness::u64_range(0, 6);
    }

    #[test(account = @0x1)]
    public fun test_roll_pass(account: signer) acquires DiceRollHistory {
        let caller_address = signer::address_of(&account);
        roll(&account);
        let roll_history = move_from<DiceRollHistory>(caller_address);
        assert(vector::length(&roll_history.rolls) == 1, 0);
    }

    #[test(account = @0x1), expected_failure]
    public fun test_roll_fail(account: signer) {
        let caller_address = signer::address_of(&account);
        assert!(exists<DiceRollHistory>(caller_address), error::not_found(0));
    }

    #[test(account = @0x1)]
    public fun test_roll_has_max_12_elements(account: signer) acquires DiceRollHistory {
        let caller_address = signer::address_of(&account);
        roll(&account); // 1
        roll(&account); // 2
        roll(&account); // 3
        roll(&account); // 4
        roll(&account); // 5
        roll(&account); // 6
        roll(&account); // 7
        roll(&account); // 8
        roll(&account); // 9
        roll(&account); // 10
        roll(&account); // 11
        roll(&account); // 12
        roll(&account); // 13
        let roll_history = move_from<DiceRollHistory>(caller_address);
        assert(vector::length(&roll_history.rolls) == 12, 0);
    }

    #[test(account = @0x1)]
    public fun test_sum_of_last_6(account: signer) acquires DiceRollHistory {
        let caller_address = signer::address_of(&account);
        roll(&account); // 1
        roll(&account); // 2
        roll(&account); // 3
        roll(&account); // 4
        roll(&account); // 5
        roll(&account); // 6
        let sum_of_6 = roll_sum_of_6(caller_address);

        assert(sum_of_6 > 6, 0);
        assert(sum_of_6 < 37, 0);
    }
}
