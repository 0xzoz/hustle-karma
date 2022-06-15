/////////////////////////////////////////////////////////////////////////
// 0L Module
// Self Service Buffet
// Error code: 
/////////////////////////////////////////////////////////////////////////

// TL;DR the guarantee that Self Service Buffet offers is: workers pay
// themselves, and rampant abuse is minimized. But not all abuse. We assume
// honesty. By default Workers will be paid some days after a request is made,
// without intervention. Some attacks are possible, and that's explicitly ok,
// because 100% coverage is impossible. Plus, importantly, this cannot be worse
// than the amount of free-riding that happens with proof-of-work mining
// rewards, which is the vast majority of participants. So the minimal controls
// the contract has is to make it unprofitable to try to amplify attacks, by
// using time delays and bonds bonding for each new pending payment in the
// system.

// Games need to have an equilibrium. In any community the honest actors always
// pay for the actions of bad actors. There's both monetary cost and demotivation,
// which together can push the game out of balance. Fraud in games is not always
// obvious to identify, but equally important, it's not necessarily something
// that should be eliminated entirely. There's an adage in payment processing:
// "the only way to remove fraudulent transactions is to also remove the
// revenue".

// Self Service Buffet is a payment processing game for DAOs which optimizes for
// revenue, not for fraud prevention.

// DAO payments have mirrored the practices of companies: deliver work, send
// a report, then an invoice, getting invoice approved, and later finding the
// funds, and authorizing transactions. This has a feeling of safety. It is
// process oriented, and appears more orderly. But it leaves money on the table
// for both the workers and for the protocols.

// The greatest cost in such a system is opportunity cost. How much work is the
// DAO failing to get done, because it is optimizing for minimal fraud?
// Free-mining proof-of-work bring a lot of free-riders to your platform. Would
// self-service payments really be worse than free-mining?

// Obviously fraud can't be ignored.  But if we can limit the damage of the
// fraud, in material terms, and in psychological demotivation, while creating
// an automated process, we might have a net increase in economic value.

// The premise of Self Service Buffet is that fraud prevention for work is gated
// by the amount of people monitoring the game. The team which was working to
// process the entire flow of payments before, can instead be a small committee,
// that monitors for fraud (and this committee can obviously be expanded or
// reduced algorithmically, but that's not a concern here)

// PRODUCT REQUIREMENTS:

// Least viable process. Every human in the loop slows down the payments. We
// need to make it rain on DAO contributors.

// Optimize for Net Payments. A few attacks is fine, if there is a net gain in
// productivity. But repeated attacks on scale should not be profitable.

// Distraction of the fraud monitoring team can be attacked, the policies should
// prevent monitors from getting overwhelmed.

// Expensive griefing: if just for fun someone spams requests so to prevent good
// actors from getting paid, the cost should increase until it is prohibitive.

// Don't rely on reputation. Reputation is high maintenance, and everyone
// monitoring reputation increases friction.


// MECHANISM:

// Each payment request has a Credit Limit, a maximum amount which can be
// disbursed. Note: credit limits are not per account, there is no reputation.

// Anyone can request multiple payments to circumvent Credit Limit. Thus
// requesting payments has a cost. The cost is time and a bond. 

// The costs increase as a function of two variables: 1) count of pending
// payments and 2) the value of pending payments.

// As long as there are few payments in the network of
// low value, the Police have easy work and there's no reason to add friction to
// payments. When there are many requests, the Police willn need more time to sift
// through the payments, this delay can be done algorithmically.

// And after a certain amount of pending payments (by value) reaches a threshold,
// a bond must also be placed to prevent spam. 

// The floor can be very low, for low friction. Until there are 10 pending
// payments, the Delay is 3 epochs (days), and the Bond is 0.

// Rejected payments forfeit the bond. The bond is forfeited and goes into the
// funding pool. Thus griefing attacks (submitting spam requests to slow down
// payments for honest actors) will require increasing amounts of bonds.


// The expected effect is: In the ordinary course of events, with few payments
// below a value threshold, people get paid without fuss. When many request for
// payment come through (legitimally or in an attempt to attack the system),
// everyone needs to wait a bit longer, and risk paying to get money. For
// attackers it should quickly become less fun, and or profitable. And the
// prospect of it being a waste of time, might prevent it in the first place


//TODO: List
// worker should have a way to determine each DAO's payments and bonding curves should factor this
// NOT TAGGED: Add previous payments to a list -could be warrior or the DAO itself, maybe both
// NOT TAGGED: Add point system to warrior
// NOT TAGGED: Incorporate reporting standards proposed by BlockScience - https://hackmd.io/MKskCuXbQT2t9s8lou_GKQ?view
// NOT TAGGED: Add pay function to police - 1 police = 1% of funds pa - only allowed to be withdrawn daily(make it a task to withdraw and to keep active)
//                                        - 2 police = 3% of funds pa 
//                                        - 3 police = 10% of funds pa
//                                        - any more decreases the police funds - to create a tight nit group            
// NOT TAGGED: Prevent rougue police - needs ideation
// NOT TAGGED: Social recovery - needs ideation




  module HustleKarma::Fund {
    use Std::Vector;
    use Std::Signer;
    use Std::Block;
    use Std::Coin;
    use Std::ASCII;
    const BOND_VALUE_IS_NOT_CORRECT: u64 = 1;
    const PAYMENT_NOT_IN_PAYMENTS_TABLE = 2;


    // gets initialized to a worker account when they submit a request for payment.
    struct Worker has key {
      pending_value: u64,
      pending_bond: u64,
      cumulative_payment: u64,
      details: vector<Detail>,
      payments: vector<Payment>
    }

    // allow a Worker to tag themselves
    struct Detail {
      key: ASCII::String,
      value: ASCII::String,
    }

    // gets initialized to the DAO address on init_dao()
    struct Buffet has key {
      balance: Std::Coin<HustleKarma::Coin::Karma>,
      bond: Std::Coin<HustleKarma::Coin::Karma>, // Bond is here because it cannot be dropped
      funder_addr: vector<address>,
      funder_value: vector<u64>,
      police_list: vector<address>,
      pending_payments: vector<Payment>,
      max_uid: u64,
    }

    struct Payment has key, store, drop {
      uid: u64,
      worker: address,
      value: u64,
      epoch_requested: u64,
      epoch_due: u64,
      deliverable: ASCII::String,
      bond: u64, // NOTE: can't have the bond as the actual coin here, because this struct needs the 'drop' ability.
      rejection: vector<address>
    }

    ///////// WORKER FUNCTIONS ////////

    public fun pay_me(_sender: &signer, _from_dao: address, _amount: u64, _deliverable: ASCII::String, _bond: u64) {

      maybe_init_worker(_sender);
      // if it exists get the buffet object
      if(!exists<Buffet>(_from_dao)){
        let b = borrow_global_mut<Buffet>(_from_dao);
        // calculate the date it will receive.
        // get current epoch
        let current_epoch = Block::get_current_block_height();
        let t = get_epochs_delay(_from_dao,_amount, _sender);
        // check if the bond is adequate.
        assert(get_bond_value(_from_dao,_amount, _sender) > _bond, BOND_VALUE_IS_NOT_CORRECT);

        // push the payment onto the list
        Vector::push_back<address>(&mut b.pending_payments,Payment  {
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
        Std::Coin::deposit<HustleKarma::Coin::Karma>(&mut b.bond, _bond);
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
        let current_epoch = Block::get_current_block_height();

        let i = 0;
        while (i < len) {
          let p = Vector::borrow<Payment>(&b.pending_payments, i);
          if( p.epoch_due <= current_epoch){
            maybe_make_payment(_from_dao, i );
          }
        }
      }

    }

    ////////// SPONSOR FUNCTIONS //////////

    // anyone can fund the pool. It doesn't give you any rights or governance.
    public fun fund_it(_sender: &signer, _dao: address, _new_deposit: Diem::Diem<GAS>) acquires Buffet {
      let b = borrow_global_mut<Buffet>(_dao);
      Std::Coin::deposit<HustleKarma::Coin::Karma>(&mut b.balance, _new_deposit);
      Vector::push_back(&mut b.funder_addr, Signer::address_of(_sender));
      Vector::push_back(&mut b.funder_value, _new_deposit);
    }

    ////////// MANAGMENT FUNCTIONS //////////

    // a DAO can initialize their address with this state.
    // all transactions in the future need to reference the DAO address
    // this also creates the first Police address, which can subsequently onboard other people.
    public fun init_dao(_sender: &signer) {
      let new_buffet = Buffet {
        balance: Std::Coin::zero<HustleKarma::Coin::Karma>(),
        bond: Std::Coin::zero<HustleKarma::Coin::Karma>(),
        funder_addr: Vector::empty<address>(),
        funder_value: Vector::empty<u64>(),
        police_list: Vector::empty<address>(),
        pending_payments: Vector::empty<Payment>(),
        max_uid: 0,
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
      if (p.epoch_due >= Block::get_current_block_height()) {
        Std::Coin::withdraw<HustleKarma::Coin::Karma>(_dao_addr, p.worker, b.balance, p.value);
        Std::Coin::withdraw<HustleKarma::Coin::Karma>(_dao_addr, p.worker, b.bond, p.bond);
      };

      // remove the element from vector if successful.
      let _ = Vector::remove<Payment>(&mut b.pending_payments, i);

    }

    fun is_police(_dao_addr: address, _addr: address): bool acquires Buffet {
      let b = borrow_global<Buffet>(_dao_addr);
      Vector::contains<address>(&b.police_list, &_addr)
    }

    fun maybe_init_worker(_sender: &signer) {
      if (!exists<Worker>(Signer::address_of(_sender))) {
        move_to<Worker>(_sender, Worker {
          pending_value: 0,
          pending_bond: 0,
          cumulative_payment: 0,
        })
      }
    }

    fun init_details(_sender: &signer) {
      let details = Vector::empty<Detail>()
      let accounts = Vector::empty<u64>
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



//TESTS
#[test_only]
module HustleKarma::Tests{
    use Std::UnitTest; //dependant on latest diem version 
    use Std::Vector;
    use Std::Signer;
    
    use HustleKarma::Fund;

    const  FAKE_MESSAGE: vector<u8> = "Message";


    #[test]
    public(script) fun test_init_dao(){
      let (alice, _) = create_two_signers();
      Fund::init_dao(alice);
    }

    #[test]
    public(script) fun test_fund_dao(){
      let (alice, bob) = create_two_signers();
      Fund::init_dao(alice);
      Std::Coin::mint<HustleKarma::Coin::Karma>(10);
      Std::Coin::deposit<HustleKarma::Coin::Karma>(Signer::address_of(&bob), 10);
      Fund::fund_it(bob , Signer::address_of(&alice), 10);
    }

    #[test]
    public(script) fun test_create_police(){
      let (alice, bob) = create_two_signers();
      Fund::init_dao(alice);
      Fund::add_police(Signer::address_of(&alice), alice, Signer::address_of(&bob));
      assert(is_police(Signer::address_of(&alice), Signer::address_of(&bob)), 1);
    }


    #[test]
    public(script) fun test_remove_police(){
      let (alice, bob) = create_two_signers();
      Fund::init_dao(alice);
      Fund::add_police(Signer::address_of(&alice), alice, Signer::address_of(&bob));
      assert(is_police(Signer::address_of(&alice), Signer::address_of(&bob)), 1);
      Fund::remove_police(Signer::address_of(&alice), alice, Signer::address_of(&bob) );
      assert(!is_police(Signer::address_of(&alice), Signer::address_of(&bob)), 1);
    }

    #[test]
    public(script) fun test_request_payment(){
      let (alice, bob) = create_two_signers();
      let (tom, carol) = create_two_signers();
      Fund::init_dao(alice);
      Std::Coin::mint<HustleKarma::Coin::Karma>(10);
      Std::Coin::deposit<HustleKarma::Coin::Karma>(Signer::address_of(&bob), 10);
      Fund::fund_it(bob , Signer::address_of(&alice), 100000);

      pay_me(tom, Signer::address_of(&alice), 50000, FAKE_MESSAGE, 10000);

    }


    #[test_only]
    fun create_two_signers(): (signer, signer) {
        let signers = &mut UnitTest::create_signers_for_testing(2);
        (Vector::pop_back(signers), Vector::pop_back(signers))
    }

}

