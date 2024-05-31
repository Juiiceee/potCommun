// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract PotCommun {
	mapping(address => uint) public balance;
	mapping(address => uint) public nbdepo;
	mapping(address => bool) public whitelist;
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
	require(block.timestamp - timecreate > week * 1 weeks, "Il sera accessible dans un certains temps apres la creation du contrat");
	_;
	}

	function uinttostring(uint nb) internal pure returns(string memory) {
		if (nb == 0)
			return ("0");
		uint i = nb;
		uint j;
		while (i != 0)
		{
			j++;
			i / 10;
		}
		bytes memory str = new bytes(j);
		while (nb != 0)
		{
			str[j - 1] = bytes1(uint8(48 + (nb % 10)));
			nb /= 10;
		}
		return string(str);
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
		balance[msg.sender] += msg.value;
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
		require(valeurwei < balance[msg.sender], "solde pas bon");
		payable(msg.sender).transfer(valeurwei);
		balance[msg.sender] -= valeurwei;
	}

	function withdrawadd(address ad, uint amont) public onlyOwner {
		uint valeurwei = amont * 1 ether;
		require(valeurwei < balance[ad], "solde pas bon");
		payable(msg.sender).transfer(valeurwei);
		balance[ad] -= valeurwei;
	}

  /*function init() private {
	whitelist[msg.sender] = true;
  }*/
}
