// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.x;

/// @title KipuBank - Billetera de ETH con límites para depósitos y retiros aprobados
/// @author Brandon Calderon Cubero
/// @notice Permite a los usuarios depositar y retirar ETH bajo reglas seguras y documentadas.
/// @author Kipu/// @notice Se tomo como referencia el contrato de BilleteraSimple.sol
contract KipuBank {
    /// @notice Límite fijo de retiro por transacción: 3 ETH
    uint256 public ummutable WithdrawLimit = 3 ether;

    /// @notice Límite global de depósitos permitidos en el banco (en wei)
    uint256 public bankCap;

    /// @notice Total global de ETH depositado (en wei)
    uint256 public totalDeposited;

    /// @notice Conteo de depósitos exitosos
    uint256 public depositCount;

    /// @notice Conteo de retiros exitosos
    uint256 public withdrawCount;

    /// @dev Mapeo que almacena el saldo interno de cada usuario
    mapping(address => uint256) private vault;

    /// @notice Dirección del propietario (owner) del contrato
    address public immutable owner;

    /// @notice Evento emitido tras un depósito exitoso
    /// @param user Dirección que depositó
    /// @param amount Monto depositado en wei
    event Deposit(address indexed user, uint256 amount);

    /// @notice Evento emitido tras un retiro exitoso
    /// @param user Dirección que retiró
    /// @param amount Monto retirado en wei
    event Withdrawal(address indexed user, uint256 amount);

    /// @notice Error si un depósito excede el límite global
    /// @param attempted Monto acumulado tras intento de depósito
    /// @param available Límite restante disponible
    error ExceedsBankCap(uint256 attempted, uint256 available);

    /// @notice Error si un retiro excede el límite por transacción
    /// @param attempted Monto solicitado
    /// @param limit Límite máximo permitido
    error ExceedsWithdrawLimit(uint256 attempted, uint256 limit);

    /// @notice Error si no hay saldo suficiente para retirar
    /// @param available Saldo disponible
    /// @param required Saldo requerido
    error InsufficientBalance(uint256 available, uint256 required);

    /// @notice Error si función onlyOwner es llamada por otro
    error OnlyOwner();

    /// @notice Constructor que fija bankCap y owner
    /// @param _bankCap Límite global de depósitos en wei
    constructor(uint256 _bankCap) {
        bankCap = _bankCap;
        owner = msg.sender;
    }

    /// @notice Modificador para funciones exclusivas del propietario
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    /// @notice Permite recibir ETH directamente en el contrato
    /// @dev Procesa depósito anónimo usando _processDeposit
    receive() external payable {
        _processDeposit(msg.sender, msg.value);
    }

    /// @notice Deposita ETH validando parámetro vs msg.value
    /// @param amount Monto en wei a depositar
    function deposit(uint256 amount) external payable {
        require(msg.value == amount, "msg.value != amount");
        _processDeposit(msg.sender, amount);
    }

    /// @dev Lógica interna de depósito usada por receive() y deposit()
    function _processDeposit(address sender, uint256 amount) private {
        if (totalDeposited + amount > bankCap) {
            revert ExceedsBankCap(totalDeposited + amount, bankCap);
        }
        vault[sender] += amount;
        totalDeposited += amount;
        depositCount++;
        emit Deposit(sender, amount);
    }

    /// @notice Retira ETH de la bóveda del remitente
    /// @param amount Monto en wei a retirar
    function withdraw(uint256 amount) external {
        if (amount > WithdrawLimit) revert ExceedsWithdrawLimit(amount, WithdrawLimit);
        uint256 bal = vault[msg.sender];
        if (amount > bal) revert InsufficientBalance(bal, amount);

        // Checks → Effects → Interactions
        vault[msg.sender] = bal - amount;
        totalDeposited -= amount;
        withdrawCount++;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");
        emit Withdrawal(msg.sender, amount);
    }

    /// @notice Consulta el saldo de un usuario en la bóveda
    /// @param user Dirección a consultar
    /// @return balance Saldo en wei
    function getBalance(address user) external view returns (uint256 balance) {
        return vault[user];
    }
}
