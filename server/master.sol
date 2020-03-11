pragma solidity >=0.4.0 <0.7.0;

contract StandMasterContract {
    address[] public users;
    address[] public artists;
    address[] public projects;

    constructor() {}

    function createUser(
        string public name
    ) public {
        address userContract = new UserContract(msg.sender, name);
        users.push(userContract);
    }

    function addOrRemoveArtist(address artist) public {
        // address check would be nice - see if sender is in users?
        // if address isn't in artists
        artists.push(artist);
        // else
        artists.pop(artist);
    }

    function addOrRemoveProject(address project) public {
        // check if sender is a user
        // if address isn't in projects
        projects.push(project);
        // else
        projects.pop(project);
    }
}

contract UserContract {
    address master;

    struct User {
        address public root;
        string public name;
        string public image; // should point to storage hash of a default image
        string public bio; // I think this should also just be a link
        address public artAddress;
        address[] public likes;
        address[] public follows;
        address[] public isFunding;
        address[] public projects;
    }

    struct Tier {
        uint public threshold;
        uint public epochs;
        string public name;
        string public description;
    }

    struct Content {
        string public tierName;
        string public contentHash;
    }

    struct Artist {
        string public name;
        string public image; // should point to storage hash of a default image
        Tier[] public tiers;
        Content[] public content;
        mapping (uint => string) comments; // uint should be timestamps
    }

    struct Project {
        string public name;
        string public image; // should point to storage hash of a default image
        Tier[] public tiers
        Content[] public content;
        mapping (uint => string) comments; // uint should be timestamps
    }

    modifier onlyOwner {
        require(msg.sender == User.root);
        _;
    }

    constructor(address _root, string _name) public {
        master = msg.sender;

        User.root = _root;
        User.name = _name;
    }

    function createArtist(
        string name
    ) public onlyOwner {
        require(User.artAddress == address(0), "You already have an artist page");

        User.artist = true;
        address artistContract = new ArtistContract(User.root, name);
        User.artAddress = artistContract;
        StandMasterContract m = StandMasterContract(master);
        m.addArtist(address(this));
    }

    function createProject(
        string name
    ) public onlyOwner {
        address projectContract = new ProjectContract(User.root, name);
        User.projects.push(projectContract);
        StandMasterContract m = StandMasterContract(master);
        m.addProject(address(this));
    }

    function likeUnlike(address artistOrProject) public onlyOwner {
        // would checking the address would be nice?
        // call to getLikedUnliked at address with msg.sender as an arg
        // how do I tell if it's an artist, user, or project?
    }

    function getLikedUnliked(address liker) public onlyOwner {
        // if liker isn't already in likes
        User.likes.push(liker);
        // else
        User.likes.pop(liker);
    }

    function follow(address artistOrProject) public onlyOwner {
        // call to getFollowedUnfollowed at address with msg.sender as an arg
    }

    function getFollowedUnfollowed(address follower) public onlyOwner {
        // if follower isn't already in follows
        User.follows.push(follower);
        // else
        User.follows.pop(follower);
    }

    function fund(address artistOrProject) public onlyOwner {
        // research subscriptions (EIP 1337?)
    }

    function editProfile(string whichContent, string newHash) public onlyOwner {
        if(whichContent == 'image') User.image = newHash;
        if(whichContent == 'bio') User.bio == newHash;
    }

    function cashOut(uint amount) public onlyOwner {
        User.root.transfer(amount);
    }
}
