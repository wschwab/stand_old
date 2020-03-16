pragma solidity >=0.4.0 <0.7.0;

// prolly should have some interface for setting up tiers so that
// there can be tiers on instantiation
// should probably do that for content too

contract ArtistContract {
    struct Tier {
        uint public threshold;
        uint public epochs;
        string public name;
        string public description;
        mapping (address => bool) isMemberOfThisTier;
    }

    struct Content {
        string public tierName;
        string public contentHash;
    }

    struct Artist {
        address public root;
        address public user;
        string public name;
        string public image; // should point to storage hash of a default image
        Tier[] public tiers;
        Content[] public content;
        mapping (uint => string) comments; // uint should be timestamps
    }

    modifier onlyOwner {
        require(msg.sender == Artist.user || msg.sender == Artist.root);
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
        Artist.root = _root;
        Artist.user = msg.sender;
        Artist.name = _name;
    }

    function addTier(
        uint _threshold,
        uint _epochs,
        string _name,
        string _description
    )
        public onlyOwner
    {
        Artist.tiers.push(Tier({
            threshold: _threshold,
            epochs: _epochs,
            name: _name,
            description: _description
        }));
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
        Artist.content.push(Content({
            tierName: _tierName,
            contentHash: _contentHash
        }));
    }

    receive() external payable onlyMember(msg.sender) {
        for(i = 0; i < tiers.length; i++){
          if (msg.value >= tiers[i].threshold){
            tiers[i].isMemberOfThisTier[msg.sender] == true;
          }
        }
    }

    function cashOut(uint amount) public onlyOwner {
        Artist.root.transfer(amount);
    }
}
