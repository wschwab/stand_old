pragma solidity >=0.4.0 <0.7.0;

// attempt to unify artists and projects in one contract


// prolly should have some interface for setting up tiers so that
// there can be tiers on instantiation
// should probably do that for content too

contract ArtistAndProjectContract {
    struct Tier {
      uint public threshold;
      uint public epochs;
      string public name;
      string public description;
      mapping (address => bool) isMemberOfThisTier;
    }

    struct Content {
      string public tierName;
      string public contentHash; // encryption to keep it private?
    }

    struct Comment {
      address commentor;
      string comment;
    }

    struct ArtistOrProject {
      address public root;
      address public user;
      string public name;
      uint public deadline; //uint should be timestamp
      string public image; // should point to storage hash of a default image
      Tier[] public tiers;
      address[] public likes;
      address[] public follows;
      address[] public fundedBy;
      Content[] public content;
      mapping (uint => Comment) public comments; // uint should be timestamps? Idea is to allow easy chronological sort
      // problem - all comments mined in one block have the same timestamp
    }

    event Created(address createdBy, address _address, string name, uint time);
    event TierAdded(address artistOrProject, uint threshold, uint epochs, string name, uint time);
    event ContentAdded(address artistOrProject, string tierName, string contentHash, uint time);
    event CommentReceived(address artistOrProject, address commentor, Comment comment); // can events handle structs?
    event FundingReceived(address artistOrProject, address donor, uint amount, uint time);
    event CashedOut(address artistOrProject. address recipient, uint amount, uint time);

    modifier onlyOwner {
        require(msg.sender == ArtistOrProject.user || msg.sender == ArtistOrProject.root);
        _;
    }

    modifier onlyMember(address destination) {
      require(
        master.typeOf[destination] &&
        master.typeOf[destination] != Types.deleted
      );
      _;
    }

    constructor(address _root, string _name) {
        ArtistOrProject.root = _root;
        ArtistOrProject.user = msg.sender;
        ArtistOrProject.name = _name;

        emit Created(msg.sender, address(this), _name, now);
    }

    function addTier(
        uint _threshold,
        uint _epochs,
        string _name,
        string _description // could be should use a contentHash instead
    )
        public onlyOwner
    {
        ArtistOrProject.tiers.push(Tier({
            threshold: _threshold,
            epochs: _epochs,
            name: _name,
            description: _description
        }));

        emit TierAdded(address(this), _threshold, _epochs, _name, now);
    }

    function addContent(
        string _tierName,
        string _contentHash
    )
        public onlyOwner
    {
        assert(
            for(i = 0; i < tiers.length; i++){
                if tiers[i].name === _tierName return true
            }
            return false
        );
        ArtistOrProject.content.push(Content({
            tierName: _tierName,
            contentHash: _contentHash
        }));

        emit ContentAdded(address(this), _tierName, _contentHash, now);
    }

    function getComment(address commentor, Comment comment)
      public
      onlyMember(commentor) {
        ArtistOrProject.comments[now] == comment; // this isn't going to work, but just for now

        emit CommentReceived(address(this), commentor, Comment comment); // can events handle structs?
    }

    receive() external payable onlyMember(msg.sender) {
        for(i = 0; i < tiers.length; i++){
          if (msg.value >= tiers[i].threshold){
            tiers[i].isMemberOfThisTier[msg.sender] == true;
          }
        }

        emit FundingReceived(address(this), msg.sender, msg.value, now);
    }

    function cashOut(uint amount) public onlyOwner {
        ArtistOrProject.root.transfer(amount);

        emit CashedOut(address(this), ArtistOrProject.root, amount, now);
    }

    function getLikedUnliked(address liker) public onlyMember(liker) {
        require(liker == msg.sender);
        // if liker isn't already in likes
        if(isIn(liker, likes)) {
            ArtistOrProject.likedBy.pop(liker);
            emit Uniked(msg.sender, address(this), now);
        } else {
            ArtistOrProject.likedBy.push(liker);
            emit Liked(msg.sender, address(this), now)
        }
    }

    function getFollowedUnfollowed(address follower) public onlyMember(follower) {
        require(follower == msg.sender);
        if(isIn(follower, follows)){
            ArtistOrProject.followedBy.pop(follower);
            emit Unfollowed(msg.sender, address(this), now);
        } else {
            ArtistOrProject.followedBy.push(follower);
            emit Followed(msg.sender, address(this), now);
        }
    }
}
