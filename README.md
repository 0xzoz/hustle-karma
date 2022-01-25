# Hustle Karma Application

**Items**
- App 
- Hustle Karma Smart Contract
- Community Wallet Smart Contract(Already Available 0x1:Wallet)





# **App**
Similar to `txs` cli application
>[txs App](https://github.com/OLSF/libra/tree/main/ol/txs)


# **Hustle Karma Smart Contract**
Interact with and hold state on chain
**Dependencies**
0x1:Wallet

**Methods**
Initial methods that could be implemented

- Register Warrior/Worker
- Update Warrior/Worker
- Request Payment


# Community Wallet Smart Contract
This wallet was initially built with the intention of having a Hustle Karma Smart Contract.

> Address - 0x1:Wallet
> [Contract](https://github.com/OLSF/libra/blob/main/language/diem-framework/modules/0L/Wallet.move)

struct CommunityWalletList
struct CommunityTransfers
struct TimedTransfer
struct Veto
struct CommunityFreeze

**Methods**

- set_comm
- vm_remove_comm
- new_timed_transfer
- veto
- reject
- mark_processed
- reset_rejection_counter
- calculate_proportional_voting_threshold
- list_tx_by_epoch
- list_transfers
- maybe_freeze


**Getters**
- get_tx_args
- get_tx_epoch
- transfer_is_proposed
- transfer_is_rejected
- get_comm_list
- is_comm
- is_frozen