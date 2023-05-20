pragma ton-solidity >= 0.57.0;

// Интерфейс контракта VotingSystem с комментариями
interface IVotingSystem {
    // Структура Proposal для хранения названия предложения и количества голосов за него
    struct Proposal {
        string name;
        uint voteCount;
    }

    // Адрес владельца контракта
    address public owner;

    // Отображение индекса предложения на объект Proposal
    mapping(uint => Proposal) public proposals;

    // Количество предложений
    uint public numProposals;

    // Функция голосования, позволяющая пользователю проголосовать за предложение
    function vote(uint proposalIndex) external;

    // Функция для получения победившего предложения
    function getWinner() external view returns (string memory winnerName, uint winnerVoteCount);
}
