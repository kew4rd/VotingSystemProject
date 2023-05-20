pragma ton-solidity >= 0.57.0;

contract VotingSystem {
    // Структура Proposal для хранения названия предложения и количества голосов за него
    struct Proposal {
        string name;
        uint voteCount;
    }

    // Адрес владельца контракта
    address public owner;

    // Отображение индекса предложения на объект Proposal
    mapping(uint => Proposal) public proposals;

    // Словарь для проверки голосовавших
    mapping(address => bool) public hasVoted;

    // Количество предложений
    uint public numProposals;

    // Конструктор, который принимает массив имен предложений и инициализирует отображение proposals
    constructor(string[] memory proposalNames) public {
        owner = msg.sender;

        numProposals = proposalNames.length;

        for (uint i = 0; i < numProposals; i++) {
            proposals[i] = Proposal({
                name: proposalNames[i],
                voteCount: 0
            });
        }
    }

    // Функция vote, которая позволяет пользователю проголосовать за предложение
    function vote(uint proposalIndex) public {
        require(proposalIndex >= 0 && proposalIndex < numProposals, "Invalid proposal index");
        require(!hasVoted[msg.sender], "Already voted"); // Проверка пользователя

        Proposal storage proposal = proposals[proposalIndex];
        proposal.voteCount += 1;

        hasVoted[msg.sender] = true;
    }

    // Получение победившего предложения
    function getWinner() public view returns (string memory winnerName, uint winnerVoteCount) {
        uint maxVotes = 0;

        for (uint i = 0; i < numProposals; i++) {
            Proposal storage proposal = proposals[i];
            if (proposal.voteCount > maxVotes) {
                maxVotes = proposal.voteCount;
                winnerName = proposal.name;
                winnerVoteCount = proposal.voteCount;
            }
        }
    }
}
