Aprova Fácil
------------

Gem para integração com Gateway Aprova Fácil da [Cobrebem](https://www.cobrebemx.com.br).

COMO USAR
---------

### Configuração

O primeiro passo é instalar a gem.

```ruby
  gem install aprova_facil
```

Depois de instalar, você precisará informar seus dados.

```ruby
  AprovaFacil::Config.usuario = '<usuario>' # usuário fornecido pela Cobrebem
```

No caso de um abiente de teste ou desenvolvimento também é possível passar o parâmetro

```ruby
  AprovaFacil::Config.teste = true
```

Efetuando uma aprovação
-----------------------

Para efetuar uma compra é necessário preencher uma instância da classe CartaoCredito, 
segue abaixo os dados básicos para uma aprovação.

```ruby
  cartao = AprovaFacil::CartaoCredito.new(
   :valor => 25.00,
   :numero_cartao    => '4073020000000002, 
   :codigo_seguranca => '123', 
   :mes_validade     => '10', 
   :ano_validade     => '14', 
   :bandeira         => AprovaFacil::CartaoCredito::Bandeira::VISA
   :ip_comprador     => '192.168.1.1', 
   :nome_portador    => 'Ford Prefect'
  )
```

### Outros campos disponíveis

```ruby
  :documento                        # Número do documento do sistema. 
  :valor                            # Valor da transação (obrigatório)
  :numero_cartao                    # Número do cartão (obrigatório) claro! :D
  :codigo_seguranca                 # Código de segurança do cartão. (obrigatório)
  :mes_validade                     # Mês de validade do cartão (obrigatório)
  :ano_validade                     # Ano de validade do cartão (obrigatório)
  :ip_comprador                     # Ip do comprador (obrigatório)
  :parcelas                         # Quantidade de parcelas. Padrão: 01
  :bandeira,                        # Bandeira, veja abaixo. padrão: VISA
  :nome_portador,                   # Nome do portador do cartão.
  :cpf_portador,                    # CPF do portador do cartão.
  :data_nascimento,                 # Data de nascimento do portador do cartão.
  :nome_mae                         # Nome da mão do portador do cartão.
  :parcelamento_administradora      # Informa se será parcelado pela loja ou pela adminsitrador. Padrão: true
```

### Bandeiras

```ruby
  AprovaFacil::CartaoCredito::Bandeira::VISA      
  AprovaFacil::CartaoCredito::Bandeira::MASTERCARD
  AprovaFacil::CartaoCredito::Bandeira::DINERS    
  AprovaFacil::CartaoCredito::Bandeira::AMEX      
  AprovaFacil::CartaoCredito::Bandeira::HIPERCARD 
  AprovaFacil::CartaoCredito::Bandeira::JCB       
  AprovaFacil::CartaoCredito::Bandeira::SOROCRED  
  AprovaFacil::CartaoCredito::Bandeira::AURA      
```

Após criar o cartão deve ser solicidade uma aprovação.

```ruby
  aprova_facil = AprovaFacil.new
  resultado = aprova_facil.aprovar(cartao)
```

### Resultados

```ruby
  :aprovada           => True ou  false
  :resultado          => Descrição do resultado do pedido
  :codigo_autorizacao => Código de autorização retornado pela administradora do cartão.
  :transacao          => ID da transação do Aprova Fácil.
  :cartao_mascarado   => Número do cartão de crédito mascarado. Eg. 444433******1111
  :numero_documento   => ID do pedido.
```

Captura
-------

  Entende­se  por   captura   o processo de confirmação de uma transação, o que caracteriza a venda 
efetivada, sendo realizado assim, o débito no cartão de crédito do cliente.
  De acordo com os padrões ISO 8583, todas as transações aprovadas pelas Administradoras de 
Cartões de Crédito devem ser capturadas (confirmadas) pela aplicação do Lojista.
  Caso a transação não seja capturada (confirmada) pela aplicação do Lojista, no prazo estipulado 
pelas Administradoras de Cartões Crédito,  a mesma será automaticamente desfeita, não havendo assim o 
débito  efetivo  no  cartão  de  crédito  do  cliente,  essa  informação  será  exibida   no  campo  
“Data  Hora Cancelamento”do Extrato do Aprova Fácil.

```ruby
  aprova_facil = AprovaFacil.new
  resultado = aprova_facil.capturar('123123123') # Código da transação
```

### Resultados

```ruby
  :capturado => True ou false
  :resultado => Descrição da captura
```

Cancelamento
------------

  O cancelamento de uma transação somente poderá ser realizado quando a mesma for aprovada pela 
Administradora e confirmada pelo lojista. Por isso, para que o Aprova Fácil possa realizar o 
cancelamento, este deve ser  solicitado no mesmo dia em que a transação foi processada, 
ou seja, foi confirmada pela Administradora.

```ruby
  aprova_facil = AprovaFacil.new
  resultado = aprova_facil.aprovar(cartao)
```

### Resultados

```ruby
  :cancelado        => true ou false
  :resultado        => Descrição do cancelamento
  :nsu_Cancelamento => Número de cancelamento da Administradora
```

Recorrencia
-----------

  A recorrência de transações é utilizada, quando se deseja efetuar novos débitos em um cartão de
crédito, seja esta de qualquer  periodicidade; é possível alterar  o valor  do débito a cada cobrança, se
necessário.
  O processo de "re­cobrança" em uma recorrência, se difere do processo de "re­cobrança" em um
agendamento. A re­cobrança em uma recorrência é comandada pela aplicação do lojista, nesse caso, deve
ser  informado apenas o número que identifica a última transação aprovada e confirmada, sendo este,
representado pelo parâmetro "Transacao".

```ruby
  aprova_facil = AprovaFacil.new
  resultado = aprova_facil.recobrar('123123', 25.00)
```

Assinatura do método de recobrança.

```ruby
  def recobrar(transacao, valor, parcelas = '01', parcelamento_admin = true )
```

### Resultados

```ruby
  :aprovada           => True ou  false
  :resultado          => Descrição   da   aprovação   do resultado do pedido
  :codigo_autorizacao => Código   de   autorização   retornado pela Administradora  do  cartão  de crédito
  :transacao          => ID da transação Aprova Fáci
  :cartao_mascarado   => Número   mascarado   do   Cartão   de Crédito Eg. 444433******1111
  :numero_documento   => ID do pedido da companhia
```

AUTOR:
------

Bruno Frank Silva Cordeiro bfscordeiro (at) gmail (dot) com

LICENÇA:
--------

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.