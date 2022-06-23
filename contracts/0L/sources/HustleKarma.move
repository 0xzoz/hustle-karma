/////////////////////////////////////////////////////////////////////////
// 0L Module
// Self Service Buffet
// Error code: 
/////////////////////////////////////////////////////////////////////////



//TODO: List
// worker should have a way to determine each DAO's payments and bonding curves should factor this
// MAYBE SOLVED --- fund bob - how to fund an account in test  --- Maybe Solution ---       Std::Diem::mint<GAS>(bob,100001)


// NOT TAGGED: Add previous payments to a list -could be warrior or the DAO itself, maybe both
// NOT TAGGED: Add point system to warrior
// NOT TAGGED: Incorporate reporting standards proposed by BlockScience - https://hackmd.io/MKskCuXbQT2t9s8lou_GKQ?view
// NOT TAGGED: Add pay function to police - 1 police = 1% of funds pa - only allowed to be withdrawn daily(make it a task to withdraw and to keep active)
//                                        - 2 police = 3% of funds pa 
//                                        - 3 police = 10% of funds pa
//                                        - any more decreases the police funds - to create a tight nit group            
// NOT TAGGED: Prevent rougue police - needs ideation
// NOT TAGGED: Social recovery - needs ideation



address 0x1 {
  module SelfService {
    use 0x1::GAS::GAS;
    use 0x1::Vector;
    use 0x1::Signer;
    use 0x1::DiemConfig;
    use 0x1::Diem;
    use 0x1::DiemAccount;

    const BOND_VALUE_IS_NOT_CORRECT: u64 = 1;
    const PAYMENT_NOT_IN_PAYMENTS_TABLE = 2;
    const KEY_DOES_NOT_EXIST = 3


    // gets initialized to a worker account when they submit a request for payment.
    struct Worker has key {
      pending_value: u64,
      pending_bond: u64,
      cumulative_payment: u64,
      details: vector<Detail>,
      receipts: vector<Receipt>
    }

    // allow a Worker to tag themselves
    struct Detail {
      key: vector<u8>,
      value: vector<u8>
    }

    // gets initialized to the DAO address on init_dao()
    struct Buffet has key {
      balance: Diem::Diem<GAS>,
      bond: Diem::Diem<GAS>, // Bond is here because it cannot be dropped
      funder_addr: vector<address>,
      funder_value: vector<u64>,
      police_list: vector<address>,
      pending_payments: vector<Payment>,
      max_uid: u64,
      receipts: vector<Receipt>
    }

    struct Payment has key, store, drop {
      uid: u64,
      worker: address,
      value: u64,
      epoch_requested: u64,
      epoch_due: u64,
      deliverable: vector<u8>,
      bond: u64, // NOTE: can't have the bond as the actual coin here, because this struct needs the 'drop' ability.
      rejection: vector<address>
    }

    struct Receipt has copy, store {
      dao_address: address,
      uid: u64,
      worker: address,
      value: u64,
      epoch_requested: u64,
      epoch_due: u64,
      deliverable: vector<u8>,
      bond: u64, 
      rejection: vector<address>
    }

    ///////// WORKER FUNCTIONS ////////

    public fun pay_me(_sender: &signer, _from_dao: address, _amount: u64, _deliverable: vector<u8>, _bond: u64) {

      maybe_init_worker(_sender);
      // if it exists get the buffet object
      if(!exists<Buffet>(_from_dao)){
        let b = borrow_global_mut<Buffet>(_from_dao);
        // calculate the date it will receive.
        // get current epoch
        let current_epoch = DiemConfig::get_current_epoch();
        let t = get_epochs_delay(_from_dao,_amount, _sender);
        // check if the bond is adequate.
        assert(get_bond_value(_from_dao,_amount, _sender) > _bond, BOND_VALUE_IS_NOT_CORRECT);

        // push the payment onto the list
        Vector::push_back(&mut b.pending_payments,Payment  {
          uid: b.max_uid + 1,
          worker: _sender,
          value: _amount,
          epoch_requested: current_epoch,
          epoch_due: current_epoch + t,
          deliverable: _deliverable,
          bond: _bond, // NOTE: can't have the bond as the actual coin here, because this struct needs the 'drop' ability.
          rejection: Vector::empty<address>()
        })

        //Deposit bond
        Diem::deposit<GAS>(&mut b.bond, _bond);
        //TODO: worker should have a way to determine each DAO's payments and bonding curves should facrtor this
        b.max_uid = b.max_uid + 1;
        // add values to worker
        let w = borrow_global_mut<Worker>(_sender);
        w.pending_value = w.pending_value + _amount;
        w.pending_bond = w.pending_bond + _bond;
        w.cumulative_payment = w.cumulative_payment + _amount; 

      }

    }

    // Lazy computation. Payments need to be released by someone (there is no automatic scheduler).
    // Anyone who wants to get paid can submit the release all. It will release all payments for everyone that is due.
    public fun release_all(_sender: &signer, _from_dao: address) {

      // iterate through all the list of pending payments, and do maybe_make_payment
      if(!exists<Buffet>(_from_dao)){
        let b = borrow_global_mut<Buffet>(_from_dao);
        let len = Vector::length<Payment>(&b.pending_payments);
        let current_epoch = DiemConfig::get_current_epoch();

        let i = 0;
        while (i < len) {
          let p = Vector::borrow<Payment>(&b.pending_payments, i);
          if( p.epoch_due <= current_epoch){
            maybe_make_payment(_from_dao, i );
          }
        }
      }

    }


    ////////// WORKER PROFILE FUNCTIONS //////////


    public fun add_detail(_sender: &signer, key: vector<u8>, value: vector<u8>) acquires Worker, Details {
      let w = borrow_global_mut<Worker>(_sender);
      Vector::push_back<Detail>(&w.details, Detail{
        key: key,
        value: value
      })
    }

    public fun remove_detail(_sender: &signer, key: vector<u8>) acquires Worker, Details {
      let w = borrow_global_mut<Worker>(_sender);
      let (t,i) = get_index_by_key(Signer::address_of(_sender));
      assert(!t, KEY_DOES_NOT_EXIST); 
        if (t) {
          Vector::remove<Detail>(&mut w.details, i);
        }
    }

    public fun change_detail(_sender: &signer, key: vector<u8>, value: vector<u8>) acquires Worker, Details {
      let w = borrow_global_mut<Worker>(_sender);
      let (t,i) = get_index_by_key(Signer::address_of(_sender));
      assert(!t, KEY_DOES_NOT_EXIST); 
        if (t) {
          Vector::remove<Detail>(&mut w.details, i);
          let d = Vector::borrow<Payment>(&mut w.details, i);
          d.value = value;
        }
 
    }



    ////////// SPONSOR FUNCTIONS //////////

    // anyone can fund the pool. It doesn't give you any rights or governance.
    public fun fund_it(_sender: &signer, _dao: address, _new_deposit: Diem::Diem<GAS>) acquires Buffet {
      let b = borrow_global_mut<Buffet>(_dao);
      Diem::deposit<GAS>(&mut b.balance, _new_deposit);
      Vector::push_back(&mut b.funder_addr, Signer::address_of(_sender));
      Vector::push_back(&mut b.funder_value, _new_deposit);
    }

    ////////// MANAGMENT FUNCTIONS //////////

    // a DAO can initialize their address with this state.
    // all transactions in the future need to reference the DAO address
    // this also creates the first Police address, which can subsequently onboard other people.
    public fun init_dao(_sender: &signer) {
      let new_buffet = Buffet {
        balance: Diem::zero<GAS>(),
        bond: Diem::zero<GAS>(),
        funder_addr: Vector::empty<address>(),
        funder_value: Vector::empty<u64>(),
        police_list: Vector::empty<address>(),
        pending_payments: Vector::empty<Payment>(),
        max_uid: 0,
        receipts: Vector::empty<Receipt>(),
      };
      move_to<Buffet>(_sender, new_buffet)
    }

    // it takes one police member to reject a payment.
    public fun reject_payment(_dao_addr: address, _sender: &signer, _uid: u64) acquires Buffet {
      if (is_police(_dao_addr, Signer::address_of(_sender))) {
        let (t, i) = get_index_by_uid(_dao_addr, _uid);
        if (t) {
          let b = borrow_global_mut<Buffet>(_dao_addr);
          Vector::remove(&mut b.pending_payments, i);
        }
      };
    }

    // police can explicitly approve a payment faster
    public fun expedite_payment(_dao_addr: address, _sender: &signer, _uid: u64) acquires Buffet {
      if (is_police(_dao_addr, Signer::address_of(_sender))) {
        maybe_make_payment(_dao_addr, _uid);
      };
    }

    // if you are on the list you can add another police member
    public fun add_police(_dao_addr: address, _sender: &signer, _new_police: address) acquires Buffet{
      if (is_police(_dao_addr, Signer::address_of(_sender))) {
        let b = borrow_global_mut<Buffet>(_dao_addr);
        Vector::push_back<address>(&mut b.police_list, _new_police);
      }

    }

    // if you are on the list you can remove another police member
    public fun remove_police(_dao_addr: address, _sender: &signer, _out_police: address) acquires Buffet {
      if (is_police(_dao_addr, Signer::address_of(_sender))) {
        let b = borrow_global_mut<Buffet>(_dao_addr);
        let (t, i) = Vector::index_of<address>(&b.police_list, &_out_police);
        if (t) {
          Vector::remove<address>(&mut b.police_list, i);
        }
       
      }
    }

    ////////// CALCS //////////

    fun get_bond_value(_dao_addr: address, _amount: u64 _sender: &signer): u64 {
      //curve increases as the % amount that the sender requests compares to the total dao reserve 
      let w = borrow_global<Worker>(_sender);
      let d = borrow_global<Buffet>(_dao_addr);
      ((w.balance + amount) / d.balance) * amount
    }

    fun get_epochs_delay(_dao_addr: address, _amount: u64 _sender: &signers): u64 {
        //starting at 1 epoch, the number of days increases with the % of the dao reserve
        let w = borrow_global<Worker>(_sender);
        let d = borrow_global<Buffet>(_dao_addr);
        let days: u64  = if ((w.balance + amount) == 0)  1 else (((w.balance + amount) / d.balance) * 10).ceil();
        days 
    }

    ///////// PRIVATE FUNCTIONS ////////
    fun maybe_make_payment(_dao_addr: address, _uid: u64) acquires Buffet {
      let (t, i) = get_index_by_uid(_dao_addr, _uid);
      assert(!t, PAYMENT_NOT_IN_PAYMENTS_TABLE); 
      let b = borrow_global_mut<Buffet>(_dao_addr);
      let p = Vector::borrow<Payment>(&b.pending_payments, i);
      if (p.epoch_due >= DiemConfig::get_current_epoch()) {
        DiemAccount:withdraw_from_balance<GAS>(_dao_addr, p.worker, b.balance, p.value);
        DiemAccount:withdraw_from_balance<GAS>(_dao_addr, p.worker, b.bond, p.bond);
      };

      //record payment information to a receipt.
      let r = Receipt{
              dao_address: _dao_addr,
              uid: p.uid,
              worker: p.worker,
              value: p.value,
              epoch_requested: p.epoch_requested,
              epoch_due: p.epoch_due,
              deliverable: p.deliverable,
              bond: p.bond, 
              rejection: p.rejection
              } 
        
        let w = borrow_global_mut<Worker>(p.worker);
        Vector::push_pack<Receipt>(w.receipts, copy r)
        Vector::push_pack<Receipt>(b.receipts, r)


      // remove the element from vector if successful.
      let _ = Vector::remove<Payment>(&mut b.pending_payments, i);

    }

    fun is_police(_dao_addr: address, _addr: address): bool acquires Buffet {
      let b = borrow_global<Buffet>(_dao_addr);
      Vector::contains<address>(&b.police_list, &_addr)
    }

    fun maybe_init_worker(_sender: &signer) {
      if (!exists<Worker>(Signer::address_of(_sender))) {
        let new_details = init_details();
        move_to<Worker>(_sender, Worker {
          pending_value: 0,
          pending_bond: 0,
          cumulative_payment: 0,
          details: new_details,
          receipts: Vector::empty<Receipt>(),
        })
      }
    }

    fun init_details(): Vector<Detail> acquires Detail{
      //creates a details array for a worker
      let details = Vector::empty<Detail>();
      //initialized with some defaults Alias, github, twitter, discord
      Vector::push_back<Detail>(details,Detail {key: 'alias',value: Vector::empty<u64>()});
      Vector::push_back<Detail>(details,Detail {key: 'github',value: Vector::empty<u64>()});
      Vector::push_back<Detail>(details,Detail {key: 'twitter',value: Vector::empty<u64>()});
      Vector::push_back<Detail>(details,Detail {key: 'discord',value: Vector::empty<u64>()});

      details
    }



    // removes an element from the list of payments, and returns in to scope.
    // need to add it back to the list
    fun get_index_by_uid(_dao_addr: address, _uid: u64): (bool, u64) acquires Buffet {
      let b = borrow_global<Buffet>(_dao_addr);
      let len = Vector::length<Payment>(&b.pending_payments);

      let i = 0;
      while (i < len) {
        let p = Vector::borrow<Payment>(&b.pending_payments, i);

        if (p.uid == _uid) return (true, i);

        i = i + 1;
      };
      (false, 0)
    }
  }
}

    fun get_index_by_key(_worker: address, _key: Vector<u8>): (bool, u64) acquires Worker, Detail {
      let w = borrow_global<Worker>(_worker);
      let len = Vector::length<Detail>(&w.details);

      let i = 0;
      while (i < len) {
        let d = Vector::borrow<Detail>(&w.details, i);

        if (d.key == _key) return (true, i);

        i = i + 1;
      };
      (false, 0)
    }
  }
}



//TESTS
#[test_only]
module 0x1::SefServiceBuffetTests{
    use Std::UnitTest; //dependant on latest diem version 
    use Std::Vector;
    use Std::Signer;
    use Std::Diem;
    
    use 0x1::SelfService;

    const  FAKE_MESSAGE: vector<u8> = vector<u8>[142, 157, 142, 040, 151, 163, 040, 150, 145, 162, 145];


    #[test]
    public(script) fun test_init_dao(){
      let (alice, _) = create_two_signers();
      SelfService::init_dao(alice);
    }

    #[test]
    public(script) fun test_fund_dao(){
      let (alice, bob) = create_two_signers();
      SelfService::init_dao(alice);
      Std::Diem::mint<GAS>(bob,100001)
      fund_it(bob , Signer::address_of(&alice), 100000);
    }

    #[test]
    public(script) fun test_create_police(){
      let (alice, bob) = create_two_signers();
      SelfService::init_dao(alice);
      add_police(Signer::address_of(&alice), alice, Signer::address_of(&bob));
      assert(is_police(Signer::address_of(&alice), Signer::address_of(&bob)), 1);
    }


    #[test]
    public(script) fun test_remove_police(){
      let (alice, bob) = create_two_signers();
      SelfService::init_dao(alice);
      add_police(Signer::address_of(&alice), alice, Signer::address_of(&bob));
      assert(is_police(Signer::address_of(&alice), Signer::address_of(&bob)), 1);
      remove_police(Signer::address_of(&alice), alice, Signer::address_of(&bob) );
      assert(!is_police(Signer::address_of(&alice), Signer::address_of(&bob)), 1);
    }

    #[test]
    public(script) fun test_request_payment(){
      let (alice, bob) = create_two_signers();
      let (tom, carol) = create_two_signers();
      SelfService::init_dao(alice);
      Std::Diem::mint<GAS>(bob,100001)
      fund_it(bob , Signer::address_of(&alice), 100000);

      pay_me(tom, Signer::address_of(&alice), 50000, FAKE_MESSAGE, 10000);

    }


    #[test_only]
    fun create_two_signers(): (signer, signer) {
        let signers = &mut UnitTest::create_signers_for_testing(2);
        (Vector::pop_back(signers), Vector::pop_back(signers))
    }

}

