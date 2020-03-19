const isEmpty = string => {
    if(string.trim() === '') return true
    else return false
}

exports.validateCreation = data => {
    let errors = {}

    if(isEmpty(data.name)) {
        errors.name = "Name required"
    }
    //need an address validator here

    return {
        errors,
        valid: Object.keys(errors).length === 0 ? true : false
    }
}

export default const standMasterAddress = "0x" // should obviously have real address
export default const standMasterAbi = [
  "event Created(address contractAddress, uint time)",
  "event UserCreated(address root, address user, string name, uint time)",
  "event UserRemoved(address user, uint time)",
  "event ArtistCreated(address user, address artist, uint time)",
  "event ArtistRemoved(address user, address artist, uint time)",
  "event ProjectRemoved(address user, address project, uint time)",
  "event ProjectRemoved(address user, address project, uint time)",
  "constructor()",
  "function createUser(string name)",
  "function removeUser(address user)",
  "function addOrRemoveArtist(address artist)"
]

export default const userAbi = [
  "event Liked(address liker, address liked, uint time)",
  "event Uniked(address unliker, address unliked, uint time)",
  "event Followed(address follower, address followed, uint time)",
  "event Unfollowed(address unfollower, address unfollowed, uint time)",
  "event Funded(address giver, address recipient, uint amountLocked, uint epochs, string, epochType, uint time)",
  "event ProfileEdited(address user, string whichContent, string contentHash, uint time)",
  "event CashedOut(address from, address to, uint amount, uint time)",
  "event AccountDeleted(address root, address user, uint time)",
  "constructor(address _root, string _name)",
  "function createArtist(string name)",
  "function createProject(string name)",
  "function likeUnlike(address toLike)",
  "function getLikedUnliked(address liker)",
  "function followUnfollow(address toFollow)",
  "function getFollowedUnfollowed(address follower)",
  "function comment(address destination, Comment comment)",
  "function fund(address payable artistOrProject)",
  "function editProfile(string whichContent, string newHash)",
  "function cashOut(uint amount)",
  "function deleteAccount()",
  "function isIn(address _addr, address[] _array) returns bool"
]

export default const artistOrProjectAbi = [
  "event Created(address createdBy, address _address, string name, uint time)",
  "event TierAdded(address artist, uint threshold, uint epochs, string name, uint time)",
  "event ContentAdded(address artist, string tierName, string contentHash, uint time)",
  "event FundingReceived(address artist, address donor, uint amount, uint time)",
  "event CashedOut(address artist. address recipient, uint amount, uint time)",
  "constructor(address _root, string _name)",
  "function addTier(uint _threshold, uint _epochs, string _name, string _description)",
  "function addContent(string _tierName, string _contentHash)",
  "function getComment(address commentor, Comment comment)",
  "receive()",
  "function cashOut(uint amount)"
]
