import { ethers } from 'ethers'
const {
        StandMasterContract,
        provider
      } = require('./index') // hope that's right
const {
        validateCreation,
        standMasterAddress,
        userAbi
      } = require('./utils')

exports.createUser = (req, res) => {
    // need to extract private key from existing address users first
    // remember that the address is coming through as a string
    const wallet = req.body.address ?
      new ethers.Wallet(privateKey, provider) : // ideally this step would launch some kind of authentication
      ethers.Wallet.createRandom()

    const newUser = {
        name: req.body.name,
        root: wallet.address,
    }

    const { valid, errors } = validateCreation(newUser)

    if(!valid) return res.status(400).json(errors)

    // I think I'll just pretend there's money in the account for now
    //// TODO: add in stage to charge up account

    const nonce = provider.getTransactionCount(newUser.address)
      .then(txCount => txCount)
    const gasPrice = provider.getGasPrice()
      .then(_gasPrice => _gasPrice.toString())

    const createUserTx = {
      to: standMasterAddress,
      nonce,
      gasLimit: 0, // dunno how to calculate this or value yet
      gasPrice,
      value: 0,
      chainId: 5, //goerli
      data: 0 // dunno
    }

    let contractWithSigner = StandMasterContract.connect(wallet)
    let tx = await contractWithSigner.createUser(newUser.root, newUser.name)
    await tx.wait()
    StandMasterContract.on("UserCreated", (root, user, name, time) => {
      console.log(`${root} created a user at address ${user} named ${name}, time: ${time}`)
    })

}

// I'm going to assume that the user is logged in for now
// that means I assume some User object with the root (wallet) and user addresses
exports.createArtist = (req, res) => {
  const UserContract = new ethers.Contract(User.address, userAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = UserContract.connect(wallet)
  let tx = await contractWithSigner.createArtist(req.body.name)

  await tx.wait()

  StandMasterContract.on("ArtistCreated", (user, artist, time) => {
    console.log(`${user} created an artist page ${artist}, time: ${time}`)
  })
}

exports.createProject = (req, res) => {
  const UserContract = new ethers.Contract(User.address, userAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = UserContract.connect(wallet)
  let tx = await contractWithSigner.createProject(req.body.name)

  await tx.wait()

  StandMasterContract.on("ProjectCreated", (user, project, time) => {
    console.log(`${user} created an project page ${project}, time: ${time}`)
  })
}

exports.likeOrUnlike = (req, res) => {
  const UserContract = new ethers.Contract(User.address, userAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = UserContract.connect(wallet)
  let tx = await contractWithSigner.likeUnlike(req.body.toLike) // assuming it comes in as a hexadecimal, not a string or something

  await tx.await()

  // not sure how to do the event - recipient is either user, artist, or project
  // need to know which ABI to import in order to connect and listen
}

exports.followOrUnfollow = (req, res) => {
  const UserContract = new ethers.Contract(User.address, userAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = UserContract.connect(wallet)
  let tx = await contractWithSigner.followUnfollow(req.body.toFollow) // assuming it comes in as a hexadecimal, not a string or something

  await tx.await()

  // not sure how to do the event - recipient is either user, artist, or project
  // need to know which ABI to import in order to connect and listen
}

exports.fund = (req, res) => {
  if(req.body.addToAccount && parseint(req.body.addToAccount) > 0){
    const wallet = new ethers.Wallet(User.root.privkey, provider) // should actually be an authentication step

    let value = ethers.utils.parseEther(req.body.addToAccount)

    const nonce = provider.getTransactionCount(newUser.address)
    .then(txCount => txCount)
    const gasPrice = provider.getGasPrice()
    .then(_gasPrice => _gasPrice.toString())

    const fundUserContract = {
      to: User.address, // assuming it's in hex, not string
      nonce,
      gasLimit: 0, // dunno how to calculate this or value yet
      gasPrice,
      value, // here set above using ethers to parse the request
      chainId: 5, //goerli
      data: 0 // dunno
    }
  }

  const UserContract = new ethers.Contract(User.address, userAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = UserContract.connect(wallet)
  let tx = contractWithSigner.fund()

  UserContract.on("Funded", (giver, recipient, amountLocked, epochs, epochType, time) => {
    console.log(`${giver} has locked ${amountLocked} towards ${recipient} to be paid out ${epochType} ${epochs} times`)
  })
}

exports.deleteAccount = (req, res) => {
  const UserContract = new ethers.Contract(User.address, userAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = UserContract.connect(wallet)
  let tx = contractWithSigner.deleteAccount()

  UserContract.on("AccountDeleted", (root, user, time) => {
    console.log(`Account ${root} deleted user ${user}, time: ${time}`)
  })
}
