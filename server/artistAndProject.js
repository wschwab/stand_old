const ethers = require('ethers')

const {
  StandMasterContract,
  provider
} = require('./index')
const {
  validateCreation,
  standMasterAddress,
  artistAbi,
  projectAbi
} = require('./utils')

exports.addTier = (req, res) => {
  // think maybe a content hash is better than a string, using string for now, assuming it comes over as req.body.description

  const ArtistOrProjectContract = new ethers.Contract(ArtOrProj.address, artOrProjAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = ArtistOrProjectContract.connect(wallet)
  let tx = contractWithSigner.addTier(
      parseint(req.body.threshold),
      parseint(req.body.epochs)),
    req.body.name,
    req.body.description
)

await tx.await()

ArtistOrProjectContract.on("TierAdded", (artOrProj, threshold, epochs, name, description, time) => {
  console.log(`${artOrProj} added a tier ${name} with a threshold of ${threshold} and ${epochs} epochs, time: ${time}`)
})
}

exports.addContent = (req, res) => {
  assert(req.body.content) // need to check that it's not an empty string
  let content = req.body.content
  // use erebos to upload this to swarm and get a hash
  // this is technically unencrypted content that anyone could view - need to somehow encrypt with key only going to subscribers at that level
  // added issue is that I suspect the content would always be visible even after they pay subscription - need to think about that

  const ArtistOrProjectContract = new ethers.Contract(ArtOrProj.address, artOrProjAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let contractWithSigner = ArtistOrProjectContract.connect(wallet)
  let tx = contractWithSigner.addContent(req.body.tierName, contentHash)

  await tx.await()

  ArtistOrProjectContract.on("ContentAdded", (artOrProj, tierName, contentHash, time) => {
    console.log(`${artOrProj} added content to tier ${tierName} at ${contentHash}`)
  })
}

exports.atrprojCashOut = (req, res) => {

}

exports.getArtprojProfile = (req, res) => {
  const ArtistOrProjectContract = new ethers.Contract(ArtOrProj.address, userAbi, provider) // this will probably have already been done elsewhere, and should be removed then
  let profile = await ArtistOrProjectContract.ArtistOrProject

  console.log(
    `Artist or Project profile:
      root: ${profile.root}
      user: ${profile.user}
      name: ${profile.name}
      image: ${profile.image}
      deadline: ${profile.deadline || "none"}
      tiers: ${profile.tiers}
      likedBy: ${profile.likes}
      followedBy: ${profile.follows}
      fundedBy: ${profile.fundedBy}
      content: ${profile.content}
      comments: ${profile.comments}
      `
  )

  return profile
}
