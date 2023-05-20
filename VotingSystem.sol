pragma ton-solidity >= 0.57.0;

contract VotingSystem {
    // Структура Proposal для хранения названия предложения и количества голосов за него
    struct Proposal {
        string name;
        uint voteCount;
    }

    // Адрес владельца контракта
    address public owner;

    address[] public votedAddresses;

    // Отображение индекса предложения на объект Proposal
    mapping(uint256 => Proposal) public proposals;

    // Количество предложений
    uint public numProposals;

    // Конструктор, который принимает массив имен предложений и инициализирует отображение proposals
    constructor(string[] proposalNames) public {
        owner = msg.sender;

        numProposals = proposalNames.length;

        for (uint i = 0; i < numProposals; i++) {
            proposals[i] = Proposal({
                name: proposalNames[i],
                voteCount: 0
            });
        }
    }
    function hasVoted(address addr) private view returns (bool) {
        for (uint i = 0; i < votedAddresses.length; i++) {
            if (votedAddresses[i] == addr) {
                return true;
            }
        }
        return false;
    }

    // Функция vote, которая позволяет пользователю проголосовать за предложение
    function vote(uint proposalIndex) public {
        require(proposalIndex >= 0 && proposalIndex < numProposals, 101, "Invalid index");
        require(!hasVoted(msg.sender), 101, "You already voted"); 

        Proposal proposal = proposals[proposalIndex];
        proposal.voteCount += 1;

        votedAddresses.push(msg.sender);
    }

    // Получение победившего предложения
    function getWinner() public view returns (string winnerName, uint winnerVoteCount) {
        uint maxVotes = 0;
        for (uint i = 0; i < numProposals; i++) {
            Proposal proposal = proposals[i];
            if (proposal.voteCount > maxVotes) {
                maxVotes = proposal.voteCount;
                winnerName = proposal.name;
                winnerVoteCount = proposal.voteCount;
            }
        }
        return (winnerName, winnerVoteCount);
    }
}
