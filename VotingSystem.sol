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

    // Количество предложений
    uint public numProposals;

    // Конструктор, который принимает массив имен предложений и инициализирует отображение proposals
    constructor(string[] memory proposalNames) public {
        // Установка владельца контракта в адрес того, кто развернул контракт
        owner = msg.sender;

        // Установка количества предложений равным длине массива proposalNames
        numProposals = proposalNames.length;

        // Цикл по массиву proposalNames и инициализация объекта Proposal для каждого предложения
        for (uint i = 0; i < numProposals; i++) {
            proposals[i] = Proposal({
                name: proposalNames[i],
                voteCount: 0
            });
        }
    }

    // Функция vote, которая позволяет пользователю проголосовать за предложение
    function vote(uint proposalIndex) public {
        // Проверка, что proposalIndex является допустимым
        require(proposalIndex >= 0 && proposalIndex < numProposals, "Недопустимый индекс предложения");

        // Получение объекта Proposal для указанного proposalIndex
        Proposal storage proposal = proposals[proposalIndex];

        // Увеличение количества голосов за объект Proposal
        proposal.voteCount += 1;
    }

    // Получение победившего предложения
    function getWinner() public view returns (string memory winnerName, uint winnerVoteCount) {
        // Установка начального значения максимального количества голосов равным 0
        uint maxVotes = 0;

        // Цикл по всем предложениям и поиск предложения с наибольшим количеством голосов
        for (uint i = 0; i < numProposals; i++) {
            // Получение объекта Proposal для текущего индекса
            Proposal storage proposal = proposals[i];

            // Проверка, что текущее предложение имеет больше голосов, чем текущее максимальное
            if (proposal.voteCount > maxVotes) {
                // Обновление максимального количества голосов, имени и количества голосов победителя
                maxVotes = proposal.voteCount;
                winnerName = proposal.name;
                winnerVoteCount = proposal.voteCount;
            }
        }
    }
}
