// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract PotCommun {
	mapping(address => uint) public nbdepo;
	mapping(address => bool) public whitelist;
    uint public balance;
	address public owner;
	uint public timecreate;
	uint public week;

	constructor() {
		owner = msg.sender;
		whitelist[msg.sender] = true;
		timecreate = block.timestamp;
		week = 12;
	}

	modifier onlyOwner() {
		require(owner == msg.sender, "Il faut etre le proprietaire");
		_;
	}

	modifier onlyWhitelist() {
		require(whitelist[msg.sender] == true || owner == msg.sender, "Il faut etre whiteliste ou proprietaire");
		_;
	}

	modifier onlyDate() {
	require(block.timestamp - timecreate > week * 1 weeks || balance >= 20 ether, "Il sera accessible dans un certains temps apres la creation du contrat");
	_;
	}

	function changedate(uint nbweek) public onlyOwner {
		week = nbweek;
	}

	function whitelistUser(address adtowhite) public onlyOwner {
		whitelist[adtowhite] = true;
	}

	function unwhitelistUser(address adtounwhite) public onlyOwner {
		whitelist[adtounwhite] = false;
	}

	function depo() payable public {
		if (nbdepo[msg.sender] == 0)
			whitelist[msg.sender] = true;
		balance += msg.value;
		nbdepo[msg.sender]++;
	}

	function changeOwner(address newOwner) public onlyOwner {
		owner = newOwner;
	}

	function getMsgSender() public view returns (address, bool, uint) {
		return (msg.sender, whitelist[msg.sender], nbdepo[msg.sender]);
	}

	function withdraw(uint amont) public onlyWhitelist onlyDate {
		uint valeurwei = amont * 1 ether;
		require(valeurwei < balance, "solde pas bon");
		payable(msg.sender).transfer(valeurwei);
		balance -= valeurwei;
	}

  /*function init() private {
	whitelist[msg.sender] = true;
  }*/
}
