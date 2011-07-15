require 'test_helper'

class CartaoCreditoTest < TestHelper
  
  def setup
    @cartao = AprovaFacil::CartaoCredito.new(
      :valor => 25.00, 
      :numero_cartao => '4073020000000002', 
      :codigo_seguranca => '123', 
      :mes_validade => '10', 
      :ano_validade => '14', 
      :ip_comprador => '192.168.1.1', 
      :nome_portador => 'Bruno Frank Silva'
    )
  end
  
  def test_order_create
    assert_not_nil @cartao
  end
  
  def test_validations
    # Should be valid
    assert @cartao.valid?
    
    # Valor 0
    @cartao.valor = 0
    assert_equal false, @cartao.valid?
        
    # Valor nil
    @cartao.valor = nil
    assert_equal false, @cartao.valid?    
    @cartao.valor = 25.00    
    
    # Parcela nil
    @cartao.parcelas = nil
    assert_equal false, @cartao.valid?        
        
    # Parcela 0
    @cartao.parcelas = 0
    assert_equal false, @cartao.valid?    
    @cartao.parcelas = 1
    
    # Numero Cartão nil
    @cartao.numero_cartao = nil
    assert_equal false, @cartao.valid?    
        
    # Numero Cartão em branco
    @cartao.numero_cartao = ''
    assert_equal false, @cartao.valid?    
    @cartao.numero_cartao = '4073020000000002'
    
    @cartao.mes_validade = nil
    assert_equal false, @cartao.valid?
    
    @cartao.mes_validade = '1'
    assert_equal false, @cartao.valid?
    
    @cartao.mes_validade = '123'
    assert_equal false, @cartao.valid?    
    
    @cartao.mes_validade = 'aa'
    assert_equal false, @cartao.valid?    
    @cartao.mes_validade = '10'
    
    @cartao.ano_validade = nil
    assert_equal false, @cartao.valid?
    
    @cartao.ano_validade = '1'
    assert_equal false, @cartao.valid?    
    
    @cartao.ano_validade = '123'
    assert_equal false, @cartao.valid?    
    
    @cartao.ano_validade = 'aa'
    assert_equal false, @cartao.valid?    
    @cartao.ano_validade = '14'  
    
    @cartao.codigo_seguranca = nil
    assert_equal false, @cartao.valid?    
    
    @cartao.codigo_seguranca = 'aaa'
    assert_equal false, @cartao.valid?    
    @cartao.ano_validade = '123'    
    
    @cartao.ip_comprador = nil
    assert_equal false, @cartao.valid?    
    
    @cartao.ip_comprador = '123'
    assert_equal false, @cartao.valid?    
    @cartao.ip_comprador = '192.168.1.1'
  end  
end
