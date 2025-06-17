# KipuBank - Smart Contract

KipuBank es un contrato inteligente desarrollado en Solidity que permite a los usuarios gestionar una bóveda personal de ETH. Los usuarios pueden depositar y retirar fondos siguiendo límites de seguridad definidos.

---

## Descripción

Este contrato permite:

- Depositar tokens nativos (ETH) en una bóveda personal
- Retirar ETH con un límite por transacción (withdrawLimit)
- Respetar un tope global de depósitos (bankCap)
- Llevar registro de la cantidad de depósitos y retiros
- Validar todas las operaciones usando errores personalizados y patrones seguros

Además, cumple con las buenas prácticas de desarrollo Web3:
Uso de variables immutable, mapping, eventos y errores personalizados
Patrón **checks-effects-interactions**
- Comentarios de documentación con formato **NatSpec**

---

## Despliegue Remix

1. Abre [Remix IDE](https://remix.ethereum.org/)
2. Crea un archivo llamado KipuBank.sol y pega el código
3. Compila con versión de Solidity 0.8.x
4. Ve a la pestaña Deploy & Run Transactions
5. Selecciona ambiente Injected Provider (usa Metamask)
6. Ingresa parámetros para el constructor:
   - _bankCap: Límite global de ETH en wei
7. Haz clic en Deploy

## Como usarlo
Una vez se haya hecho el deploy se pueden realizar las siguientes acciones:
1. deposit:
   Recibe como parametro cantidad del dinero a ser depositado y tambien debe de ponerse en value, en caso contrario
   no dejara hacer el deposito.
2. withdraw:
   Recibe como parametro cantidad del dinero a ser extraido
3. bankCap:
   Retorna el bankCap designado a la hora de deployear el contrato
4. depositCount:
   Retorna cantidad de depositos hechos a la cuenta
5. getBalance:
   Obtiene el balance insertacion la user address
6. owner
   Retorna el owner del contrato
7. totalDeposited
   Retorna el total depositado 
8. withdrawCount
   Retorna cantidad de extracciones hechos a la cuenta
9. withdrawLimit
   Retorna el withdrawLimit del contrato
Direccion del contrato deployed en Remix: 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005
