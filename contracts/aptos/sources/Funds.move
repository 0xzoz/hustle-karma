//This module keeps track of the Funds that are created via Hustle Karma


module HustleKarma::Funds {
    use Std::Vector;
    use Std::ASCII;

struct Funds has key{
    list: Vector<Fund>
}

struct Fund has key, store {
    address: address,
    name: ASCII::String, 
    description: ASCII::String,

}


fun init_funds(hustle_karma: &signer){ 
    move_to<Funds>(hustle_karma,Funds{
        list; Vector::empty<address>()
}

fun add_fund(fund_address: address, description: ASCII::string, name: ASCII::string){
    borrow_global_mut<Funds>(&signer, fund: address, )
}


}
