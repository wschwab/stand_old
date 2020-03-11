pragma solidity >=0.4.0 <0.7.0;

import "./artistContract";
import "./projectContract";

contract StandMasterContract {
    address[] public users;
    address[] public artists;
    address[] public projects;

    enum Types {
        user,
        artist,
        project,
        deleted
    };

    mapping (address => Types) typeOf;

    constructor() {}

    function createUser(
        string public name
    ) public {
        address userContract = new UserContract(msg.sender, name);
        users.push(userContract);
        typeOf[userContract] = Types.user;
    }

    function removeUser(address user) public {
        require(msg.sender == user);
        users.pop(user);
        typeOf[user] == Types.deleted;
    }

    function addOrRemoveArtist(address artist) public {
        // address check would be nice - see if sender is in users?
        // if address isn't in artists
        artists.push(artist);
        typeOf[artist] = Types.user;
        // else
        artists.pop(artist);
        typeOf[artist] = Types.deleted;
    }

    function addOrRemoveProject(address project) public {
        // check if sender is a user
        // if address isn't in projects
        projects.push(project);
        typeOf[project] = Types.project;
        // else
        projects.pop(project);
        typeOf[project] = Types.deleted;
    }
}

// currently cashing out just dumps it in the root user account
// this needs other options, especially if there is going to be a fiat offramps

contract UserContract {
    address masterAddr;
    StandMasterContract master;

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

    modifier onlyOwner {
        require(msg.sender == User.root);
        _;
    }

    constructor(address _root, string _name) public {
        masterAddr = msg.sender;
        master = StandMasterContract(masterAddr);

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
        master.addArtist(address(artistContract));
    }

    function createProject(
        string name
    ) public onlyOwner {
        address projectContract = new ProjectContract(User.root, name);
        User.projects.push(projectContract);
        master.addProject(address(projectContract));
    }

    function likeUnlike(address toLike) public onlyOwner {
        // would checking the address be nice?
        // not sure I can work with the Type enum like this
        if(master.typeOf[toLike] == Types.user) {
            UserContract user = UserContract(toLike);
            user.getLikedUnliked(address(this));
        } else if(master.typeOf[toLike] == Types.artist) {
            ArtistContract artist = ArtistContract(toLike)
            artist.getLikedUnliked(address(this));
        } else if(master.typeOf[toLike] == Types.project) {
            ProjectContract project = ProjectContract(address(this));
            project.getLikedUnliked(address(this));
        }
    }

    function getLikedUnliked(address liker) public onlyOwner {
        // if liker isn't already in likes
        if(isIn(liker, likes)) {
            User.likes.pop(liker);
        } else {
            User.likes.push(liker);
        }
    }

    function followUnfollow(address toFollow) public onlyOwner {
        // call to getFollowedUnfollowed at address with msg.sender as an arg
        if(master.typeOf[toLike] == Types.user) {
            UserContract user = UserContract(toLike);
            user.getFollowedUnfollowed(address(this));
        } else if(master.typeOf[toLike] == Types.artist) {
            ArtistContract artist = ArtistContract(toLike)
            artist.getFollowedUnfollowed(address(this));
        } else if(master.typeOf[toLike] == Types.project) {
            ProjectContract project = ProjectContract(address(this));
            project.getFollowedUnfollowed(address(this));
        }
    }

    function getFollowedUnfollowed(address follower) public onlyOwner {
        if(isIn(follower, follows)){
            User.follows.pop(follower);
        } else {
            User.follows.push(follower);
        }
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

    function isIn(address _addr, address[] _array) internal returns(bool){
        for(i=0;i<_array.length;i++){
            if _array[i] == _addr return true
        }
        return false;
    }
}
