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

Para efetuar uma compra é necessário criar uma instância da classe CartaoCredito com os dados da compra e do cartão de crédito a ser debitado.

```ruby
  cartao = AprovaFacil::CartaoCredito.new(
   :valor => 25.00,
   :numero_cartao    => '4073020000000002', 
   :codigo_seguranca => '123', 
   :mes_validade     => '10', 
   :ano_validade     => '14', 
   :bandeira         => AprovaFacil::CartaoCredito::Bandeira::VISA
   :ip_comprador     => '192.168.1.1', 
   :nome_portador    => 'Ford Prefect'
  )
```

### Outros atributos disponíveis

<table>
  <tr>
    <th>Atributo</th>
    <th>Descrição</th>
    <th>Obrigatório?</th>
    <th>Valor padrão</th>    
  </tr>
  <tr>
    <td>:documento</td>
    <td>Número do documento do sistema</td>
    <td>Não</td>
    <td></td>    
  </tr>
  <tr>
    <td>:valor</td>
    <td>Valor da transação</td>
    <td>Sim</td>
    <td>0.00</td>    
  </tr>
  <tr>
    <td>:numero_cartao</td>
    <td>Número do cartão</td>
    <td>Sim</td>
    <td></td>    
  </tr>
  <tr>
    <td>:codigo_seguranca</td>
    <td>Código de segurança do cartão</td>
    <td>Sim</td>
    <td></td>    
  </tr>
  <tr>
    <td>:mes_validade</td>
    <td>Mês de validade do cartão</td>
    <td>Sim</td>
    <td></td>    
  </tr>        
  <tr>
    <td>:ano_validade</td>
    <td>Ano de validade do cartão</td>
    <td>Sim</td>
    <td></td>    
  </tr>
  <tr>
    <td>:ip_comprador</td>
    <td>Ip do comprador</td>
    <td>Sim</td>
    <td></td>    
  </tr>
  <tr>
    <td>:parcelas</td>
    <td>Quantidade de parcelas</td>
    <td>Não</td>
    <td>01</td>    
  </tr>
  <tr>
    <td>:bandeira</td>
    <td>Bandeira, veja abaixo</td>
    <td>Não</td>
    <td>VISA</td>    
  </tr>
  <tr>
    <td>:nome_portador</td>
    <td>Nome do portador do cartão</td>
    <td>Não</td>
    <td></td>    
  </tr>          
  <tr>
    <td>:cpf_portador</td>
    <td>CPF do portador do cartão</td>
    <td>Não</td>
    <td></td>    
  </tr>
  <tr>
    <td>:data_nascimento</td>
    <td>Data de nascimento do portador do cartão</td>
    <td>Não</td>
    <td></td>    
  </tr>
  <tr>
    <td>:nome_mae</td>
    <td>Nome da mão do portador do cartão</td>
    <td>Não</td>
    <td></td>    
  </tr>
  <tr>
    <td>:parcelamento_administradora</td>
    <td>Informa se será parcelado pela loja ou pela adminsitrador</td>
    <td>Não</td>
    <td>True</td>    
  </tr>        
</table>

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

Após criar o cartão, deve-se solicitar a aprovação da transação.

```ruby
  aprova_facil = AprovaFacil.new
  resultado = aprova_facil.aprovar(cartao)
```

### Resultados

```ruby
  :aprovada           # True ou  false
  :resultado          # Descrição do resultado do pedido
  :codigo_autorizacao # Código de autorização retornado pela administradora do cartão.
  :transacao          # ID da transação do Aprova Fácil.
  :cartao_mascarado   # Número do cartão de crédito mascarado. Eg. 444433******1111
  :numero_documento   # ID do pedido.
```

Captura
-------

  Entende­-se por captura o processo de confirmação de uma transação. Captura é a efetivação da venda. 

  De acordo com os padrões ISO 8583, todas as transações aprovadas pelas Administradoras de Cartões de Crédito devem ser capturadas (confirmadas) pela aplicação do Lojista. 

  Após essa confirmação, a reserva de crédito estabelecida na aprovação é transformada em um débito efetivo no
cartão do Cliente.

  Caso a transação não seja confirmada no prazo estipuladoa mesma será automaticamente cancelada, sem a efetivação do débito.

  Tal informação será exibida no campo  “Data  Hora Cancelamento” do extrato do Aprova Fácil.

```ruby
  aprova_facil = AprovaFacil.new
  resultado = aprova_facil.capturar('123123123') # Numero da transação
```

### Resultados

```ruby
  :capturado # True ou false
  :resultado # Descrição da captura
```

Cancelamento
------------

  O cancelamento de uma transação somente poderá ser realizado quando a mesma for aprovada pela Administradora e confirmada pelo Lojista. Por isso, para que o Aprova Fácil possa realizar o 
cancelamento, este deve ser  solicitado no mesmo dia em que a transação foi processada, 
ou seja, foi confirmada pela Administradora.

```ruby
  aprova_facil = AprovaFacil.new
  resultado = aprova_facil.cancelar('123123') # Numero da transação
```

### Resultados

```ruby
  :cancelado        # true ou false
  :resultado        # Descrição do cancelamento
  :nsu_Cancelamento # Número de cancelamento da Administradora
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
  :aprovada           # True ou  false
  :resultado          # Descrição   da   aprovação   do resultado do pedido
  :codigo_autorizacao # Código   de   autorização   retornado pela Administradora  do  cartão  de crédito
  :transacao          # ID da transação Aprova Fáci
  :cartao_mascarado   # Número   mascarado   do   Cartão   de Crédito Eg. 444433******1111
  :numero_documento   # ID do pedido da companhia
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