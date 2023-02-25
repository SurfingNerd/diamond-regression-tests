
# Diamond Regression Tests

regression tests for diamond networks.
tests the interaction of different repositories and interactions.

# Build Args

The containers is designed around specifying the set of contracts that should get tested in combination.

 - CONTRACTS_REPO: hbbft-posdao-contracts repository, dmdcoin for official or the name of a fork.
 - CONTRACTS_COMMIT_HASH: hbbft-posdao-contracts commit hash, must be available in CONTRACTS_REPO
 - NODE_REPO: diamond-node repository, dmdcoin for official or the name of a fork.
 - NODE_COMMIT_HASH: diamond-node commithash, must be available in NODE_REPO
 - TESTING_REPO: honey-badger-testing repository, dmdcoin for official or the name of a fork.
 - TESTING_COMMIT_HASH: honey-badger-testing commit hash, must be available in TESTING_REPO 

those can be passed like in this example:
`docker build --build-arg NODE_COMMIT_HASH=d83dbbe3a310a54046269aa95963f0c7adf7ddd9 .`

# Executing Tasks

Tasks can be executed on a running container.
