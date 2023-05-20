pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

abstract contract Debot {

    uint8 constant DEBOT_ABI = 1;

    uint8 m_options;
    optional(string) m_debotAbi;
    // Неактуально. Для совместимости со старым DEngine.
    optional(string) m_targetAbi;
    // Неактуально. Для совместимости со старым DEngine.
    optional(address) m_target;

    /*
     * Публичный интерфейс дебота
     */

    // Точка входа ДеБота.
    function start() public virtual;

    // Возвращает метаданные DeBot.
    // return name Строка с именем дебота, например, "DePool".
    // return version версия debot, которая будет преобразована в строку типа "x.y.z".
    // return publisher Строка с информацией о том, кто развернул debot в blokchain, например, "TON Labs".
    // return caption (10-20 символов) Строка с кратким описанием, например, "Работа с Smthg".
    // return author Строка с именем автора DeBot, например, "Иван Иванов".
    // return support Everscale адрес автора для вопросов и пожертвований.
    // return hello Строка с первым сообщением с описанием DeBot.
    // return language (ISO-639) Строка с языком интерфейса debot, например, "en".
    // return dabi Строка с ABI дебота.
    function getDebotInfo() public functionID(0xDEB) view virtual returns(
        string name, string version, string publisher, string caption, string author,
        address support, string hello, string language, string dabi, bytes icon);

    // Возвращает список интерфейсов, используемых Деботом.
    function getRequiredInterfaces() public view virtual returns (uint256[] interfaces);

    // Возвращает ABI ДеБота.
    /// Утратил актуальность.
    function getDebotOptions() public view returns (uint8 options, string debotAbi, string targetAbi, address targetAddr) {
        debotAbi = m_debotAbi.hasValue() ? m_debotAbi.get() : "";
        targetAbi = m_targetAbi.hasValue() ? m_targetAbi.get() : "";
        targetAddr = m_target.hasValue() ? m_target.get() : address(0);
        options = m_options;
    }

    // Позволяет установить ABI debot. Сделайте это перед использованием debot.
    function setABI(string dabi) public {
        require(tvm.pubkey() == msg.pubkey(), 100);
        tvm.accept();
        m_options |= DEBOT_ABI;
        m_debotAbi = dabi;
    }
}