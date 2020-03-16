import { ethers } from 'ethers'
const { standMasterAddress,
        StandMasterContract,
        provider
      } = require('./index') // hope that's right
const { validateCreation } = require('./utils')

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
    StandMasterContract.on("UserCreated", (root, user, name) => {
      console.log(`${root} created a user at address ${user} named ${name}`)
    })

}
