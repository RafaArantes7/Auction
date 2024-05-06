// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// vamos comçear criando interface para interação entre contratos.

interface IERC721 {
    function transferFrom(address, address, uint) external ;
}

contract Auction {
    IERC721 public nft; // variavel do tipo interface que queremos criar, no caso ERC721.
    uint public nftId; // variavel do id do nft que sera vendido

    address payable public seller; // endereço do vendedoo do nft. payable o dinheiro vai pra ele quando for concluido.balance;

    //aqui vamos criar um variavel para saber quando o leilão termina
    uint endTime;

    // informações do leião, como quem esta ganhando, lance maximo e etc.

    address public highestBidder; // quem mandou o maior lance
    uint public highestBid; // qual foi o maior lance
    mapping(address=> uint) bids; // nos leva de um endereço de quem fez o lance para o lance da pessoa. uma lista de bids.
    bool ended;

    event BidPlaced(address indexed bidder, uint amount); // este evento é acionado sempre que um novo lance for colocado no leilão. endereço e valor do lance
    event AuctionEnded(address indexed winner, uint amount, address indexed seller);
    // o parametro indexed  é usado para otimizar a pesquisa e filtragem eventos nos logs de transação


    constructor(address _nft, uint _nftId) {
        nft = IERC721(_nft);
        nftId = _nftId;
// iniciando o leilão agora abaixo
        nft.transferFrom(msg.sender, address(this) , nftId );
        endTime = block.timestamp + 7 days;

    }

// agora vamos criar a função de mandar um lance para o leilão
function bid() external payable {
    require(block.timestamp < endTime); // garantir que o leilão não acabou
    require(msg.value > highestBid); /// aqui o lance tem que ser maior que o ultimo lance

    highestBid = msg.value;
    highestBidder = msg.sender;
    bids[msg.sender]+= msg.value;

    }

    function withdraw() external {
        require(msg.sender != highestBidder); // garantir que a pessoa não é o highestbidder
        uint bal = bids[msg.sender]; // aqui vamos registrar qual o saldo da pessoa
        bids[msg.sender] = 0; // vamos salvar o saldo dela na variavel memória e zeramos o saldo dela. Questão de segurança
        payable (msg.sender).transfer(bal); // vamos transferir o valor dele.    
         }

    
// função agora para que o nft seja transferir e o dono seja pago

    function end() external {
        require(!ended);
        require (block.timestamp > endTime); //aqui garantimos que ja acabou o leilão
        ended = true; // aqui é para que seja feita somente 1x todo o processo
        nft.transferFrom(address(this), highestBidder, nftId); // aqui  vamos transferir o nft
        seller.transfer(highestBid);

        highestBidder = address(0); // isso para que ele possa retirar lances interiores caso tiver
        
    }



}