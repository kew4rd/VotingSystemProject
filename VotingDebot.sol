pragma ton-solidity >= 0.57.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "Debot.sol";
import "Terminal.sol";
import "VotingSystemInterface.sol";

contract HelloDebot is Debot {

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string caption, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "";
        version = "";
        publisher = "";
        key = "";
        author = "";
        support = address.makeAddrStd(0, 0x0);
        hello = "";
        language = "en";
        dabi = m_debotAbi.get();
        icon = "";
    }

    // Эта функция обязательно должна быть в каждом деботе
    // Она возвращает список из ID используемых в деботе интерфейсов
    // ID явно и жёстко прописаны в контрактах интерфейсов - менять их не надо!
    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID ];
    }

    // Функция точки входа для DeBot.
    // Эта функция обязательно должна быть в каждом деботе
    // Отсюда начинается его работа
    function start() public override {
        Terminal.print(0, "I can send you a proposal that has the most votes");
        Terminal.input(tvm.functionId(setUserInput), "How is it going?", false);
    }

    function setUserInput(string value) public pure{
        optional(uint256) pubkey = 0;
        Terminal.print(0, "Now winner is " + value);
        IVotingSystem(addrContract).getWinner{
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(printResult),
            onErrorId: tvm.functionId(onError)
        }
    }
}