# BuyApp
## Sobre
Aplicação simples feita com Flutter simulando um aplicativo de compras.

A aplicação consiste em uma tela principal com uma lista de produtos gerados aleatoriamente que podem ser adicionados a um carrinho de compras. Ao acessar o carrinho de compras, esses itens podem ser "comprados" utilizando um saldo preestabelecido ou removidos do carrinho.

Por motivos de simplicidade, esta aplicação não faz acesso a banco de dados.

## Funcionamento
O funcionamento da aplicação é baseado no tutorial [Get Started:Write your first Flutter app](https://flutter.dev/docs/get-started/codelab), que detalha o passo a passo para o desenvolvimento de uma lista de palavras que possibilita salvar itens como favoritos. Nesta aplicação, esse conceito foi transformado em um carrinho de compras em um aplicativo de vendas online.

O tutorial também utiliza o pacote english_words para gerar palavras pseudoaleatórias para povoar a lista de itens. Nesta aplicação, o mesmo pacote foi utilizado para gerar marcas pseudoaleatórias para os produtos à venda. O tipo de produto e sua respectiva imagem foram selecionados de forma pseudoaleatória de uma lista preestabelecida com 10 itens.

Além da tela inicial de itens e do carrinho de compras, a aplicação conta com uma tela simples de perfil, onde o saldo do usuário, inicialmente definido como "R$1000,00", pode ser checado.

## Execução
A aplicação pode ser executada em sua versão web através do comando "flutter run -d web-server" e utilizada em um navegador qualquer através do endereço localhost com a porta fornecida.
