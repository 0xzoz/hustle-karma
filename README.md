# Hustle Karma Community Fund

## Overview

**Problem:** We need to incentivize community growth while minimizing the friction

**Solution:** Use an initial inplementation of the [game](https://github.com/0o-de-lally/libra/blob/self-service/language/diem-framework/modules/0L/SelfServiceBuffet.move) presented by 0o-de-lally(0D | 0o-de-lally#9527 on [0L Discord](https://discord.gg/BpfUeGEB)). At high level, the this provides a way to easily fund a pool and allow for users to pay themselves for their efforts. In this case, growing the 0L community and incentivizing the users that do. 

> NOTE: This is an experiment to see how this process works in a live environment. If successful, a larger more robust implementation could be the solution to how Hustle Karma operates.

## About 

![](https://i.imgur.com/93mN7ex.png)
[Implementation](https://github.com/0xzoz/libra/blob/hustle-karma/language/diem-framework/modules/0L/SelfServiceBuffet.move)


---
### Administration Steps

1. Create Buffet for HKCF from self service
2. The Buffet is instantiated with intial parameters
3. The first Police is the creator of the buffet
 
---
### User Steps

4. A user requests a payment with the pay_me function and a new worker is created or the values are added if the user is already a worker
5. 
6. Buffet then creates a payment and it stored in the payment object until the specified epoch due.
7. 
8. One or many police can then either reject the payment or expedite it if they choose to.

---
### Other Steps

9. a) Any user can fund the buffet
   b) Any police can create another police
   c) Any police can opt to release all of the payments
   d) Any police can remove another police
   
 ---
   
## Background

> Excerpt by 00-de-lally in code comments

**TL;DR** the guarantee that Self Service Buffet offers is: workers pay
themselves, and rampant abuse is minimized. But not all abuse. We assume
honesty. By default Workers will be paid some days after a request is made,
without intervention. Some attacks are possible, and that's explicitly ok,
because 100% coverage is impossible. Plus, importantly, this cannot be worse
than the amount of free-riding that happens with proof-of-work mining
rewards, which is the vast majority of participants. So the minimal controls
the contract has is to make it unprofitable to try to amplify attacks, by
using time delays and bonds bonding for each new pending payment in the
system.

Games need to have an equilibrium. In any community the honest actors always
pay for the actions of bad actors. There's both monetary cost and demotivation,
which together can push the game out of balance. Fraud in games is not always
obvious to identify, but equally important, it's not necessarily something
that should be eliminated entirely. There's an adage in payment processing:
"the only way to remove fraudulent transactions is to also remove the
revenue".

Self Service Buffet is a payment processing game for DAOs which optimizes for
revenue, not for fraud prevention.

DAO payments have mirrored the practices of companies: deliver work, send
a report, then an invoice, getting invoice approved, and later finding the
funds, and authorizing transactions. This has a feeling of safety. It is
process oriented, and appears more orderly. But it leaves money on the table
for both the workers and for the protocols.

The greatest cost in such a system is opportunity cost. How much work is the
DAO failing to get done, because it is optimizing for minimal fraud?
Free-mining proof-of-work bring a lot of free-riders to your platform. Would
self-service payments really be worse than free-mining?

Obviously fraud can't be ignored.  But if we can limit the damage of the
fraud, in material terms, and in psychological demotivation, while creating
an automated process, we might have a net increase in economic value.

The premise of Self Service Buffet is that fraud prevention for work is gated
by the amount of people monitoring the game. The team which was working to
process the entire flow of payments before, can instead be a small committee,
that monitors for fraud (and this committee can obviously be expanded or
reduced algorithmically, but that's not a concern here)

 ### Product Requirements:

Least viable process. Every human in the loop slows down the payments. We
need to make it rain on DAO contributors.

Optimize for Net Payments. A few attacks is fine, if there is a net gain in
productivity. But repeated attacks on scale should not be profitable.

Distraction of the fraud monitoring team can be attacked, the policies should
prevent monitors from getting overwhelmed.

Expensive griefing: if just for fun someone spams requests so to prevent good
actors from getting paid, the cost should increase until it is prohibitive.

Don't rely on reputation. Reputation is high maintenance, and everyone
monitoring reputation increases friction.


### Mechanism:

Each payment request has a Credit Limit, a maximum amount which can be
disbursed. Note: credit limits are not per account, there is no reputation.

Anyone can request multiple payments to circumvent Credit Limit. Thus
requesting payments has a cost. The cost is time and a bond. 

The costs increase as a function of two variables: 1) count of pending
payments and 2) the value of pending payments.

As long as there are few payments in the network of
low value, the Police have easy work and there's no reason to add friction to
payments. When there are many requests, the Police willn need more time to sift
through the payments, this delay can be done algorithmically.

And after a certain amount of pending payments (by value) reaches a threshold,
a bond must also be placed to prevent spam. 

The floor can be very low, for low friction. Until there are 10 pending
payments, the Delay is 3 epochs (days), and the Bond is 0.

Rejected payments forfeit the bond. The bond is forfeited and goes into the
funding pool. Thus griefing attacks (submitting spam requests to slow down
payments for honest actors) will require increasing amounts of bonds.


**The expected effect is:** In the ordinary course of events, with few payments
below a value threshold, people get paid without fuss. When many request for
payment come through (legitimally or in an attempt to attack the system),
everyone needs to wait a bit longer, and risk paying to get money. For
attackers it should quickly become less fun, and or profitable. And the
prospect of it being a waste of time, might prevent it in the first place

---

# Implementation

## Initial Funding

The Passive Trust would like to intially fund this project as an act of good will and to drive further development within the 0L ecosystem. They will provide labor to complete the implementation, allocate 100000 GAS to bootstrap the program and provide a detailed report with the findings.

Having been involved in the intial implementation of Hustle Karma that this experiment intends to replace and optimize for efficiency. They are in a good position with knowledge of the downfalls and administration required to operate a DAO.

## Process

The process will operate in a couple of phases. Outlined these are:

1. Add missing pieces to the contract
2. Add additional features
3. Get feedback
4. Deploy contract
5. Provide a UI
6. Follow the experiment, provide support and a review of the findings


### Add Missing pieces to the contract

The contract was a scaffold to begin with and some items were left to be implemented.These are:

#### ~~Implement pay_me logic~~

#### ~~Implement release_all logic~~

#### ~~push values in fund_it function~~

#### ~~Implement a bond value curve design~~

To request a payment, a user has to provide a bond. Implement a bonding curve that minimizes the fraud that can be done. this is done in the get_bond_value function.

#### ~~Implement a epoch delay curve~~

Similar to above, there needs to be an epoch time delay curve to minimize fraud. This will have to factor in the above curve and is done in the get_epochs_delay function.

#### ~~Make payment~~

Within the maybe_make_payment function make the payment

#### Add tests

Add tests to cover module

### Add Additional Features

#### Incorporate BlockScience Reporting Standards


### Get Feedback

While adding the above pieces, some of the items could drastically affect the efficiency and the intention of the way the contract works. Specifically, the two curve designs and how they co-operate with each other. It is important to get multiple perspectives on what others think is right and wrong. After enough discussion this will be finalized and added.

### Deploy Contract

The contract will then need to be deployed to the network and funded. As mentioned above, The Passive Trust is commited to funding this with 100,000 GAS intially. The validator funds are currently locked so there will have to be some type of governance proposal to do this(TBD).

### Provide a UI

This is where the bulk of the work must be done. 0L currently does not have any web applications or wallets operating on the network and will require consultation from multiple parties on how this can be achieved.

  
## Questions

- How to implement errors within assert. eg how to determine u64 - 
[example](https://github.com/OLSF/libra/blob/820ec66f3457fb26a4e24c952407d37f05ce6b1c/language/diem-framework/modules/0L/Wallet.move#L18)


## Contract Ideas/Additions

- Add previous payments to a list -could be warrior or the DAO itself, maybe both
- Add point system(karma)
- Should tasks be stored directly on the contract or be independant, maybe a lego
- Incorporate reporting standards proposed by BlockScience - https://hackmd.io/MKskCuXbQT2t9s8lou_GKQ?view



## Contributing
### Application

(Production)[https://hustlekarma.xyz/]
(Development)[https://dev.hustlekarma.xyz/]

### How to contribute
All contributions are welcome. Development happens on two branchs:

* contract-work: This is for all smart contract work on the associated blockchain
> While initially a Move based application, the goal is to have this implementation deployed on multiple chains in multiple languages.

* frontend-work: All UI work can be added as PR to this branch.

### Smart Contract Work

* fork the repo and create a new branch. Make the name is specific to the work being completed.

* Commits should be bundled containing similar changes and should be signed 

* Changes should be submitted in a PR outlining the changes made

#### 0L

#### Deploy

##### Testing 

##### Upgrading

#### Aptos

#### Deploy

##### Testing 

##### Upgrading


### Frontend Work

* fork the repo and create a new branch. Make the name is specific to the work being completed.

* Commits should be bundled containing similar changes and should be signed 

* Changes should be submitted in a PR outlining the changes made




## Work Completed

> This will be added to a changelog with v 1.0.0

- Implement pay_me logic - [commit](https://github.com/0xzoz/libra/commit/81985b34df6d70ff589236ac9fda5f6fe34126b7)
- Implement release_all logic - [commit](https://github.com/0xzoz/libra/commit/2bcbeeb91fc0d72c3363c18a1e6ec3a4a2f35acf)
- Push values in fund_it function - [commit](https://github.com/0xzoz/libra/commit/ed61f3ea0c9ba80e931c5cc6a4cc3db7565b79e4)
- implement payments in make_payment function - [commit](https://github.com/0xzoz/libra/commit/ba148049798037085400a9e61cf9cac17ed87f88)



